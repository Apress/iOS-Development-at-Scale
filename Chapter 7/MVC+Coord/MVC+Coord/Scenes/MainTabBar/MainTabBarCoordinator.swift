//
//  MainTabBarCoordinator.swift
//  MVC+Coord
//
//  Created by Eric Vennaro on 12/30/22.
//

import UIKit

final class MainTabBarCoordinator: BaseCoordinator {
    private let photoModel: PhotoModelProto
    
    init(
        router: RouterProto,
        childCoordinators: [CoordinatorProto],
        photoModel: PhotoModelProto
    ) {
        self.photoModel = photoModel
        super.init(
            router: router)
    }

    override func start() {
        let tabBar = MainTabBarController()
        let photoStreamNavController = setupPhotoStreamNav()
        let settingsNavController = setupSettingsNav()
        
        tabBar.viewControllers = [photoStreamNavController, settingsNavController]
        router.setRootModule(tabBar, hideBar: true)
    }
    
    private func setupPhotoStreamNav() -> UINavigationController {
        let photoStreamNavController = UINavigationController()
        let photoStreamRouter = Router(rootController: photoStreamNavController)
        
        let photoStreamCoordinator = PhotoStreamCoordinator(
            router: photoStreamRouter,
            photoModel: photoModel)
        
        add(photoStreamCoordinator)
        photoStreamCoordinator.start()
        
        return photoStreamNavController
    }
    
    private func setupSettingsNav() -> UINavigationController {
        let settingsNavController = UINavigationController()
        let settingsRouter = Router(rootController: settingsNavController)

        let settingsCoordinator = SettingsCoordinator(
            router: settingsRouter)
        
        add(settingsCoordinator)
        settingsCoordinator.start()
        
        return settingsNavController
    }
}
