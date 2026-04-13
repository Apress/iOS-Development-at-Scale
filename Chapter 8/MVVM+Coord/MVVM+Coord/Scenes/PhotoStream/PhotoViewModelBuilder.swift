//
//  PhotoViewModelBuilder.swift
//  MVVM+Coord
//
//  Created by Eric Vennaro on 1/18/23.
//

final class PhotoViewModelBuilder {
    //chose to do this as one model, depending on size, preferences could split this to two. You could also have sub object like "dataClass" to simply collate reactions. This is up to you and design of the application. No hard and fast rule.
    static func buildPhotoStreamViewModel(photo: PhotoModel.Photo) -> PhotoViewModel {
        let downCount = photo.reactions.thumbsDownCount
        let upCount = photo.reactions.thumbsUpCount
        let label = buildReactionsLabelText(thumbsUpCount: upCount, thumbsDownCount: downCount)
        return PhotoViewModel(
            title: photo.title,
            id: photo.id,
            reactionsLabelText: label,
            thumbsUpCount: upCount,
            thumbsDownCount: downCount
        )
    }
    
    private static func buildReactionsLabelText(
        thumbsUpCount: Int,
        thumbsDownCount: Int
    ) -> String {
        return "\(thumbsUpCount) 👍 and" +
        "\(thumbsDownCount) 👎"
    }
}
