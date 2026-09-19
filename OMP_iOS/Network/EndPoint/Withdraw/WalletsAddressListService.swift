//
//  WalletsAddressListService.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 1/25/22.
//

import Foundation

struct WalletsAddressListService: EndPointType {
    
    static let agent = Router<Self>()
    
    var path: String {
        return "/user/wallet/last-used"
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
        return .real
    }
}

extension WalletsAddressListService {
    typealias RequestType = Request
    typealias ResponseType = Response
    typealias ErrorResponseType = ErrorResponse
    
    struct Request: Encodable {
        
    }
    
    struct Response: Decodable {
        let status: String
        let data: [WalletAddress]
    }
    
    struct ErrorResponse: Decodable {
        let status: String
        let message: String?
    }
    
    static func getWalletsAddressList(completion: @escaping (Result<NetworkResult<Response, ErrorResponse>, NetworkError>) -> Void) {
        agent.perform(.init(),completion: completion)
    }
}
