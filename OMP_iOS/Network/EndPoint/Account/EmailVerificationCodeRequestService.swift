//
//  EmailVerificationCodeService.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 12/15/21.
//

import Foundation

struct EmailVerificationCodeRequestService: EndPointType {
  
    static let agent = Router<Self>()
    
    var path: String {
        return "/user/verification/email"
    }
    
    var newHTTPMethod: HTTPMEthod {
       return .post
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

extension EmailVerificationCodeRequestService {
    typealias RequestType = Request
    typealias ResponseType = Response
    typealias ErrorResponseType = ErrorResponse
    
    struct Request: Encodable {
        
    }
    
    struct Response: Decodable {
        let status: String
    }
    
    struct ErrorResponse: Decodable {
        let status: String
        let message: String?
    }
    
    static func emailVerificationCodeRequest(completion: @escaping (Result<NetworkResult<Response, ErrorResponse>, NetworkError>) -> Void) {
        agent.perform(.init(), completion: completion)
    }
}
