//
//  Router.swift
//  MVC+Coord
//
//  Created by Eric Vennaro on 10/16/22.
//

// NOTE: This is just an example of how router can be implemented and does not cover all cases, this is not
// production ready

import UIKit

final class Router: NSObject, RouterProto {
    
    private weak var rootController: UINavigationController?
    private var completions: [UIViewController : () -> Void]
    private var transition: UIViewControllerAnimatedTransitioning?
    
    init(rootController: UINavigationController) {
        self.rootController = rootController
        self.completions = [:]
        super.init()
        self.rootController?.delegate = self
    }
    
    func toPresent() -> UIViewController? {
        return self.rootController
    }
    
    func present(_ module: Presentable?, transition: UIViewControllerAnimatedTransitioning? = nil) {
        guard let controller = module?.toPresent() else { return }
        self.rootController?.present(controller, animated: true, completion: nil)
    }
    
    func push(_ module: Presentable?, transition: UIViewControllerAnimatedTransitioning? = nil) {
        guard let controller = module?.toPresent(),
              (controller is UINavigationController == false)
        else { return }
        self.rootController?.pushViewController(controller, animated: true)
    }
    
    func popModule(transition: UIViewControllerAnimatedTransitioning? = nil)  {
        self.transition = transition
        if let controller = rootController?.popViewController(animated: true) {
            self.runCompletion(for: controller)
        }
    }
    
    func dismissModule(animated: Bool, completion: (() -> Void)?) {
        self.rootController?.dismiss(animated: animated, completion: completion)
    }
    
    func setRootModule(_ module: Presentable?, hideBar: Bool) {
        guard let controller = module?.toPresent() else { return }
        rootController?.setViewControllers([controller], animated: false)
        rootController?.isNavigationBarHidden = hideBar
      }
    
    func popToRootModule(animated: Bool) {
        if let controllers = self.rootController?.popToRootViewController(animated: animated) {
            controllers.forEach { controller in
                self.runCompletion(for: controller)
            }
        }
    }
    
    private func runCompletion(for controller: UIViewController) {
        guard let completion = self.completions[controller] else { return }
        completion()
        completions.removeValue(forKey: controller)
    }
}

extension Router: UINavigationControllerDelegate {
    
    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        
        return self.transition
    }
    
    // allows the router to listen to back button events and take appropriate action
    public func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated: Bool
    ) {
        guard let poppedViewController = navigationController.transitionCoordinator?.viewController(
            forKey: .from
        ), !navigationController.viewControllers.contains(
            poppedViewController
        ) else {
            return
        }
        runCompletion(for: poppedViewController)
    }
}

