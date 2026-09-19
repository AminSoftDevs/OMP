//
//  ExampleEndPoint.swift
//  OMP_iOS
//
//  Created by AminSoft on 7/1/1400 AP.
//

import Foundation

enum NetworkResult<Response: Decodable, ErrorResponse: Decodable> {
    case success(response: Response)
    case validation(error: ErrorResponse)
}


struct LoginService: EndPointType {
    
    static let agent = Router<Self>()
    
    private var requestModel: Request
    
    init(request: Request) {
        self.requestModel = request
    }
    
    var path: String {
        return "/user/sign-in"
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

extension LoginService {
    typealias RequestType = Request
    typealias ResponseType = Response
    typealias ErrorResponseType = ErrorResponse
    
    struct Request: Encodable {
        let email: String
        let password: String
        let recaptchaToken: String
        
        enum CodingKeys: String, CodingKey, Codable {
            case recaptchaToken = "recaptcha_token"
            case password,email
        }
    }
    
    struct Response: Decodable {
        let status: String
        let data: Login
        let token: String
    }
    
    struct ErrorResponse: Decodable {
        let status: String
        let errors: Errors
        
        struct Errors: Decodable {
            let email: [String]?
            let recaptchaToken: [String]?
            let password: [String]?
            
            enum CodingKeys: String, CodingKey {
                case recaptchaToken = "recaptcha_token"
                case password,email
            }
        }
    }
        
    static func userLogin(request: Request, completion: @escaping (Result<NetworkResult<Response, ErrorResponse>, NetworkError>) -> Void) {
        agent.perform(.init(request: request),
                      completion: completion)
    }
}
