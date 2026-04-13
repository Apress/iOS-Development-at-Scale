//
//  RouterProto.swift
//  MVC+Coord
//
//  Created by Eric Vennaro on 12/31/22.
//

import UIKit

protocol Presentable {
    func toPresent() -> UIViewController?
}

protocol RouterProto: Presentable {
    
    func present(_ module: Presentable?,
                 transition: UIViewControllerAnimatedTransitioning?)
    
    func push(_ module: Presentable?,
              transition: UIViewControllerAnimatedTransitioning?)
    
    func popModule(transition: UIViewControllerAnimatedTransitioning?)

    func dismissModule(animated: Bool, completion: (() -> Void)?)
    
    func setRootModule(_ module: Presentable?, hideBar: Bool)
    
    func popToRootModule(animated: Bool)
}
