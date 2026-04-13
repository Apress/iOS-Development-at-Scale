//
//  OnboardingCoordinator.swift
//  MVC+Coord
//
//  Created by Eric Vennaro on 12/31/22.
//

import UIKit

enum OnboardingScreen: Int {
    case first
    case last
}
protocol OnboardingCoordinatorDelegate: AnyObject {
    func didTapNext(_ vc: UIViewController, for screen: OnboardingScreen)
    func didTapBack(_ vc: UIViewController, from screen: OnboardingScreen)
}

final class OnboardingCoordinator: BaseCoordinator {
    var onboardingScreen2: Onboarding2ViewController?
    
    override func start() {
        let onboardingScreen = Onboarding1ViewController()
        router.setRootModule(onboardingScreen, hideBar: false)
        onboardingScreen.cDelegate = self
    }
}

extension OnboardingCoordinator: OnboardingCoordinatorDelegate {
    func didTapNext(_ vc: UIViewController, for screen: OnboardingScreen) {
        switch screen {
        case .first:
            if onboardingScreen2 == nil {
                onboardingScreen2 = Onboarding2ViewController()
                onboardingScreen2?.cDelegate = self
            }
            router.push(onboardingScreen2, transition: nil)
        case .last:
            finishFlow?()
        }
    }
    
    func didTapBack(_ vc: UIViewController, from screen: OnboardingScreen) {
        // naive logic given we have two controllers in the flow and no other states.
        if screen == .last {
            router.popModule(transition: nil)
        } else {
            print("unsupported")
        }
    }
}
