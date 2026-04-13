//
//  PhotoMO.swift
//  NetworkingLayer
//
//  Created by Eric Vennaro on 11/27/22.
//

import Foundation
import CoreData

// Managed object subclass for user
final class PhotoMO: NSManagedObject {
    typealias DomainObject = Photo
    typealias PropertiesObject = PhotoProperties
    
    @NSManaged var albumId: Int
    @NSManaged var title: String
    @NSManaged var url: URL
    @NSManaged var thumbnailUrl: URL
    
    // A unique identifier used to avoid duplicates in the persistent store.
    @NSManaged var id: Int
}

extension PhotoMO: ManagedObjectProto {
    static var coreDataEntityRepresentation: NSEntityDescription {
        return PhotoMO.entity()
    }
}

extension PhotoMO: ConvertToDomainProto {
    func convertToDomain() -> Photo {
        Photo(
            albumID: albumId,
            id: id,
            title: title,
            url: url,
            thumbnailURL: thumbnailUrl
        )
    }
}

// MARK: - Codeable

// A struct encapsulating the properties of a Photo.
struct PhotoProperties:
    Codable, ManagedObjectPropertiesProto, ConvertToDomainProto {
    typealias DomainObject = Photo
    let thumbnailUrl: URL
    let url: URL
    let title: String
    let albumId: Int
    let id: Int
    
    
    // The keys must have the same name as the attributes of the entity.
    func getDictionaryValue() -> [String: Any] {
        return [
            "thumbnailUrl": thumbnailUrl,
            "url": url,
            "title": title,
            "albumId": albumId,
            "id": id
        ]
    }
}

extension PhotoProperties {
    func convertToDomain() -> Photo {
        Photo(
            albumID: albumId,
            id: id,
            title: title,
            url: url,
            thumbnailURL: thumbnailUrl
        )
    }
}
