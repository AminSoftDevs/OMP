//
//  RialWithdrawService.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 10/17/21.
//

import Foundation

struct RialWithdrawService: EndPointType {
    
    static let agent = Router<Self>()
    
    var path: String {
        return "/user/rial-withdraw"
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
    
    private let requestModel: Request
    
    init(requestModel: Request) {
        self.requestModel = requestModel
    }
}

extension RialWithdrawService {
    typealias RequestType = Request
    typealias ResponseType = Response
    typealias ErrorResponseType = ErrorResponse
    
    struct Request: Encodable {
        let amount: Int
        let id: Int
        
        enum CodingKeys: String, CodingKey {
            case id = "iban_id"
            case amount
        }
    }
    
    struct Response: Decodable {
        let status: String
        let data: WithdrawIdentifier
        let message: String?
    }
    
    struct ErrorResponse: Decodable {
        let status: String
        let errors: Errors
        
        struct Errors: Decodable {
            let amount: [String]?
            let id: [String]?
            
            enum CodingKeys: String, CodingKey {
                case id = "iban_id"
                case amount
            }
        }
    }
    
    static func createRialWithdraw(request: Request, completion: @escaping (Result<NetworkResult<Response, ErrorResponse>, NetworkError>) -> Void) {
        agent.perform(.init(requestModel: request),completion: completion)
    }
}

