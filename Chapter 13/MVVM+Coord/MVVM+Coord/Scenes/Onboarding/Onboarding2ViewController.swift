//
//  Onboarding2ViewController.swift
//  MVC+Coord
//
//  Created by Eric Vennaro on 12/31/22.
//

import UIKit

final class Onboarding2ViewController: UIViewController {
    private lazy var onboardingView: OnboardingView = {
       let view = OnboardingView()
        return view
    }()
    
    weak var cDelegate: OnboardingCoordinatorDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onboardingView.setupView(
            withBtnTitle: "Finish!",
            color: .green,
            target: self,
            sel: #selector(tappedNext),
            event: .touchUpInside
        )
    }
    
    override func loadView() {
        view = onboardingView
    }
    
    // means you have finished the flow
    @objc func tappedNext() {
        cDelegate?.didTapNext(self, for: .last)
    }
    
    // returning to the previous screen
    @objc func tappedBack() {
        cDelegate?.didTapBack(self, from: .first)
    }
}

extension Onboarding2ViewController: Presentable {
    func toPresent() -> UIViewController? {
        return self
    }
}
