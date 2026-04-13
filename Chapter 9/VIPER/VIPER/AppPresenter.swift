//
//  AppPresenter.swift
//  VIPER
//
//  Created by Eric Vennaro on 2/4/23.
//

import Foundation

protocol AppPresenterProto {
    func present(for launchState: LaunchState)
}

final class AppPresenter: AppPresenterProto {
    private let router: AppRouterProto
    private let photoRepository: RepositoryProto
    
    init (
        router: AppRouterProto,
        photoRepository: RepositoryProto
    ) {
        self.router = router
        self.photoRepository = photoRepository
    }
    
    func present(for launchState: LaunchState) {
        switch launchState {
        case .auth:
            // no-op
            break
        case .main:
            let view = MainRouter.createModule(photoRepository: photoRepository)
            router.pushMainApp(view)
            break
        case .onboarding:
            // no-op for now
            break
        }
    }
}
