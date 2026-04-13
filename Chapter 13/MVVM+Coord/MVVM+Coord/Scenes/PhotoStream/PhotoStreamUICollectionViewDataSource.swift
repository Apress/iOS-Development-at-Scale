//
//  PhotoStreamUICollectionViewDataSource.swift
//  MVC+Coord
//
//  Created by Eric Vennaro on 12/29/22.
//

import UIKit

final class PhotoStreamUICollectionViewDataSource:
    NSObject, UICollectionViewDataSource {
    
    private var photos: [PhotoViewModel] = []
    private let target: Any?
    private let selector: Selector
    
    init(target: Any?, selector: Selector) {
        self.target = target
        self.selector = selector
        super.init()
    }
    
    func update(photos: [PhotoViewModel]) {
        self.photos = photos
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PhotoStreamCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? PhotoStreamCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configureCell(
            id: photos[indexPath.row].id,
            title: photos[indexPath.row].title,
            reactionsLabelText: photos[indexPath.row].reactionsLabelText,
            thumbsUpCount: photos[indexPath.row]
                .thumbsUpCount,
            thumbsDownCount: photos[indexPath.row]
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
