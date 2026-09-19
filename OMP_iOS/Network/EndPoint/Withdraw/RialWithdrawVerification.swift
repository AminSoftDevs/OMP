//
//  RialWithdrawVerification.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 10/17/21.
//

import Foundation

struct RialWithdrawVerification: EndPointType {
    
    static let agent = Router<Self>()
    
    private var requestModel: Request
    
    init(request: Request) {
        self.requestModel = request
    }
    
    var path: String {
        return "/user/rial-withdraw/verify"
    }
    
    var newHTTPMethod: HTTPMEthod {
        return .post
    }
    
    var task: HTTPTask<Request> {
        return .jsonRequest(request: requestModel)
    }
    
    var headers: HTTPHeaderss? {
        return NetworkConfig.RequestHeader.getDefaultHeaderWithToken()
    }
    
    var version: String {
        return NetworkConfig.APIVersion.v2.rawValue
    }
    
    var marketType: AppMarket {
        return .real
    }
}

extension RialWithdrawVerification {
    typealias RequestType = Request
    typealias ResponseType = Response
    typealias ErrorResponseType = ErrorResponse
        
    struct Request: Encodable {
        let id: Int
        let code: String
    }
    
    struct Response: Decodable {
        let status: String
        let message: String?
    }
    
    struct ErrorResponse: Decodable {
        let status: String
        let errors: Errors
        
        struct Errors: Decodable {
            let id: [String]?
            let code: [String]?
        }
    }
        
    static func rialWithdrawVerifyRequest(request: Request, completion: @escaping (Result<NetworkResult<Response, ErrorResponse>, NetworkError>) -> Void) {
        agent.perform(.init(request: request),
                      completion: completion)
    }
}
