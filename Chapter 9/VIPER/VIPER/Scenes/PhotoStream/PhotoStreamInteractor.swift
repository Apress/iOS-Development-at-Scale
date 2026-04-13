//
//  Interactor.swift
//  VIPER
//
//  Created by Eric Vennaro on 2/4/23.
//

import Combine

protocol PhotoStreamInteractorProto: AnyObject {
    func getAllPhotos() -> AnyPublisher<[ModelProto], Error>
    func updateReactionCount(upCount: Int, downCount: Int)
}

final class PhotoStreamInteractor: PhotoStreamInteractorProto {
    
    private let photoRepository: RepositoryProto
    
    init(photoRepository: RepositoryProto) {
        self.photoRepository = photoRepository
    }
    
    func getAllPhotos() -> AnyPublisher<[ModelProto], Error> {
        return photoRepository.getAll().eraseToAnyPublisher()
    }
    
    func updateReactionCount(
        upCount: Int, downCount: Int) {
        // presenter should call this method to handle the update, but we mock the logic in the presenter for demonstration purposes
    }
}
