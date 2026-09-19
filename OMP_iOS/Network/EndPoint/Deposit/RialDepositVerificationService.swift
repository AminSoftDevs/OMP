//
//  RialDepositVerificationService.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 10/17/21.
//

import Foundation

struct RialDepositVerificationService: EndPointType {
    
    static let agent = Router<Self>()
    
    var path: String {
        return "/user/rial-deposit/verify"
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
        return NetworkConfig.APIVersion.v1.rawValue
    }
    
    var marketType: AppMarket {
        return .real
    }
    //MARK: - INITIALIZER
    private var requestModel: Request
    
    init(request: Request) {
        self.requestModel = request
    }
}

extension RialDepositVerificationService {
    typealias RequestType = Request
    typealias ResponseType = Response
    typealias ErrorResponseType = ErrorResponse
    
    struct Request: Encodable {
        let payToken: String
        
        enum CodingKeys: String, CodingKey {
            case payToken = "pay_token"
        }
    }
    
    struct Response: Decodable {
        let status: String
        let data: DepositVerify
    }
    
    struct ErrorResponse: Decodable {
        let status: String
        let errors: Errors
        
        struct Errors: Decodable {
            let payToken: [String]
            
            enum CodingKeys: String, CodingKey {
                case payToken = "pay_token"
            }
        }
    }
    
    static func rialDepositVerify(request: Request, completion: @escaping (Result<NetworkResult<Response, ErrorResponse>, NetworkError>) -> Void) {
        agent.perform(.init(request: request),completion: completion)
    }
}
