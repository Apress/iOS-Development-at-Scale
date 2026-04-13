//
//  AppRouter.swift
//  VIPER
//
//  Created by Eric Vennaro on 2/4/23.
//

import UIKit

protocol AppRouterProto: AnyObject {
    func pushMainApp(_ view: UIViewController)
    func pushOnboardingFlow()
    func pushAuthFlow()
    static func createModule(
        windowScene: UIWindowScene,
        photoRepository: RepositoryProto
    ) -> AppPresenterProto
}

final class AppRouter: AppRouterProto {
    private let window: UIWindow
    private var navigationController: UINavigationController?
    
    private init(window: UIWindow) {
        self.window = window
    }
    
    func pushMainApp(_ view: UIViewController) {
        let navigationController = UINavigationController(rootViewController: view)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func pushOnboardingFlow() {
        // no navigation controller.
    }
    
    func pushAuthFlow() {
        // no - op
    }
    
    static func createModule(
        windowScene: UIWindowScene,
        photoRepository: RepositoryProto
    ) -> AppPresenterProto {
        let router = AppRouter(window: UIWindow(windowScene: windowScene))
        let presenter = AppPresenter(
            router: router,
            photoRepository: photoRepository)
        
        return presenter
    }
}
