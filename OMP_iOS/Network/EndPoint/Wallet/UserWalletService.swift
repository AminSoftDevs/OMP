//
//  UserWalletService.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 10/17/21.
//

import Foundation

struct UserWalletService: EndPointType {
    
    static let agent = Router<Self>()
    
    var path: String {
        return "/user/wallet"
    }
    
    var newHTTPMethod: HTTPMEthod {
        return .get
    }
    
    var task: HTTPTask<Request> {
        return .urlRequest(urlParameters: [:])
    }
    
    var headers: HTTPHeaderss? {
        return NetworkConfig.RequestHeader.getDefaultHeaderWithToken()
    }
    
    var version: String {
        return NetworkConfig.APIVersion.v1.rawValue
    }
    
    var marketType: AppMarket {
        return UserDefaults.standard.selectedMarket
    }
}

extension UserWalletService {
    typealias RequestType = Request
    typealias ResponseType = Response
    typealias ErrorResponseType = ErrorResponse
    
    struct Request: Encodable {
        
    }
    
    struct Response: Decodable {
        let status: String
        let data: [Wallet]
    }
    
    struct ErrorResponse: Decodable {
        let status: String
        let message: String?
    }
    
    static func getUserWallets(completion: @escaping (Result<NetworkResult<Response, ErrorResponse>, NetworkError>) -> Void) {
        agent.perform(.init(),completion: completion)
    }
}
