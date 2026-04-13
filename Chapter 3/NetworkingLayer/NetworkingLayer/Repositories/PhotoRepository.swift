//
//  PhotoRepository.swift
//  NetworkingLayer
//
//  Created by Eric Vennaro on 11/27/22.
//

import Foundation
import Combine

class PhotoRepository: RepositoryProto {
    // For this example we load from the cache if < 5 minutes has gone by.
    // when to use the cache vs. refresh would need to be defined as  a product requirement
    private var lastFetchTime: Date
    private var cancellables: Set<AnyCancellable> = []
    private let localStorageManager: LocalStorageManagerProto
    private let networkManager: NetworkManagerProto
    
    init(
        localStorageManager: LocalStorageManagerProto,
        networkManager: NetworkManagerProto
    ) {
        self.localStorageManager = localStorageManager
        self.networkManager = networkManager
        // for usage in the example, we are setting to an old time interval to ensure first network fetch
        self.lastFetchTime = Date(timeIntervalSince1970: 0)
    }
    
    func getAll() -> AnyPublisher<[ModelProto], Error> {
        if (NSDateInterval(start: lastFetchTime, end: Date.now).duration < (5*60)) {
            return try! localStorageManager.getAllEntities(
                for: String(describing: PhotoMO.self),
                _type: PhotoMO.self)
                .compactMap { photos in
                    let objs = photos.compactMap { photo in
                        photo.convertToDomain()
                    }
                    return objs
                }
                .eraseToAnyPublisher()
        } else {
            let sharedPublisher = networkManager.send(
                request: getURLRequest(),
                withResponseBodyType: [PhotoMO.PropertiesObject].self)
            sharedPublisher.sink { [weak self] result in
                switch result {
                    case .finished:
                        self?.lastFetchTime = Date.now
                    case .failure(let error):
                        print("Error: \(error)")
                }
            } receiveValue: { [weak self] photoProperties in
                let lsm = self?.localStorageManager
                Task { [lsm] in
                    try? await lsm?.importEntities(
                        from: photoProperties, for: PhotoMO.self)
                }
            }
            .store(in: &cancellables)
                
        return sharedPublisher
            .compactMap { photos in
                let objs = photos.compactMap { photo in
                    photo.convertToDomain()
                }
                return objs
            }
            .eraseToAnyPublisher()
        }
    }
    
    func get<T>(identifier: Int) -> T? {
        fatalError("not implemented")
    }
    
    func create<T>(entity: T) -> Bool {
        fatalError("not implemented")
    }
    func update<T>(entity: T) -> Bool {
        fatalError("not implemented")
    }
    func delete<T>(entity: T) -> Bool {
        fatalError("not implemented")
    }
    
    private func getURLRequest() -> URLRequest {
        return URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/photos")!)
    }
}
