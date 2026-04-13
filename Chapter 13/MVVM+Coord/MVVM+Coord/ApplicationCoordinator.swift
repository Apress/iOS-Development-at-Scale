//
//  ApplicationCoordinator.swift
//  MVC+Coord
//
//  Created by Eric Vennaro on 12/29/22.
//

import UIKit

// The application coordinator decides which flow to launch
final class ApplicationCoordinator: BaseCoordinator {
    private var launchState: LaunchState
    private let photoModel: PhotoModelProto
    
    init(
        router: RouterProto,
        launchState: LaunchState,
        childCoordinators: [CoordinatorProto],
        photoModel: PhotoModelProto
    ) {
        self.photoModel = photoModel
        self.launchState = launchState
        super.init(
            router: router)
    }
    
    override func start(with option: DeepLinkOption?) {
        if option != nil {
            // utilize deeplink or notif options
        } else {
            switch launchState {
            case .auth:
                runAuthFlow()
                break
            case .main:
                runMainFlow()
                break
            case .onboarding:
                runOnboardingFlow()
                break
            }
        }
    }
    
    // methods to instantiate flows
    private func runMainFlow() {
        let coordinator = MainTabBarCoordinator(
            router: router,
            childCoordinators: [],
            photoModel: photoModel)
        add(coordinator)
        coordinator.start()
    }
    
    private func runAuthFlow() {
         // no auth flow implemented
    }
    
    private func runOnboardingFlow() {
        let coordinator = OnboardingCoordinator(
            router: router
        )
        coordinator.finishFlow = { [unowned self, unowned coordinator] in
            self.remove(coordinator)
            // assumes successful completion
            self.runMainFlow()
        }
        add(coordinator)
        coordinator.start()
    }
}
