//
//  FavoriteMarketService.swift
//  OMP_iOS
//
//  Created by AminSoft on 8/19/1400 AP.
//

import Foundation

struct FavoriteMarketService: EndPointType {
    
    static let agent = Router<Self>()
    
    private var id: Int
    
    init(id: Int) {
        self.id = id
    }
    
    var path: String {
        return "/market/\(id)/favorite"
    }
    
    var newHTTPMethod: HTTPMEthod {
        return .post
    }
    
    var task: HTTPTask<Request> {
        return .jsonRequest(request: Request())
    }
    
    var headers: HTTPHeaderss? {
        return NetworkConfig.RequestHeader.getDefaultHeaderWithToken()
    }
    
    var version: String {
        return NetworkConfig.APIVersion.v1.rawValue
    }
    
    var marketType: AppMarket {
        return .real
    }
}

extension FavoriteMarketService {
    typealias ErrorResponseType = ErrorResponse
        
    struct Response: Decodable {
        let status: String
    }
    
    struct Request: Encodable {
        
    }
    
    struct ErrorResponse: Decodable {

    }
        
    static func favoriteMarketRequest(currencyID: Int, completion: @escaping (Result<NetworkResult<Response, ErrorResponse>, NetworkError>) -> Void) {
        agent.perform(.init(id: currencyID),completion: completion)
    }
}
