//
//  PhotoStreamCoordinator.swift
//  CoordinatorsComplex
//
//  Created by Eric Vennaro on 1/1/23.
//

import UIKit

final class PhotoStreamCoordinator: BaseCoordinator {
    
    override func start() {
        let photoStreamVC = PhotoStreamViewController()
        router.setRootModule(photoStreamVC, hideBar: false)
    }
}


