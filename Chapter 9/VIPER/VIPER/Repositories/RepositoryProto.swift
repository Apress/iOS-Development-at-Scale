//
//  RepositoryProto.swift
//  NetworkingLayer
//
//  Created by Eric Vennaro on 11/27/22.
//

import Combine

protocol RepositoryProto {
    func getAll() -> AnyPublisher<[ModelProto], Error>
    func get(identifier: Int) -> ModelProto?
    func create<T>(entity: T) -> Bool
    func update<T>(entity: T) -> Bool
    func delete<T>(entity: T) -> Bool
}
