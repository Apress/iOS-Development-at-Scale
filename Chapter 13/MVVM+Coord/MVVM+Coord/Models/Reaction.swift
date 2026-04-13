//
//  Reaction.swift
//  MVCModelBasedNetworking
//
//  Created by Eric Vennaro on 12/28/22.
//

final class ReactionModel {
    var thumbsUpCount: Int
    var thumbsDownCount: Int
    
    init(
        thumbsUpCount: Int = 0,
        thumbsDownCount: Int = 0
    ) {
        self.thumbsUpCount = thumbsUpCount
        self.thumbsDownCount = thumbsDownCount
    }
    
    // creates a mutable function so we can mock updates,
    // ideally models are immutable
    func update(upCount: Int, downCount: Int) {
        thumbsUpCount = thumbsUpCount + upCount
        thumbsDownCount = thumbsDownCount + downCount
    }
}
