//
//  NetworkManager.swift
//  NetworkingLayer
//  
//  Created by Eric Vennaro on 10/16/22.
//

import Foundation
import Combine

// Protocol to wrap URLSession for DI
protocol NetworkingProto {
    func dataTaskPublisher(
        for request: URLRequest) -> URLSession.DataTaskPublisher
}

extension URLSession: NetworkingProto {}

final class NetworkManager: NetworkManagerProto {
    private let networking: NetworkingProto
    
    init(networking: NetworkingProto = URLSession.shared) {
        self.networking = networking
    }
    
    // This code is light on error handling and logging for illustration purposes
    // these cases should be handled in production code
   public func send<T>(request: URLRequest,
                 withResponseBodyType responseBodyType: T.Type
   ) -> AnyPublisher<T, Error> where T: Decodable {
        
            return networking.dataTaskPublisher(for: request)
                .tryMap() { element -> Data in
                    guard let httpResponse = element.response as? HTTPURLResponse,
                          httpResponse.statusCode == 200 else {
                        throw URLError(.badServerResponse)
                    }
                    return element.data
                }
                .decode(type: responseBodyType.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()      
    }
}
