////
////  CoordinatorFactoryProto.swift
////  MVC+Coord
////
////  Created by Eric Vennaro on 12/31/22.
////
//
//import UIKit
//
//protocol CoordinatorFactoryProto {
//    func makeApplicationCoordinator(
//        router: RouterProto,
//        coordinatorFactory: CoordinatorFactoryProto,
//        vcFactory: VCFactoryProto,
//        photoModel: PhotoModelProto,
//        launchState: LaunchState
//    ) -> ApplicationCoordinator
//  
//    func makeTabBarCoordinator(
//        router: RouterProto,
//        coordinatorFactory: CoordinatorFactoryProto,
//        vcFactory: VCFactoryProto,
//        photoModel: PhotoModelProto
//    ) -> MainTabBarCoordinator
//    
//    func makePhotoStreamCoordinator(
//      router: RouterProto,
//      coordinatorFactory: CoordinatorFactoryProto,
//      vcFactory: VCFactoryProto,
//      photoModel: PhotoModelProto
//    ) -> PhotoStreamCoordinator
//    
//    func makeSettingsCoordinator(
//        router: RouterProto,
//        coordinatorFactory: CoordinatorFactoryProto,
//        vcFactory: VCFactoryProto
//    ) -> SettingsCoordinator
//    
//    func makeOnboardingCoordinator(
//        router: RouterProto,
//        coordinatorFactory: CoordinatorFactoryProto,
//        vcFactory: VCFactoryProto
//    ) -> OnboardingCoordinator
//}
