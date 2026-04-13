//
//  OnboardingView.swift
//  MVC+Coord
//
//  Created by Eric Vennaro on 12/31/22.
//

import UIKit

// generic view for onboarding
final class OnboardingView: UIView {
    private lazy var btn: UIButton = {
        let btn = UIButton()
        addSubview(btn)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(
        withBtnTitle title: String,
        color: UIColor,
        target: Any?,
        sel: Selector,
        event: UIControl.Event
    ) {
        btn.setTitle(title, for: .normal)
        btn.sizeToFit()
        btn.backgroundColor = color
        btn.addTarget(target, action: sel, for: event)
        btn.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        btn.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
