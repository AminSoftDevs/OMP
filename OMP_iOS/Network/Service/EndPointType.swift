//
//  EndPointType.swift
//  OMP_iOS
//
//  Created by AminSoft on 7/1/1400 AP.
//


import Foundation

protocol EndPointType {
    associatedtype Request: Encodable
    associatedtype Response: Decodable
    associatedtype ErrorResponse: Decodable
    
    var baseURL: URL { get }
    var path: String { get }
    var newHTTPMethod: HTTPMEthod { get }
    var task: HTTPTask<Request> { get }
    var headers: HTTPHeaderss? { get }
    var version: String { get }
    var marketType: AppMarket { get }
}

extension EndPointType {
    var baseURL: URL {
        var urlStr = ""
       
        switch NetworkConfig.APIEnvironment.defaultValue {
        case .production, .development:
            urlStr = "https://api.ompfinex.com/"
        }
        guard let url = URL(string: urlStr) else {
            fatalError("Not Valid URL")
        }
        return url
    }
}
