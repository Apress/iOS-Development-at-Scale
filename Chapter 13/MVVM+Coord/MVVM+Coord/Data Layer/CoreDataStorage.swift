//
//  CoreDataStorage.swift
//  NetworkingLayer
//
//  Created by Eric Vennaro on 10/16/22.
//

import Foundation
import CoreData

enum ChangeType {
  case inserted, deleted, updated

  var userInfoKey: String {
    switch self {
    case .inserted: return NSInsertedObjectIDsKey
    case .deleted: return NSDeletedObjectIDsKey
    case .updated: return NSUpdatedObjectIDsKey
    }
  }
}

class CoreDataStorage {
  // configure and create persistent container
  // viewContext.automaticallyMergesChangesFromParent is set to true

    func publisher<T: NSManagedObject>(for managedObject: T,
                                       in context: NSManagedObjectContext,
                                       changeTypes: [ChangeType]) -> AnyPublisher<(object: T?, type: ChangeType), Never> {

      let notification = NSManagedObjectContext.didMergeChangesObjectIDsNotification
      return NotificationCenter.default.publisher(for: notification, object: context)
        .compactMap({ notification in
          for type in changeTypes {
            if let object = self.managedObject(with: managedObject.objectID, changeType: type,
                                                             from: notification, in: context) as? T {
              return (object, type)
            }
          }

          return nil
        })
        .eraseToAnyPublisher()
    }
    
    func managedObject(with id: NSManagedObjectID, changeType: ChangeType,
                       from notification: Notification, in context: NSManagedObjectContext) -> NSManagedObject? {
      guard let objects = notification.userInfo?[changeType.userInfoKey] as? Set<NSManagedObjectID>,
            objects.contains(id) else {
        return nil
      }

      return context.object(with: id)
    }
}
