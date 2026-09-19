//
//  RialWithdrawFeeCalculationService.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 12/21/21.
//

import Foundation

struct RialWithdrawFeeCalculationService: EndPointType {
    
    static let agent = Router<Self>()
    
    var path: String {
        return "/user/rial-withdraw/fee-calculation"
    }
    
    var newHTTPMethod: HTTPMEthod {
        return .get
    }
    
    var task: HTTPTask<Request> {
        return .urlRequest(urlParameters: ["amount": request.amount])
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
    
    private let request: Request
    
    init(request: Request) {
        self.request = request
    }
}

extension RialWithdrawFeeCalculationService {
    
    typealias RequestType = Request
    typealias ResponseType = Response
    typealias ErrorResponseType = ErrorResponse
    
    struct Request: Encodable {
        let amount: String
    }
    
    struct Response: Decodable {
        let status: String
        let data: RialWithdrawFee
    }
    
    struct ErrorResponse: Decodable {
        let status: String
        let errors: Errors
        
        struct Errors: Decodable {
            let amount: [String]?
        }
    }
    
    static func calculateRialWithdrawFee(request: Request, completion: @escaping (Result<NetworkResult<Response, ErrorResponse>, NetworkError>) -> Void) {
        agent.perform(.init(request: request),completion: completion)
    }
}
