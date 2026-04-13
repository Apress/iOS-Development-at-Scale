//
//  MainTabBarCoordinator.swift
//  CoordinatorsComplex
//
//  Created by Eric Vennaro on 1/1/23.
//

import UIKit

final class MainTabBarCoordinator: BaseCoordinator {
    
    init(
        router: RouterProto,
        childCoordinators: [CoordinatorProto]
    ) {
        super.init(router: router)
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
            router: photoStreamRouter)
        
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

