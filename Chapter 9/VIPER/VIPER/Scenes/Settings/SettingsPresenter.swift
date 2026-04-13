//
//  SettingsPresenter.swift
//  VIPER
//
//  Created by Eric Vennaro on 2/5/23.
//

import UIKit

protocol SettingsViewToPresenterProto: AnyObject {
    func viewDidLoad()
    func didSelectRow(_ view: UIViewController, with item: String)
}

protocol SettingsInteractorToPresenterProto: AnyObject {
    func didFetchSettings(with settings:[String])
    func fetchFailed(with errorMessage:String)
}

final class SettingsPresenter {
    weak var view: SettingsPresenterToViewProto?
    var interactor: SettingsInteractorProto?
    var router: SettingsRouterProto?
}

extension SettingsPresenter: SettingsViewToPresenterProto {
    func viewDidLoad() {
        view?.setupUI()
        view?.showLoading()
        interactor?.getSettingsListItems()
    }
    
    func didSelectRow(_ view: UIViewController, with item: String) {
        router?.pushDetail()
    }
}

extension SettingsPresenter: SettingsInteractorToPresenterProto {
    func didFetchSettings(with settings: [String]) {
        view?.settingsDidLoad(with: settings)
    }
    
    func fetchFailed(with errorMessage: String) {
        print("error message")
    }
}
