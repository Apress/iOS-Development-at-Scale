//
//  PhotoStreamViewModelInput.swift
//  MVVM+Coord
//
//  Created by Eric Vennaro on 1/18/23.
//

import Combine

// struct to wrap view model input
struct ReactionSelection {
    let id: Int
    let reactionType: ReactionType
}

struct PhotoStreamViewModelInput {
    // called when a screen becomes visible
    let appear: AnyPublisher<Void, Never>
    // called when the user reactions to a photo
    let reaction: AnyPublisher<ReactionSelection, Never>
}
