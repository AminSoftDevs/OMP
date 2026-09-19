//
//  ResetPasswordService.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 12/16/21.
//

import Foundation

struct ResetPasswordService: EndPointType {
  
    static let agent = Router<Self>()
    
    private var requestModel: Request
    
    init(request: Request) {
        self.requestModel = request
    }
    
    var path: String {
        return "/user/reset-password"
    }
    
    var newHTTPMethod: HTTPMEthod {
       return .post
    }
    
    var task: HTTPTask<Request> {
        return .jsonRequest(request: requestModel)
    }
    
    var headers: HTTPHeaderss? {
        return NetworkConfig.RequestHeader.defaultValues
    }
    
    var version: String {
        return NetworkConfig.APIVersion.v1.rawValue
    }
    
    var marketType: AppMarket {
        return .real
    }
}

extension ResetPasswordService {
    typealias RequestType = Request
    typealias ResponseType = Response
    typealias ErrorResponseType = ErrorResponse
    
    struct Request: Encodable {
        let email: String
    }
    
    struct Response: Decodable {
        let status: String
        let data: ResetPassword
    }
    

    struct ErrorResponse: Decodable {
        let status: String
        let errors: Errors

        struct Errors: Decodable {
            let email: [String]?
        }
    }
    
    static func resetPasswordRequest(request: Request, completion: @escaping (Result<NetworkResult<Response, ErrorResponse>, NetworkError>) -> Void) {
        agent.perform(.init(request: request), completion: completion)
    }
}
