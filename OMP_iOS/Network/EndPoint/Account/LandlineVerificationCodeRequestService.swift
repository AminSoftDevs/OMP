//
//  LandlineVerificationCodeRequestService.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 12/16/21.
//

import Foundation

struct LandlineVerificationCodeRequestService: EndPointType {
    
    static let agent = Router<Self>()
    
    private var requestModel: Request
    
    init(request: Request) {
        self.requestModel = request
    }
    
    var path: String {
        return "/user/verification/landline-phone"
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
}

extension LandlineVerificationCodeRequestService {
    typealias RequestType = Request
    typealias ResponseType = Response
    typealias ErrorResponseType = ErrorResponse
    
    struct Request: Encodable {
        let phone: String
    }
    
    struct Response: Decodable {
        let status: String
    }
    
    struct ErrorResponse: Decodable {
        let status: String
        let errors: Errors

        struct Errors: Decodable {
            let landlinePhone: [String]?
            
            enum CodingKeys: String, CodingKey {
                case landlinePhone = "landline_phone"
            }
        }
    }
    
    static func requestLandlineVerifyCodeRequest(request: Request, completion: @escaping (Result<NetworkResult<Response, ErrorResponse>, NetworkError>) -> Void) {
        agent.perform(.init(request: request), completion: completion)
    }
}
