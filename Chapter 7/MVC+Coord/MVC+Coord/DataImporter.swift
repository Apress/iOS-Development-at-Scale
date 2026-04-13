//
//  DataImporter.swift
//  NetworkingLayer
//
//  Created by Eric Vennaro on 10/16/22.
//

import Foundation
import CoreData

class DataImporter {
  let importContext: NSManagedObjectContext

  init(persistentContainer: NSPersistentContainer) {
    importContext = persistentContainer.newBackgroundContext()
    // tell Core Data to overwrite the stored values with the new values
    importContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
  }
}
