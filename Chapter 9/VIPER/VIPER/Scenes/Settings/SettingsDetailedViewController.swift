//
//  SettingsDetailedViewController.swift
//  VIPER
//
//  Created by Eric Vennaro on 2/5/23.
//

import UIKit

final class SettingsDetailedViewController: UIViewController {
    private lazy var backgroundView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    override func loadView() {
        view = backgroundView
    }
}

