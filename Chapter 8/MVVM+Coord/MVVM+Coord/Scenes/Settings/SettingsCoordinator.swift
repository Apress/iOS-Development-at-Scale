//
//  SettingsCoordinator.swift
//  MVC+Coord
//
//  Created by Eric Vennaro on 12/31/22.
//

import UIKit

protocol SettingsCoordinatorDelegate: AnyObject {
    func didSelectRow(_ vc: SettingsViewController, with name: String)
}

final class SettingsCoordinator: BaseCoordinator {
    
//    init(
//        router: RouterProto
////        coordinatorFactory: CoordinatorFactoryProto,
////        vcFactory: VCFactoryProto
//    ) {
//        super.init(
////            vcFactory: vcFactory,
//            router: router)//,
////            coordinatorFactory: coordinatorFactory)
//    }
    
    override func start() {
        let settingsVC = SettingsViewController()
        router.setRootModule(settingsVC, hideBar: false)
        settingsVC.setupTabBar()
        settingsVC.cDelegate = self
    }
}

extension SettingsCoordinator: SettingsCoordinatorDelegate {
    func didSelectRow(_ vc: SettingsViewController, with name: String) {
        print("should navigate: \(name)")
    }
}
