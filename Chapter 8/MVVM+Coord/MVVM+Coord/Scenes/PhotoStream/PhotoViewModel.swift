//
//  PhotoViewModel.swift
//  MVVM+Coord
//
//  Created by Eric Vennaro on 1/18/23.
//

struct PhotoViewModel {
    let title: String
    let id: Int
    let reactionsLabelText: String
    let thumbsUpCount: Int
    let thumbsDownCount: Int
}

extension PhotoViewModel: Equatable {
    static func == (lhs: PhotoViewModel, rhs: PhotoViewModel) -> Bool {
        return lhs.id == rhs.id
        && lhs.title == rhs.title
        && lhs.reactionsLabelText == rhs.reactionsLabelText
        && lhs.thumbsUpCount == rhs.thumbsUpCount
        && lhs.thumbsDownCount == rhs.thumbsDownCount
    }
}
