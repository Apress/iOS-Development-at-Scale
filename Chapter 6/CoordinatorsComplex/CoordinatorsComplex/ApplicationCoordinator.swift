//
//  ApplicationCoordinator.swift
//  CoordinatorsComplex
//
//  Created by Eric Vennaro on 1/1/23.
//

import UIKit

// The application coordinator decides if we should launch to the main application, authentication, or onboarding
final class ApplicationCoordinator: BaseCoordinator {
    private var launchState: LaunchState
    
    init(
        router: RouterProto,
        launchState: LaunchState,
        childCoordinators: [CoordinatorProto]
    ) {
        self.launchState = launchState
        super.init(router: router)
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
            childCoordinators: [])
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

