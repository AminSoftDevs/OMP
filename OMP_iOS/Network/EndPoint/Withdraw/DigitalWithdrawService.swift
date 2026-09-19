//
//  DigitalWithdrawService.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 10/17/21.
//

import Foundation

struct DigitalWithdrawService: EndPointType {
    
    static let agent = Router<Self>()
    
    private var requestModel: Request
    private var id: String
    
    init(id: String, request: Request) {
        self.requestModel = request
        self.id = id
    }
    
    var path: String {
        return "/user/wallet/\(id)/withdraw"
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

extension DigitalWithdrawService {
    typealias RequestType = Request
    typealias ResponseType = Response
    typealias ErrorResponseType = ErrorResponse
        
    struct Request: Encodable {
        let amount: Double
        let wallet: String
        let tag: String?
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
            let wallet: [String]?
            let tag: [String]?
        }
    }
        
    static func digitalWithdrawRequest(currencyID: String, request: Request, completion: @escaping (Result<NetworkResult<Response, ErrorResponse>, NetworkError>) -> Void) {
        agent.perform(.init(id: currencyID,request: request),
                      completion: completion)
    }
}
