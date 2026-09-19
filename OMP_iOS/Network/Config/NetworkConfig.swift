//
//  NetworkConfig.swift
//  OMP_iOS
//
//  Created by AminSoft on 7/1/1400 AP.
//

import Foundation

struct NetworkConfig {

    enum APIVersion: String {
        case v1
        case v2
    }
    
    enum APIEnvironment {
        case production
        case development
        
        static var defaultValue: Self = .production
    }
    
    enum MarketType: String {
        case main = ""
        case demo = "/demo"
        
        static var defaultValue: Self = .main
    }
    
    struct RequestHeader {
        static let defaultValues = [
            "Content-Type" : "application/json",
            "user-device": "ios",
            "app-version": Bundle().releaseVersionNumber ?? ""
        ]
        
        static func getDefaultHeaderWithToken() -> [String : String] {
            return [
                "Content-Type" : "application/json",
                "user-device": "ios",
                "app-version": Bundle().releaseVersionNumber ?? "",
                "Authorization": "Bearer \(KeychainData.token)"
            ]
        }
    }
}
