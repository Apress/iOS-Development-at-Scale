//
//  PhotoStreamCollectionViewCell.swift
//  MVCModelBasedNetworking
//
//  Created by Eric Vennaro on 12/26/22.
//

import UIKit

final class PhotoStreamCollectionViewCell: UICollectionViewCell {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var reactionsView: ReactionsView = {
        return ReactionsView()
    }()
    
    private var title: String {
        set {
            titleLabel.text = newValue
        }
        get {
            return titleLabel.text ?? ""
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(
        id: Int,
        title: String,
        reactionsLabelText: String,
        thumbsUpCount: Int,
        thumbsDownCount: Int,
        target: Any?,
        sel: Selector
    ) {
        self.title = title
        reactionsView.thumbsUp = thumbsUpCount
        reactionsView.thumbsDown = thumbsDownCount
        reactionsView.reactionsLabelText = reactionsLabelText
        reactionsView.id = id
        reactionsView.thumbsUpButton.addTarget(
            target,
            action: sel,
            for: .touchUpInside)
        reactionsView.thumbsDownButton.addTarget(
            target,
            action: sel,
            for: .touchUpInside)
    }
    
    private func setupView() {
        addSubview(titleLabel)
        contentView.addSubview(reactionsView)
        reactionsView.setupView()
        reactionsView.translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .orange
        
        // center the label
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -10).isActive = true
        
        // reactions view
        reactionsView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        reactionsView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        reactionsView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        reactionsView.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
}
