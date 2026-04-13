//
//  Photo.swift
//  NetworkingLayer
//
//  Created by Eric Vennaro on 11/26/22.
//

import Foundation
import Combine

protocol PhotoModelProto {
    // Cannot use the @Published annotation in a protocol so we expose the type
    var allPhotosPublished:
    Published<[PhotoModel.Photo]>.Publisher { get }
    func getAllPhotos()
    func updateReactionCount(id: Int, upCount: Int, downCount: Int)
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
    
    var allPhotosPublished: Published<[Photo]>.Publisher { $allPhotos }
    @Published private var allPhotos: [PhotoModel.Photo] = []
    
    private var cancellables: Set<AnyCancellable> = []
    private let photoRepository: RepositoryProto
    
    init(photoRepository: RepositoryProto) {
        self.photoRepository = photoRepository
    }
    
    func getAllPhotos() {
        photoRepository.getAll().receive(on: DispatchQueue.main)
            .sink { result in
                // potential area to handle errors and edge cases
                switch result {
                    case .finished:
                        break
                    case .failure(let error):
                        print("Error: \(error)")
                }
            } receiveValue: { [weak self] photos in
                guard let sSelf = self else {
                    return
                }
                sSelf.allPhotos = photos
                    .compactMap{ $0 as? PhotoModel.Photo }
            }.store(in: &cancellables)
    }
    
    // fake update reactions on photo,
    // just updates all photos uniformly
    func updateReactionCount(
        id: Int,
        upCount: Int,
        downCount: Int
    ) {
        // we would send an update to our network layer, instead loop through and
        // update all reactions. This is purely for illustration purposes
        for photo in allPhotos {
            if (photo.id == id) {
                photo.reactions.update(upCount: upCount, downCount: downCount)
            }
        }
        
        allPhotos = allPhotos
    }
}
