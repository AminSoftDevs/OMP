//
//  DigitalWithdrawVerification.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 10/17/21.
//

import Foundation

struct DigitalWithdrawVerification: EndPointType {
    
    static let agent = Router<Self>()
    
    private var requestModel: Request
    private var id: String
    
    init(id: String, request: Request) {
        self.requestModel = request
        self.id = id
    }
    
    var path: String {
        return "/user/wallet/\(id)/withdraw/verify"
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

extension DigitalWithdrawVerification {
    typealias RequestType = Request
    typealias ResponseType = Response
    typealias ErrorResponseType = ErrorResponse
        
    struct Request: Encodable {
        let id: Int
        let code: String?
        let googleAuthCode: Int?
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
            let googleAuthCode: [String]?
            
            enum CodingKeys: String, CodingKey {
                case googleAuthCode = "google_auth_code"
                case code
                case id
            }
        }
    }
        
    static func digitalWithdrawVerification(id: String, request: Request, completion: @escaping (Result<NetworkResult<Response, ErrorResponse>, NetworkError>) -> Void) {
        agent.perform(.init(id: id, request: request),
                      completion: completion)
    }
}
