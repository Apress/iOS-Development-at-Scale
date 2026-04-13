//
//  RouterProto.swift
//  CoordinatorsComplex
//
//  Created by Eric Vennaro on 1/1/23.
//

import Foundation

import UIKit

protocol Presentable {
    func toPresent() -> UIViewController?
}

protocol RouterProto: Presentable {
    
    func push(_ module: Presentable?,
              transition: UIViewControllerAnimatedTransitioning?)
    
    func popModule(transition: UIViewControllerAnimatedTransitioning?)

    func dismissModule(animated: Bool, completion: (() -> Void)?)
    
    func setRootModule(_ module: Presentable?, hideBar: Bool)
}
