//
//  NetworkErrors.swift
//  iFlickr
//
//  Created by Mike Conner on 7/13/21.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    
    // Cases
    case invalidURL
    case thrownError(Error)
    case non200Response(HTTPURLResponse)
    case noData
    case unableToDecode
    
    // Error Descriptions
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Unable to reach the server."
        case .thrownError(let error):
            return "Error: \(error.localizedDescription) -> \(error)"
        case .non200Response(let response):
            return "Non 200 response: \(response.statusCode) - \(response.url!.absoluteString)"
        case .noData:
            return "The server responded with no data."
        case .unableToDecode:
            return "The server responded with bad data."
        }
    }
    
} // End of enum
