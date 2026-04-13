//
//  ConvertToDomainProto.swift
//  NetworkingLayer
//
//  Created by Eric Vennaro on 11/27/22.
//

import Foundation

protocol ConvertToDomainProto {
    associatedtype DomainObject
    func convertToDomain() -> DomainObject
}
