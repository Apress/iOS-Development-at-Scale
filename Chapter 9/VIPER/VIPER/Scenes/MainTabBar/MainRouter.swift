//
//  MainRouter.swift
//  VIPER
//
//  Created by Eric Vennaro on 2/4/23.
//

import UIKit

protocol MainRouterProto {
    static func createModule(
        photoRepository: RepositoryProto
    ) -> UIViewController
}

final class MainRouter: MainRouterProto {
    
    static func createModule(
        photoRepository: RepositoryProto
    ) -> UIViewController {
        let tabBar = MainTabBarController()
        let photoStreamNavController =
        UINavigationController(
            rootViewController:
                PhotoStreamRouter.createModule(
                    photoRepository: photoRepository)
        )
        let settingsVC = SettingsRouter.createModule()
        
        tabBar.viewControllers = [photoStreamNavController, settingsVC]
        
        return tabBar
    }
}
