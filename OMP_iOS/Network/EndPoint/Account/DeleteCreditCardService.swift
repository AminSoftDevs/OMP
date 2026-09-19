//
//  DeleteCreditCardService.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 12/14/21.
//

import Foundation

struct DeleteCreditCardService: EndPointType {
    
    static let agent = Router<Self>()
    
    private let requestModel: Request
    
    init(request: Request) {
        self.requestModel = request
    }
    
    var path: String {
        return "/user/verification/credit-card"
    }
    
    var newHTTPMethod: HTTPMEthod {
        return .delete
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
}

extension DeleteCreditCardService {
    typealias RequestType = Request
    typealias ResponseType = Response
    typealias ErrorResponseType = ErrorResponse
    
    struct Request: Encodable {
        let id: String
    }
    
    struct Response: Decodable {
        let status: String
    }
    
    struct ErrorResponse: Decodable {
        let status: String
        let errors: Errors
        
        struct Errors: Decodable {
            let id: [String]?
        }
    }
    
    static func deleteCreditCardRequest(request: Request, completion: @escaping (Result<NetworkResult<Response, ErrorResponse>, NetworkError>) -> Void) {
        agent.perform(.init(request: request), completion: completion)
    }
}
