//
//  DepositHistoryService.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 10/17/21.
//

import Foundation

struct DepositHistoryService: EndPointType {
    
    static let agent = Router<Self>()
    
    var path: String {
        return "/user/deposit"
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

extension DepositHistoryService {
    typealias RequestType = Request
    typealias ResponseType = Response
    typealias ErrorResponseType = ErrorResponse
    
    struct Request: Encodable {
        
    }
    
    struct Response: Decodable {
        let status: String
        let data: [DepositHistory]
    }
    
    struct ErrorResponse: Decodable {
        let status: String
        let message: String?
    }
    
    static func getDepositHistory(completion: @escaping (Result<NetworkResult<Response, ErrorResponse>, NetworkError>) -> Void) {
        agent.perform(.init(),completion: completion)
    }
}
