//
//  ReferralDetailsService.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 11/25/21.
//

import Foundation

struct ReferralDetailsService: EndPointType {
    
    static let agent = Router<Self>()
    
    var path: String {
        return "/user/referral"
    }
    
    var newHTTPMethod: HTTPMEthod {
        .get
    }
    
    var task: HTTPTask<Request> {
        .urlRequest(urlParameters: [:])
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

extension ReferralDetailsService {
    typealias RequestType = Request
    typealias ResponseType = Response
    typealias ErrorResponseType = ErrorResponse
    
    struct Request: Encodable {
        
    }
    
    struct Response: Decodable {
        let status: String
        let data: ReferralDetails
    }
    
    struct ErrorResponse: Decodable {
        let status: String
        let message: String?
    }
    
    static func getReferralsDetails(completion: @escaping (Result<NetworkResult<Response, ErrorResponse>, NetworkError>) -> Void) {
        agent.perform(.init(), completion: completion)
    }
}
