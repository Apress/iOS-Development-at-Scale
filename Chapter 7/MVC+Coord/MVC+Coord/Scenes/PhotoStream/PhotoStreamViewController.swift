//
//  PhotoStreamViewController.swift
//  NetworkingLayer
//
//  Created by Eric Vennaro on 10/16/22.
//

import UIKit
import Combine

final class PhotoStreamViewController: UIViewController {
    private let photoModel: PhotoModelProto
    private var photos: [PhotoModel.Photo] = []
    private var cancellables: Set<AnyCancellable> = []
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: flowLayout)
        collectionView.register(
            PhotoStreamCollectionViewCell.self,
            forCellWithReuseIdentifier: "cell")
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
    
    init(photoModel: PhotoModelProto) {
        self.photoModel = photoModel
        super.init(nibName: nil, bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.tabBarItem.title = "Photo Stream"
        photoModel
            .allPhotosPublished
            .sink { [weak self] ret in
                self?.photos = ret
                self?.collectionViewDataSource.update(photos: ret)
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
        
        photoModel.getAllPhotos()
    }
    
    override func loadView() {
        view = collectionView
    }
    
    @objc func updateReactionCount(_ sender: UIButton) {
        guard let btn = sender as? ReactionsButton,
                let reactionType = btn.reactionType else { return }
        let upCount = reactionType == .thumbsUp ? 1 : 0
        let downCount = reactionType == .thumbsDown ? 1 : 0
        
        photoModel.updateReactionCount(upCount: upCount, downCount: downCount)
    }
}

extension PhotoStreamViewController: Presentable {
    func toPresent() -> UIViewController? {
        return self
    }
}
