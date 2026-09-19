//
//  NetworkError.swift
//  OMP_iOS
//
//  Created by AminSoft on 7/1/1400 AP.
//


import Foundation

enum NetworkError: Error {
    case missingURL
    case encodingFailed
    case unauthorized
    case forbidden(message: String)
    case tooManyRequest(message: String)
    case validation
    case internalServerError
    case unknown
    case unableToDecode(error: Error)
    case noData
    case requestBuildFailed
    case badRequest(error: Data)
    case noInternetConnection
    case failed
}

extension NetworkError {
    var localizedStrings: String {
        switch self {
        case .forbidden(let msg):
            return msg
        case .noInternetConnection:
            return "noInternetConnection".localized
            
        case .unableToDecode:
            return "unableToDecode".localized
            
        case .internalServerError:
            return "internalServerError".localized
            
        case .noData, .failed, .badRequest, .requestBuildFailed:
            return "requestBuildFailed".localized
        case .unauthorized:
            return "unauthorized".localized
        default:
            return ""
        }
    }
}

extension Array where Element == String {
    func createErrorMessage() -> String {
        count > 1 ? self.joined(separator: ",\n") : (first ?? "")
    }
}
