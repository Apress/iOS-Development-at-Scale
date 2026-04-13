//
//  PhotoStreamRouter.swift
//  VIPER
//
//  Created by Eric Vennaro on 2/4/23.
//

import UIKit

protocol PhotoStreamRouterProto: AnyObject {
    static func createModule(
        photoRepository: RepositoryProto
    )-> PhotoStreamViewController
}

final class PhotoStreamRouter: PhotoStreamRouterProto {
    private weak var viewController: UIViewController?
    
    static func createModule(
        photoRepository: RepositoryProto
    ) -> PhotoStreamViewController {
        let router = PhotoStreamRouter()
        let interactor = PhotoStreamInteractor(photoRepository: photoRepository)
        let presenter = PhotoStreamPresenter(
            interactor: interactor,
            router: router
        )
        let view = PhotoStreamViewController(presenter: presenter)
        router.viewController = view
        
        return view
    }
}
