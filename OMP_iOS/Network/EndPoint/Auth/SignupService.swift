//
//  SignupService.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 12/16/21.
//

import Foundation

struct SignupService: EndPointType {
  
    static let agent = Router<Self>()
    
    private var requestModel: Request
    
    init(request: Request) {
        self.requestModel = request
    }
    
    var path: String {
        return "/user/sign-up"
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

extension SignupService {
    typealias RequestType = Request
    typealias ResponseType = Response
    typealias ErrorResponseType = ErrorResponse
    
    struct Request: Encodable {
        let email: String
        let password: String
        let recaptchaToken: String
        let referralCode: String
        
        enum CodingKeys: String, CodingKey, Codable {
            case recaptchaToken = "recaptcha_token"
            case referralCode = "referral_code"
            case password, email
        }
    }
    
    struct Response: Decodable {
        let status: String
        let token: String
    }
    
    struct ErrorResponse: Decodable {
        let status: String
        let errors: Errors

        struct Errors: Decodable {
            let recaptchaToken, password, email, referralCode: [String]?
            
            enum CodingKeys: String, CodingKey {
                case recaptchaToken = "recaptcha_token"
                case password, email
                case referralCode = "referral_code"
            }
        }
    }
    
    static func signupRequest(request: Request, completion: @escaping (Result<NetworkResult<Response, ErrorResponse>, NetworkError>) -> Void) {
        agent.perform(.init(request: request), completion: completion)
    }
}
