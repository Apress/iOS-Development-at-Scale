//
//  SettingsRouter.swift
//  VIPER
//
//  Created by Eric Vennaro on 2/5/23.
//

import UIKit

protocol SettingsRouterProto: AnyObject {
    func pushDetail()
    static func createModule() -> UINavigationController
}

final class SettingsRouter: SettingsRouterProto {
    private weak var presenter: SettingsPresenter?
    private weak var view: UINavigationController?
     
    func pushDetail() {
        view?.pushViewController(SettingsDetailedViewController(), animated: true)
    }
    
    static func createModule() -> UINavigationController {
        let router = SettingsRouter()
        let interactor = SettingsInteractor()
        let presenter = SettingsPresenter()
        let view = SettingsViewController()
        let navView = UINavigationController(rootViewController: view)
        view.setupTabBar()
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = view
        view.presenter = presenter
        interactor.presenter = presenter
        router.presenter = presenter
        router.view = navView
        
        return navView
    }
}
