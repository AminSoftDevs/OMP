//
//  SecurityService.swift
//  OMP_iOS
//
//  Created by AminSoft on 9/5/1400 AP.
//

import Foundation

struct SecurityService: EndPointType {
    
    static let agent = Router<Self>()
    
    var path: String {
        return "/user/sessions"
    }
    
    var newHTTPMethod: HTTPMEthod {
        .get
    }
    
    var task: HTTPTask<Request> {
        .urlRequest(urlParameters: ["page" : requestModel.page])
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

extension SecurityService {
    typealias RequestType = Request
    typealias ResponseType = Response
    typealias ErrorResponseType = ErrorResponse
    
    struct Request: Encodable {
        let active: Bool
        let page: Int
    }
    
    struct Response: Decodable {
        let status: String
        let data: [Security]
    }
    
    struct ErrorResponse: Decodable {
        let status: String
        let message: String?
    }
    
    static func getUserSecurityInformation(request: Request, completion: @escaping (Result<NetworkResult<Response, ErrorResponse>, NetworkError>) -> Void) {
        agent.perform(.init(request: request),completion: completion)
    }
}
