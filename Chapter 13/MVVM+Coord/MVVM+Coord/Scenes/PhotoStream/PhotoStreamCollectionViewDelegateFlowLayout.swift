//
//  PhotoStreamCollectionViewDelegateFlowLayout.swift
//  MVC+Coord
//
//  Created by Eric Vennaro on 12/29/22.
//

import UIKit

final class PhotoStreamCollectionViewDelegateFlowLayout:
    NSObject, UICollectionViewDelegateFlowLayout {
    
    private let flowLayout: UICollectionViewFlowLayout
    
    init(flowLayout: UICollectionViewFlowLayout) {
        self.flowLayout = flowLayout
        super.init()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let numberOfItemsPerRow: CGFloat = 1
        let spacing: CGFloat = flowLayout.minimumInteritemSpacing
        let availableWidth = width - spacing * (numberOfItemsPerRow + 1)
        let itemDimension = floor(availableWidth / numberOfItemsPerRow)
        return CGSize(width: itemDimension, height: itemDimension)
    }
}
