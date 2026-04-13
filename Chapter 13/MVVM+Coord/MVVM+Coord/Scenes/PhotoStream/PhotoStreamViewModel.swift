//
//  PhotoStreamViewModel.swift
//  MVVM+Coord
//
//  Created by Eric Vennaro on 1/15/23.
//

import Combine
import Foundation

protocol PhotoStreamViewModelProto {
    var vcTitle: String { get }
    func transform(input: PhotoStreamViewModelInput) -> PhotoStreamViewModelOuput
}

final class PhotoStreamViewModel: PhotoStreamViewModelProto {
    let vcTitle: String = "Photo Stream"
    private let photos: [PhotoViewModel] = []
    private let photoModel: PhotoModelProto
    private var cancellables: [AnyCancellable] = []

    init(photoModel: PhotoModelProto) {
        self.photoModel = photoModel
    }
    
    func transform(
        input: PhotoStreamViewModelInput
    ) -> PhotoStreamViewModelOuput {
        input
            .reaction
            .sink { [unowned self] selection in
            let upCount =
                selection.reactionType ==
                    .thumbsUp ? 1 : 0
            let downCount =
                selection.reactionType ==
                    .thumbsDown ? 1 : 0
            self.photoModel.updateReactionCount(
                id: selection.id,
                upCount: upCount,
                downCount: downCount)
        }.store(in: &cancellables)
        let loading: PhotoStreamViewModelOuput = input
            .appear.map({_ in .loading }).eraseToAnyPublisher()
        let v = photoModel
            .allPhotosPublished
            .receive(on: DispatchQueue.main).map {
                photos in
                let t = photos.map {
                    PhotoViewModelBuilder
                        .buildPhotoStreamViewModel(photo: $0)
                }
                return t.isEmpty ? .loading : .success(t)
            }
            .merge(with: loading)
            .removeDuplicates()
            .eraseToAnyPublisher()
        photoModel.getAllPhotos()
        return v
    }
}

extension PhotoStreamViewModel: Equatable {
    static func == (
        lhs: PhotoStreamViewModel,
        rhs: PhotoStreamViewModel
    ) -> Bool {
        return lhs.photos == rhs.photos
    }
}
