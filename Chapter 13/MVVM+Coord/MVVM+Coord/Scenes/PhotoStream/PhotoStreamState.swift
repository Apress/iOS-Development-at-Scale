//
//  PhotoStreamState.swift
//  MVVM+Coord
//
//  Created by Eric Vennaro on 1/18/23.
//

import Combine

typealias PhotoStreamViewModelOuput =
AnyPublisher<PhotoStreamState, Never>

enum PhotoStreamState {
    case loading
    case success([PhotoViewModel])
    case failure(Error)
}

extension PhotoStreamState: Equatable {
    static func == (
        lhs: PhotoStreamState,
        rhs: PhotoStreamState
    ) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading): return true
        case (.success(let lhsPhotos),
              .success(let rhsPhotos)):
            return lhsPhotos == rhsPhotos
        case (.failure, .failure): return true
        default: return false
        }
    }
}
