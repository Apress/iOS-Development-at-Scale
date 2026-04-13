//
//  ReactionsView.swift
//  MVCModelBasedNetworking
//
//  Created by Eric Vennaro on 12/26/22.
//

import UIKit

enum ReactionType: String {
    case thumbsUp
    case thumbsDown
}

// Custom button class to handle our update behavior
final class ReactionsButton: UIButton {
    var reactionType: ReactionType?
    var id: Int?
}

final class ReactionsView: UIView {
    private var thumbsUpCount: Int
    var thumbsUp: Int {
        get {
            return thumbsUpCount
        }
        set {
            thumbsUpCount = newValue
        }
    }
    
    private var thumbsDownCount: Int
    var thumbsDown: Int {
        get {
            return thumbsDownCount
        } set {
            thumbsDownCount = newValue
        }
    }
    
    private var photoId: Int?
    var id: Int? {
        get {
            return photoId
        } set {
            photoId = newValue
            thumbsUpButton.id = id
            thumbsDownButton.id = id
        }
        
    }
    
    lazy var thumbsUpButton: ReactionsButton = {
        let btn = ReactionsButton()
        btn.setTitle("👍", for: .normal)
        btn.reactionType = .thumbsUp
    
       return btn
    }()
    
    lazy var thumbsDownButton: ReactionsButton = {
        let btn = ReactionsButton()
        btn.setTitle("👎", for: .normal)
        btn.reactionType = .thumbsDown
        return btn
    }()
    
    private lazy var reactionsLabel: UILabel = {
        return UILabel()
    }()
    
    var reactionsLabelText: String {
        get {
            return reactionsLabel.text ?? ""
        } set {
            reactionsLabel.text = newValue
        }
    }
    
    init(thumbsUpCount: Int = 0, thumbsDownCount: Int = 0) {
        self.thumbsUpCount = thumbsUpCount
        self.thumbsDownCount = thumbsDownCount
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        backgroundColor = .lightGray
        let stackView = UIStackView(arrangedSubviews: [thumbsDownButton, thumbsUpButton, reactionsLabel])
        addSubview(stackView)
        stackView.axis = .horizontal;
        stackView.distribution = .equalSpacing;
        stackView.alignment = .center;
        stackView.spacing = 10;
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
}
