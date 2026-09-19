//
//  UserSettingService.swift
//  OMP_iOS
//
//  Created by AminSoft on 7/28/1400 AP.
//

import Foundation

struct UserSettingService: EndPointType {
    
    static let agent = Router<Self>()
    
    var path: String {
        return "/user"
    }
    
    var newHTTPMethod: HTTPMEthod {
        .get
    }
    
    var task: HTTPTask<Request> {
        .urlRequest(urlParameters: [:])
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

extension UserSettingService {
    typealias RequestType = Request
    typealias ResponseType = Response
    typealias ErrorResponseType = ErrorResponse
    
    struct Request: Encodable {
        
    }
    
    struct Response: Decodable {
        let status: String
        let data: UserInfo
    }
    
    struct ErrorResponse: Decodable {
        let status: String
        let message: String?
    }
    
    static func getUserSetting(comletion: @escaping (Result<NetworkResult<Response, ErrorResponse>, NetworkError>) -> Void) {
        agent.perform(.init(), completion: comletion)
    }
}
