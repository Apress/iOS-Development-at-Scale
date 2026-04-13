//
//  SettingsInteractor.swift
//  VIPER
//
//  Created by Eric Vennaro on 2/5/23.
//

protocol SettingsInteractorProto: AnyObject {
    func getSettingsListItems()
}

final class SettingsInteractor: SettingsInteractorProto {
    weak var presenter: SettingsInteractorToPresenterProto?
    
    func getSettingsListItems() {
        // mock network request
        presenter?.didFetchSettings(with: ["Account", "Privacy", "Logout"])
    }
}
