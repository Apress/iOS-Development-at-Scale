//
//  BaseCoordinator.swift
//  MVC+Coord
//
//  Created by Eric Vennaro on 12/30/22.
//

// Base class provides sensible defaults
class BaseCoordinator: CoordinatorProto {
//    var vcFactory: VCFactoryProto
    var router: RouterProto
//    var coordinatorFactory: CoordinatorFactoryProto
    var childCoordinators: [CoordinatorProto] = []
    // optional completion for when flow is finished.
    // use a closure here to show both delegates and closures
    // in one example. It is best practice to instead, pick one and
    // and stick with that.
    var finishFlow: (() -> Void)?
    
    init(
//        vcFactory: VCFactoryProto,
        router: RouterProto
//        coordinatorFactory: CoordinatorFactoryProto
    ) {
//        self.vcFactory = vcFactory
        self.router = router
//        self.coordinatorFactory = coordinatorFactory
    }
    
    func add(_ coordinator: CoordinatorProto) {
        for element in childCoordinators {
            if element === coordinator { return }
        }
        childCoordinators.append(coordinator)
    }

    func remove(_ coordinator: CoordinatorProto?) {
        guard childCoordinators.isEmpty == false,
          let coordinator = coordinator else { return }
        
        for (index, element) in
            childCoordinators.enumerated() {
            if element === coordinator {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
    func start() {
        start(with: nil)
    }

    // optional for deep link functionality
    func start(with option: DeepLinkOption?) {
        fatalError("Subclass must implement")
    }
}
