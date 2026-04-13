//
//  PhotoStreamCoordinator.swift
//  MVC+Coord
//
//  Created by Eric Vennaro on 12/30/22.
//

import UIKit

final class PhotoStreamCoordinator: BaseCoordinator {
    private let photoModel: PhotoModelProto
    
    init(
        router: RouterProto,
        photoModel: PhotoModelProto
    ) {
        self.photoModel = photoModel
        super.init(router: router)
    }
    
    override func start() {
        let photoStreamVC = PhotoStreamViewController(
            photoModel: photoModel)
        router.setRootModule(photoStreamVC, hideBar: false)
    }
}

