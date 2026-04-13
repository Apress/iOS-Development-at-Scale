//
//  NetworkManagerProto.swift
//  NetworkingLayer
//
//  Created by Eric Vennaro on 11/27/22.
//

import Foundation
import Combine

protocol NetworkManagerProto {
    func send<T>(request: URLRequest,
                 withResponseBodyType responseBodyType: T.Type
    ) -> AnyPublisher<T, Error> where T: Decodable
}
