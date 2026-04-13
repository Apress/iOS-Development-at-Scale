//
//  NetworkError.swift
//  NetworkingLayer
//
//  Created by Eric Vennaro on 10/16/22.
//

import Foundation

enum NetworkError: Error {
    case missingData
    case wrongDataFormat(error: Error)
    case invalidURLRequest
    case jsonParsingError
}
extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .wrongDataFormat(let error):
            return NSLocalizedString("Could not digest the fetched data. \(error.localizedDescription)", comment: "")
        case .missingData:
            return NSLocalizedString("Found and will discard a quake missing a valid code, magnitude, place, or time.", comment: "")
        case .invalidURLRequest:
            return NSLocalizedString("Invalid url request", comment: "")
        case .jsonParsingError:
            return NSLocalizedString("", comment: "")
        }
    }
}

extension NetworkError: Identifiable {
    var id: String? {
        errorDescription
    }
}
