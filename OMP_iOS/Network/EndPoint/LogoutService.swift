//
//  LogoutService.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 12/16/21.
//

import Foundation

struct LogoutService: EndPointType {
    
    static let agent = Router<Self>()
    
    var path: String {
        return "/user/logout"
    }
    
    var newHTTPMethod: HTTPMEthod {
        return .delete
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

extension LogoutService {
    typealias RequestType = Request
    typealias ResponseType = Response
    typealias ErrorResponseType = ErrorResponse
    
    struct Request: Encodable {
    }
    
    struct Response: Decodable {
        let status: String?
    }
    
    struct ErrorResponse: Decodable {
        let status: String?
    }
    
    static func logout(completion: @escaping (Result<NetworkResult<Response, ErrorResponse>, NetworkError>) -> Void) {
        agent.perform(.init(),completion: completion)
    }
}
