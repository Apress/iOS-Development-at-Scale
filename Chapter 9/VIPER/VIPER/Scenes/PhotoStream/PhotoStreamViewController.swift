//
//  PhotoStreamViewController.swift
//  NetworkingLayer
//
//  Created by Eric Vennaro on 10/16/22.
//

import UIKit
import Combine

final class PhotoStreamViewController: UIViewController {
    private let presenter: PhotoStreamPresenterProto
    private var photos: [PhotoModel.Photo] = []
    private var cancellables: Set<AnyCancellable> = []
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: flowLayout)
        collectionView.register(
            PhotoStreamCollectionViewCell.self,
            forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    init(presenter: PhotoStreamPresenterProto) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.tabBarItem.title = "Photo Stream"
        presenter
            .allPhotosPublished
            .sink { [weak self] ret in
                self?.photos = ret
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
        presenter
            .loadingStatePublished
            .sink { state in
                switch(state) {
                case .none:
                    break
                case .loading:
                    print("loading results...")
                case .finished:
                    print("finished succesfully")
                case .finishedWithError(let error):
                    print("Finished with error: \(error)")
                }
            }
            .store(in: &cancellables)
        presenter.getAllPhotos()
    }
    
    override func loadView() {
        view = collectionView
    }
    
    @objc func updateReactionCount(_ sender: UIButton) {
        guard let btn = sender as? ReactionsButton,
                let reactionType = btn.reactionType else { return }
        let upCount = reactionType == .thumbsUp ? 1 : 0
        let downCount = reactionType == .thumbsDown ? 1 : 0
        
        presenter.updateReactionCount(upCount: upCount, downCount: downCount)
    }
}

extension PhotoStreamViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "cell",
            for: indexPath
        ) as? PhotoStreamCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configureCell(
            title: photos[indexPath.row].title,
            reactionsLabelText: photos[indexPath.row]
                .reactions
                .reactionsLabelText,
            thumbsUpCount: photos[indexPath.row]
                .reactions
                .thumbsUpCount,
            thumbsDownCount: photos[indexPath.row]
                .reactions
                .thumbsDownCount,
            target: self,
            sel: #selector(updateReactionCount))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
}

extension PhotoStreamViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let numberOfItemsPerRow: CGFloat = 1
        let spacing: CGFloat = flowLayout.minimumInteritemSpacing
        let availableWidth = width - spacing * (numberOfItemsPerRow + 1)
        let itemDimension = floor(availableWidth / numberOfItemsPerRow)
        return CGSize(width: itemDimension, height: itemDimension)
    }
}
