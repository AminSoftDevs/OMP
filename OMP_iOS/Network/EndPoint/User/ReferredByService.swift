//
//  ReferredByService.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 12/1/21.
//

import Foundation

struct ReferredByService: EndPointType {
    
    static let agent = Router<Self>()
    
    var path: String {
        return "/user/referral"
    }
    
    var newHTTPMethod: HTTPMEthod {
        .put
    }
    
    var task: HTTPTask<Request> {
        .urlRequest(urlParameters: ["referral_code": requestModel.referralCode])
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

extension ReferredByService {
    typealias RequestType = Request
    typealias ResponseType = Response
    typealias ErrorResponseType = ErrorResponse
    
    struct Request: Encodable {
        let referralCode: String
    }
    
    struct Response: Decodable {
        
    }
    
    struct ErrorResponse: Decodable {
        let status: String
        let errors: Errors
        
        struct Errors: Decodable {
            let referralCode: [String]?
            
            enum CodingKeys: String, CodingKey {
                case referralCode = "referral_code"
            }
        }
    }
    
    static func addReferralCode(request: Request, completion: @escaping (Result<NetworkResult<Response, ErrorResponse>, NetworkError>) -> Void) {
        agent.perform(.init(request: request), completion: completion)
    }
}
