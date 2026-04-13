//
//  UserDomainModel.swift
//  NetworkingLayer
//
//  Created by Eric Vennaro on 10/16/22.
//

import Foundation
import Combine

final class UserModel: ObservableObject {
    
    struct User: ModelProto {
        let name: String
        let email: String
        let username: String
        let phone: String
        let id: Int
    }
    
    @Published var allUsers: [UserModel.User] = []
    private var cancellables: Set<AnyCancellable> = []
    
    private let userRepository: RepositoryProto
    
    init(userRepository: RepositoryProto) {
        self.userRepository = userRepository
    }
    
    func getAllUsers() {
       userRepository.getAll().receive(on: DispatchQueue.main)
            .sink { result in
                // potential area to handle errors and edge cases
                switch result {
                    case .finished:
                        break
                    case .failure(let error):
                        print("Error: \(error)")
                }
            } receiveValue: { [weak self] users in
                guard let sSelf = self else {
                    return
                }
                sSelf.allUsers = users.compactMap{ $0 as? UserModel.User }
            }.store(in: &cancellables)
    }
}
