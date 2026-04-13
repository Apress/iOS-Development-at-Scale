//
//  SettingsController.swift
//  MVC+Coord
//
//  Created by Eric Vennaro on 12/31/22.
//

import UIKit

final class SettingsViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private let items = ["Account", "Privacy", "Logout"]
    weak var cDelegate: SettingsCoordinatorDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        view = tableView
    }
    
    func setupTabBar() {
        navigationController?.tabBarItem.title = "Settings"
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cDelegate?.didSelectRow(self, with: items[indexPath.row])
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

extension SettingsViewController: Presentable {
    func toPresent() -> UIViewController? {
        return self
    }
}

