//
//  MainTabBarViewController.swift
//  CoordinatorsComplex
//
//  Created by Eric Vennaro on 1/1/23.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension MainTabBarController: Presentable {
    func toPresent() -> UIViewController? {
        self
    }
}

