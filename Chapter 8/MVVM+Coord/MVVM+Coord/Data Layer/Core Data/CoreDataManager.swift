//
//  CoreDataManager.swift
//  NetworkingLayer
//
//  Created by Eric Vennaro on 10/16/22.
//

import CoreData
import Combine

final class CoreDataManager: LocalStorageManagerProto {
    private let inMemory: Bool
    private let container: NSPersistentContainer
    private var notificationToken: NSObjectProtocol?
    // A peristent history token used for fetching transactions from the store.
    private var lastToken: NSPersistentHistoryToken?
    
    init(
        persistentContainer: NSPersistentContainer,
        inMemory: Bool = false
    ) {
        self.inMemory = inMemory
        self.container = persistentContainer

        // Observe Core Data remote change notifications on the queue where the changes were made.
        notificationToken = NotificationCenter.default.addObserver(
            forName: .NSPersistentStoreRemoteChange, object: nil, queue: nil) { note in
            print("Received a persistent store remote change notification.")
            Task {
                await self.fetchPersistentHistory()
            }
        }
    }

    deinit {
        if let observer = notificationToken {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    // Uses `NSBatchInsertRequest` (BIR) to import a JSON dictionary
    // into the Core Data store on a private queue.
    func importEntities(
        from propertiesList: [ManagedObjectPropertiesProto],
        for entity: ManagedObjectProto.Type) async throws {
        guard !propertiesList.isEmpty else { return }

        let taskContext = newTaskContext()
        // Add name and author to identify source of persistent history changes.
        taskContext.name = "importContext"
        taskContext.transactionAuthor = "coreDataManagerImportEntities"

        try await taskContext.perform {
            // Execute the batch insert
            let batchInsertRequest = self.newBatchInsertRequest(
                with: propertiesList,
                entityDescription: entity.coreDataEntityRepresentation)
            if let fetchResult = try? taskContext.execute(batchInsertRequest),
               let batchInsertResult = fetchResult as? NSBatchInsertResult,
               let success = batchInsertResult.result as? Bool, success {
                return
            }
            print("Failed to execute batch insert request.")
            throw CoreDataError.batchInsertError
        }
        print("Successfully inserted data.")
    }
    
    // Fetch entities synchronously, if this was to take too long I suggest optimizing the query
    // due to core data's handling of threading
    func getAllEntities<T>(
        for entityName: String,
        _type: T.Type) throws -> AnyPublisher<[T], Error> {
        let taskContext = newTaskContext()
        return taskContext.performAndWait {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            guard let fetchResult = try? taskContext.execute(request),
                  let getResult = fetchResult as? NSAsynchronousFetchResult<NSFetchRequestResult>,
                  let mos = getResult.finalResult as? [T] else {
                return Fail(error: CoreDataError.fetchError).eraseToAnyPublisher()
            }

            return CurrentValueSubject(mos).eraseToAnyPublisher()
        }
    }
    
    func deleteAllEntities(for entityName: String) async throws  {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.returnsObjectsAsFaults = false
        let asyncFetch = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) {
            [weak self] result in
            
            guard let sSelf = self,
                  let results = result.finalResult else {
                return
            }
            let entities = results.compactMap { $0 as? NSManagedObject }
            Task {
                try await sSelf.deleteEntities(entities)
            }
        }
        
        do {
            let backgroundContext = container.newBackgroundContext()
            try backgroundContext.execute(asyncFetch)
        } catch let error {
            print("Detele all data error :", error)
        }
    }
    
    // Asynchronously deletes records in the Core Data store
    // with the specified managed objects.
    private func deleteEntities(_ entities: [NSManagedObject]) async throws {
        let objectIDs = entities.map { $0.objectID }
        let taskContext = newTaskContext()
        // Add name and author to identify source of persistent history changes.
        taskContext.name = "deleteContext"
        taskContext.transactionAuthor = "coreDataManagerDeleteEntities"
        print("Start deleting data from the store...")

        try await taskContext.perform {
            // Execute the batch delete.
            let batchDeleteRequest = NSBatchDeleteRequest(objectIDs: objectIDs)
            guard let fetchResult = try? taskContext.execute(batchDeleteRequest),
                  let batchDeleteResult = fetchResult as? NSBatchDeleteResult,
                  let success = batchDeleteResult.result as? Bool, success
            else {
                print("Failed to execute batch delete request.")
                throw CoreDataError.batchDeleteError
            }
        }

        print("Successfully deleted data.")
    }

    private func newBatchInsertRequest(
        with propertyList: [ManagedObjectPropertiesProto],
        entityDescription: NSEntityDescription
    ) -> NSBatchInsertRequest {
        var index = 0
        let total = propertyList.count

        // Provide one dictionary at a time when the closure is called.
        let batchInsertRequest = NSBatchInsertRequest(
            entity: entityDescription,
            dictionaryHandler: { dictionary in
                guard index < total else { return true }
                dictionary.addEntries(from: propertyList[index].getDictionaryValue())
                index += 1
                return false
        })
        return batchInsertRequest
    }

    private func fetchPersistentHistory() async {
        do {
            try await fetchPersistentHistoryTransactionsAndChanges()
        } catch {
            print("\(error.localizedDescription)")
        }
    }

    private func fetchPersistentHistoryTransactionsAndChanges() async throws {
        let taskContext = newTaskContext()
        taskContext.name = "persistentHistoryContext"
        print("Start fetching persistent history changes from the store...")

        try await taskContext.perform {
            // Execute the persistent history change since the last transaction.
            let changeRequest = NSPersistentHistoryChangeRequest.fetchHistory(after: self.lastToken)
            let historyResult = try taskContext.execute(changeRequest) as? NSPersistentHistoryResult
            if let history = historyResult?.result as? [NSPersistentHistoryTransaction],
               !history.isEmpty {
                self.mergePersistentHistoryChanges(from: history)
                return
            }

            print("No persistent history transactions found.")
            throw CoreDataError.persistentHistoryChangeError
        }

        print("Finished merging history changes.")
    }

    private func mergePersistentHistoryChanges(from history: [NSPersistentHistoryTransaction]) {
        print("Received \(history.count) persistent history transactions.")
        // Update view context with objectIDs from history change request.
        let viewContext = container.viewContext
        viewContext.perform {
            for transaction in history {
                guard let changes = transaction.changes else { continue; }
                for change in changes {
                    print(change.changedObjectID)
                }
                viewContext.mergeChanges(fromContextDidSave: transaction.objectIDNotification())
                self.lastToken = transaction.token
            }
        }
    }
    
    // Creates and configures a private queue context.
    private func newTaskContext() -> NSManagedObjectContext {
        // Create a private queue context.
        let taskContext = container.newBackgroundContext()
        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        // Set unused undoManager to nil for macOS (it is nil by default on iOS)
        // to reduce resource requirements.
        taskContext.undoManager = nil
        return taskContext
    }
}



