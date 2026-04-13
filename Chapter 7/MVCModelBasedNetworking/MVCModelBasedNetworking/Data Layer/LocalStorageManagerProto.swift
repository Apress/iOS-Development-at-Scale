//
//  LocalStorageManagerProto.swift
//  NetworkingLayer
//
//  Created by Eric Vennaro on 11/27/22.
//

import Foundation
import Combine

protocol LocalStorageManagerProto {
    func importEntities(
        from propertiesList: [ManagedObjectPropertiesProto],
        for entity: ManagedObjectProto.Type) async throws
    func deleteAllEntities(for entityName: String) async throws
    func getAllEntities<T>(for entityName: String, _type: T.Type) throws -> AnyPublisher<[T], Error>
}
