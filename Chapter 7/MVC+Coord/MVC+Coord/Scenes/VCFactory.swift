//
//  VCFactory.swift
//  MVC+Coord
//
//  Created by Eric Vennaro on 12/31/22.
//

import Foundation

class VCFactory: VCFactoryProto {
    func makePhotoStreamViewController(
        photoModel: PhotoModelProto
    ) -> PhotoStreamViewController {
        return PhotoStreamViewController(
            photoModel: photoModel)
    }
    
    func makeMainTabBarViewController(
    ) -> MainTabBarController {
        return MainTabBarController()
    }
    
    func makeSettingsViewController(
    ) -> SettingsViewController {
        return SettingsViewController()
    }
    
    func makeOnboardingViewController1(
    ) -> Onboarding1ViewController {
        return Onboarding1ViewController()
    }
    
    func makeOnboardingViewController2(
    ) -> Onboarding2ViewController {
        return Onboarding2ViewController()
    }
}
