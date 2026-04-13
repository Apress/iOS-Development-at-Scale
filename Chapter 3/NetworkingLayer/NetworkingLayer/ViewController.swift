//
//  ViewController.swift
//  NetworkingLayer
//
//  Created by Eric Vennaro on 10/16/22.
//

import UIKit
import Combine

class ViewController: UIViewController {
    private let photoRepository: RepositoryProto
    private let tableView: UITableView
    private var photos: [Photo] = []
    private var cancellables: Set<AnyCancellable> = []
    
    init(photoRepository: RepositoryProto) {
        self.photoRepository = photoRepository
        self.tableView = UITableView()
        super.init(nibName: nil, bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        photoRepository.getAll()
            .receive(on: DispatchQueue.main)
            .sink { result in
                // potential area to handle errors and edge cases
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error)")
                    break
                }
             } receiveValue: { [weak self] photos in
                 guard let sSelf = self else {
                     return
                 }
                 sSelf.photos = photos.compactMap{ $0 as? Photo }
                 self?.tableView.reloadData()
             }
             .store(in: &cancellables)
    }
    
    override func loadView() {
        view = tableView
        tableView.dataSource = self
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return photos.count
      }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = photos[indexPath.row].title
        return cell
    }
}
