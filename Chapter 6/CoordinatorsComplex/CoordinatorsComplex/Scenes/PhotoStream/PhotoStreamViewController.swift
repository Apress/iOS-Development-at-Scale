//
//  PhotoStreamViewController.swift
//  CoordinatorsComplex
//
//  Created by Eric Vennaro on 1/1/23.
//

import UIKit

final class PhotoStreamViewController: UIViewController {
    private lazy var photoView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    override func viewDidLoad() {
        navigationController?.tabBarItem.title = "Photos"
    }
    
    override func loadView() {
        view = photoView
    }
}

extension PhotoStreamViewController: Presentable {
    func toPresent() -> UIViewController? {
        return self
    }
}
