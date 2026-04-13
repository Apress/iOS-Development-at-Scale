//
//  CoreDataError.swift
//  NetworkingLayer
//
//  Created by Eric Vennaro on 11/6/22.
//

import Foundation

enum CoreDataError: Error {
    case persistentHistoryChangeError
    case batchDeleteError
    case batchInsertError
    case fetchError
}
