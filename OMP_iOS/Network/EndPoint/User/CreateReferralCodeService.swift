//
//  CreateReferralCodeService.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 11/25/21.
//

import Foundation

struct CreateReferralCodeService: EndPointType {
    
    static let agent = Router<Self>()
    
    //MARK: - INITIALIZER
    private var requestModel: Request
    
    init(request: Request) {
        self.requestModel = request
    }
    
    var path: String {
        return "/user/referral"
    }
    
    var newHTTPMethod: HTTPMEthod {
        return .post
    }
    
    var task: HTTPTask<Request> {
        return .urlRequest(urlParameters: ["friend_share": requestModel.friendShare])
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

extension CreateReferralCodeService {
    typealias RequestType = Request
    typealias ResponseType = Response
    typealias ErrorResponseType = ErrorResponse
        
    struct Request: Encodable {
        let friendShare: Int
    }
    
    struct Response: Decodable {
    }
    
    struct ErrorResponse: Decodable {
        let status: String
        let errors: Errors
        
        struct Errors: Decodable {
            let friendShare: [String]?
            
            enum CodingKeys: String, CodingKey {
                case friendShare = "friend_share"
            }
        }
    }
        
    static func createReferralCode(request: Request, completion: @escaping (Result<NetworkResult<Response, ErrorResponse>, NetworkError>) -> Void) {
        agent.perform(.init(request: request),
                      completion: completion)
    }
}
