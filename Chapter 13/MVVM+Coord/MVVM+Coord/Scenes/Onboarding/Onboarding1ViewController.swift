//
//  Onboarding1ViewController.swift
//  MVC+Coord
//
//  Created by Eric Vennaro on 12/31/22.
//

import UIKit

final class Onboarding1ViewController: UIViewController {
    private lazy var onboardingView: OnboardingView = {
       let view = OnboardingView()
        return view
    }()
    
    weak var cDelegate: OnboardingCoordinatorDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onboardingView.setupView(
            withBtnTitle: "Next",
            color: .blue,
            target: self,
            sel: #selector(tappedNext),
            event: .touchUpInside
        )
    }
    
    override func loadView() {
        view = onboardingView
    }
    
    @objc func tappedNext() {
        cDelegate?.didTapNext(self, for: .first)
    }
}

extension Onboarding1ViewController: Presentable {
    func toPresent() -> UIViewController? {
        return self
    }
}
