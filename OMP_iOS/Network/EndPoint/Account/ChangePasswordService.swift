//
//  ChangePasswordService.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 12/13/21.
//

import Foundation

struct ChangePasswordService: EndPointType {
    
    static let agent = Router<Self>()
    
    var path: String {
        return "/user"
    }
    
    var newHTTPMethod: HTTPMEthod {
        .put
    }
    
    var task: HTTPTask<Request> {
        .urlRequest(urlParameters: ["password": requestModel.newPassword,
                                    "old_password": requestModel.oldPassword])
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

extension ChangePasswordService {
    typealias RequestType = Request
    typealias ResponseType = Response
    typealias ErrorResponseType = ErrorResponse
    
    struct Request: Encodable {
        let newPassword: String
        let oldPassword: String
    }
    
    struct Response: Decodable {
        let status: String
        let message: String?
    }
    
    struct ErrorResponse: Decodable {
        let status: String
        let errors: Errors
        
        struct Errors: Decodable {
            let newPassword: [String]?
            let oldPassword: [String]?
            
            enum CodingKeys: String, CodingKey {
                case newPassword = "password"
                case oldPassword = "old_password"
            }
        }
    }
    
    static func changePassword(request: Request, completion: @escaping (Result<NetworkResult<Response, ErrorResponse>, NetworkError>) -> Void) {
        agent.perform(.init(request: request), completion: completion)
    }
}
