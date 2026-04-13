//
//  UserMO.swift
//  NetworkingLayer
//
//  Created by Eric Vennaro on 10/16/22.
//

import Foundation
import CoreData

// Managed object subclass for user
final class UserMO: NSManagedObject {
    typealias DomainObject = UserModel.User
    typealias PropertiesObject = UserProperties
    
    @NSManaged var name: String
    @NSManaged var email: String
    @NSManaged var username: String
    @NSManaged var phone: String
    
    // A unique identifier used to avoid duplicates in the persistent store.
    @NSManaged var id: Int
}

extension UserMO: ManagedObjectProto {
    static var coreDataEntityRepresentation: NSEntityDescription {
        return UserMO.entity()
    }
}

extension UserMO: ConvertToDomainProto {
    func convertToDomain() -> UserModel.User {
        UserModel.User(
            name: name,
            email: email,
            username: username,
            phone: phone,
            id: id)
    }
}

// MARK: - Codeable

// A struct encapsulating the properties of a User.
struct UserProperties: Codable, ManagedObjectPropertiesProto, ConvertToDomainProto {
    typealias DomainObject = UserModel.User
    let name: String
    let email: String
    let username: String
    let phone: String
    let id: Int
    
    
    // The keys must have the same name as the attributes of the entity.
    func getDictionaryValue() -> [String: Any] {
        return [
            "name": name,
            "email": email,
            "username": username,
            "phone": phone,
            "id": id
        ]
    }
}

extension UserProperties {
    func convertToDomain() -> UserModel.User {
        UserModel.User(
            name: name,
            email: email,
            username: username,
            phone: phone,
            id: id)
    }
}
