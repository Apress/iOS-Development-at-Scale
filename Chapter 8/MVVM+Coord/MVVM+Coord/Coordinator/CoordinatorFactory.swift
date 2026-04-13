////
////  CoordinatorFactory.swift
////  MVC+Coord
////
////  Created by Eric Vennaro on 12/30/22.
////
//
//import UIKit
//
//class CoordinatorFactory: CoordinatorFactoryProto {
//    func makeApplicationCoordinator(
//      router: RouterProto,
//      coordinatorFactory: CoordinatorFactoryProto,
//      vcFactory: VCFactoryProto,
//      photoModel: PhotoModelProto,
//      launchState: LaunchState
//    ) -> ApplicationCoordinator {
//        return ApplicationCoordinator(
//            vcFactory: vcFactory,
//            router: router,
//            coordinatorFactory: coordinatorFactory,
//            launchState: launchState,
//            childCoordinators: [],
//            photoModel: photoModel)
//    }
//    
//    func makePhotoStreamCoordinator(
//      router: RouterProto,
//      coordinatorFactory: CoordinatorFactoryProto,
//      vcFactory: VCFactoryProto,
//      photoModel: PhotoModelProto
//    ) -> PhotoStreamCoordinator {
//        let coordinator = PhotoStreamCoordinator(
//            router: router,
//            coordinatorFactory: coordinatorFactory,
//            vcFactory: vcFactory,
//            photoModel: photoModel)
//        return coordinator
//    }
//    
//    func makeTabBarCoordinator(
//        router: RouterProto,
//        coordinatorFactory: CoordinatorFactoryProto,
//        vcFactory: VCFactoryProto,
//        photoModel: PhotoModelProto
//    ) -> MainTabBarCoordinator {
//        let coordinator = MainTabBarCoordinator(
//            vcFactory: vcFactory,
//            router: router,
//            coordinatorFactory: coordinatorFactory,
//            childCoordinators: [],
//            photoModel: photoModel)
//        return coordinator
//    }
//    
//    func makeSettingsCoordinator(
//        router: RouterProto,
//        coordinatorFactory: CoordinatorFactoryProto,
//        vcFactory: VCFactoryProto
//    ) -> SettingsCoordinator {
//        return SettingsCoordinator(
//            router: router,
//            coordinatorFactory: coordinatorFactory,
//            vcFactory: vcFactory)
//    }
//    
//    func makeOnboardingCoordinator(
//        router: RouterProto,
//        coordinatorFactory: CoordinatorFactoryProto,
//        vcFactory: VCFactoryProto
//    ) -> OnboardingCoordinator {
//        return OnboardingCoordinator(
//            router: router,
//            coordinatorFactory: coordinatorFactory,
//            vcFactory: vcFactory)
//    }
//}
