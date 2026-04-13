//
//  MainTabBarViewController.swift
//  MVC+Coord
//
//  Created by Eric Vennaro on 12/30/22.
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
