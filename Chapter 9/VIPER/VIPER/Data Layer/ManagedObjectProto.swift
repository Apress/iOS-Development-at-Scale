//
//  ManagedObjectProto.swift
//  NetworkingLayer
//
//  Created by Eric Vennaro on 11/27/22.
//

import Foundation
import CoreData

protocol ManagedObjectProto: NSManagedObject {
//    associatedtype PropertiesObject
   static var coreDataEntityRepresentation: NSEntityDescription { get }
}
