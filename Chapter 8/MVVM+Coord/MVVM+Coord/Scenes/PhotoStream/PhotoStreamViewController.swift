//
//  PhotoStreamViewController.swift
//  NetworkingLayer
//
//  Created by Eric Vennaro on 10/16/22.
//

import UIKit
import Combine

final class PhotoStreamViewController: UIViewController {
    private let photoStreamVM: PhotoStreamViewModelProto
    private var cancellables: Set<AnyCancellable> = []
    
    private let reaction = PassthroughSubject<ReactionSelection, Never>()
    private let appear = PassthroughSubject<Void, Never>()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: flowLayout)
        collectionView.register(
            PhotoStreamCollectionViewCell.self,
            forCellWithReuseIdentifier: PhotoStreamCollectionViewCell.reuseIdentifier)
        collectionView.dataSource = collectionViewDataSource
        collectionView.delegate = flowLayoutDelegate
        return collectionView
    }()
    
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.sectionInset = UIEdgeInsets(
            top: 5, left: 5, bottom: 5, right: 5)
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    private lazy var flowLayoutDelegate: PhotoStreamCollectionViewDelegateFlowLayout = {
       return PhotoStreamCollectionViewDelegateFlowLayout(
        flowLayout: flowLayout)
    }()
    
    private lazy var collectionViewDataSource: PhotoStreamUICollectionViewDataSource = {
        return PhotoStreamUICollectionViewDataSource(
            target: self,
            selector: #selector(updateReactionCount))
    }()
    
    init(photoStreamVM: PhotoStreamViewModelProto) {
        self.photoStreamVM = photoStreamVM
        super.init(nibName: nil, bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.tabBarItem.title =
        photoStreamVM.vcTitle

        let input = PhotoStreamViewModelInput(
            appear: appear.eraseToAnyPublisher(),
            reaction: reaction.eraseToAnyPublisher())

        let output = photoStreamVM.transform(input: input)
        output.sink { [unowned self] state in
            self.render(state)
        }
        .store(in: &cancellables)
    }
    
    override func loadView() {
        view = collectionView
    }
    
    private func render(_ state: PhotoStreamState) {
        switch state {
        case .loading:
            print("loading...")
        case .failure:
            print("failed...")
        case .success(let photoStream):
            collectionViewDataSource.update(photos: photoStream)
            collectionView.reloadData()
        }
    }
    
    @objc func updateReactionCount(_ sender: UIButton) {
        guard let btn = sender as? ReactionsButton,
              let reactionType = btn.reactionType,
              let photoId = btn.id
        else { return }
        reaction.send(ReactionSelection(id: photoId, reactionType: reactionType))
    }
}

extension PhotoStreamViewController: Presentable {
    func toPresent() -> UIViewController? {
        return self
    }
}
