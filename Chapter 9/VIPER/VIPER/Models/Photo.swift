//
//  Photo.swift
//  NetworkingLayer
//
//  Created by Eric Vennaro on 11/26/22.
//

import Foundation
import Combine

protocol PhotoModelProto {

}

final class PhotoModel: PhotoModelProto, ObservableObject {
    
    struct Photo: ModelProto {
        let albumID: Int
        let id: Int
        let title: String
        let url: URL
        let thumbnailURL: URL
        let reactions: ReactionModel
        
        init(
            albumID: Int,
            id: Int,
            title: String,
            url: URL,
            thumbnailURL: URL,
            reactions: ReactionModel = ReactionModel()
        ) {
            self.albumID = albumID
            self.id = id
            self.title = title
            self.url = url
            self.thumbnailURL = thumbnailURL
            self.reactions = reactions
        }
    }
}
