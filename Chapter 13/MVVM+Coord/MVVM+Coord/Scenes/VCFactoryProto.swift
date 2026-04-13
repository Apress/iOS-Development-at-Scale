//
//  VCFactoryProto.swift
//  MVC+Coord
//
//  Created by Eric Vennaro on 12/31/22.
//

protocol VCFactoryProto {
    func makePhotoStreamViewController(
        photoStreamVM: PhotoStreamViewModelProto
    ) -> PhotoStreamViewController
    
    func makeMainTabBarViewController(
    ) -> MainTabBarController
    
    func makeSettingsViewController(
    ) -> SettingsViewController
    
    func makeOnboardingViewController1(
    ) -> Onboarding1ViewController
    
    func makeOnboardingViewController2(
    ) -> Onboarding2ViewController
}
