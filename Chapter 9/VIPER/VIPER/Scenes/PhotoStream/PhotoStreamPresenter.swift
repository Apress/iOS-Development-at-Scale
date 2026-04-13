//
//  PhotoStreamPresenter.swift
//  VIPER
//
//  Created by Eric Vennaro on 2/4/23.
//

import UIKit
import Combine

enum LoadingState {
    case none
    case loading
    case finished
    case finishedWithError(Error)
}

protocol PhotoStreamPresenterProto: AnyObject {
    // Cannot use the @Published annotation in a protocol so we expose the type
    var allPhotosPublished:
    Published<[PhotoModel.Photo]>.Publisher { get }
    var loadingStatePublished:
    Published<LoadingState>.Publisher { get }
    
    func getAllPhotos()
    func updateReactionCount(
        upCount: Int, downCount: Int)
}

final class PhotoStreamPresenter: PhotoStreamPresenterProto {
    var allPhotosPublished: Published<[PhotoModel.Photo]>.Publisher { $allPhotos }
    @Published private var allPhotos: [PhotoModel.Photo] = []
    
    var loadingStatePublished: Published<LoadingState>.Publisher { $loadingState }
    @Published private var loadingState: LoadingState = .none
    
    private var cancellables: Set<AnyCancellable> = []
    private let router: PhotoStreamRouterProto
    private let interactor: PhotoStreamInteractorProto
    
    init(
        interactor: PhotoStreamInteractorProto,
        router: PhotoStreamRouterProto
    ) {
        self.interactor = interactor
        self.router = router
    }
    
    func getAllPhotos() {
        loadingState = .loading
        interactor.getAllPhotos()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                // potential area to handle errors and edge cases
                switch result {
                case .finished:
                    self?.loadingState = .finished
                    break
                case .failure(let error):
                    self?.loadingState = .finishedWithError(error)
                    break
                }
            } receiveValue: { [weak self] photos in
                guard let sSelf = self else {
                    return
                }
                sSelf.allPhotos = photos
                    .compactMap{ $0 as? PhotoModel.Photo }
            }.store(in: &cancellables)
    }
    
    func updateReactionCount(
        upCount: Int,
        downCount: Int
    ) {
        // we would send an update to our network layer, instead loop through and
        // update all reactions. This is purely for illustration purposes
        for photo in allPhotos {
            photo.reactions.update(upCount: upCount, downCount: downCount)
        }
        allPhotos = allPhotos
    }
}
