//
//  SettingsController.swift
//  MVC+Coord
//
//  Created by Eric Vennaro on 12/31/22.
//

import UIKit

protocol SettingsPresenterToViewProto: AnyObject {
    func setupUI()
    func showLoading()
    func settingsDidLoad(with settings: [String])
}

final class SettingsViewController: UIViewController {
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    fileprivate var items: [String] = []
    var presenter: SettingsViewToPresenterProto?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    override func loadView() {
        view = tableView
    }
    
    func setupTabBar() {
        navigationController?.tabBarItem.title = "Settings"
    }
}

extension SettingsViewController: SettingsPresenterToViewProto {
    func showLoading() {
        print("is loading")
    }
    
    func setupUI() {
        title = "Settings"
    }
    
    func settingsDidLoad(with settings: [String]) {
        items = settings
        tableView.reloadData()
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectRow(self, with: items[indexPath.row])
    }
}

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
}
