//
//  PhotoStreamUICollectionViewDataSource.swift
//  MVC+Coord
//
//  Created by Eric Vennaro on 12/29/22.
//

import UIKit

final class PhotoStreamUICollectionViewDataSource:
    NSObject, UICollectionViewDataSource {
    
    private var photos: [PhotoModel.Photo] = []
    private let target: Any?
    private let selector: Selector
    
    init(target: Any?, selector: Selector) {
        self.target = target
        self.selector = selector
        super.init()
    }
    
    func update(photos: [PhotoModel.Photo]) {
        self.photos = photos
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "cell",
            for: indexPath
        ) as? PhotoStreamCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configureCell(
            title: photos[indexPath.row].title,
            reactionsLabelText: photos[indexPath.row]
                .reactions
                .reactionsLabelText,
            thumbsUpCount: photos[indexPath.row]
                .reactions
                .thumbsUpCount,
            thumbsDownCount: photos[indexPath.row]
                .reactions
                .thumbsDownCount,
            target: target,
            sel: selector)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
}
