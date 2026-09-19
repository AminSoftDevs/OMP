//
//  DeleteActiveIpSecurityService.swift
//  OMP_iOS
//
//  Created by AminSoft on 9/7/1400 AP.
//

import Foundation

struct DeleteActiveIpSecurityService: EndPointType {
    
    static let agent = Router<Self>()
    
    var path: String {
        return "/user/sessions"
    }
    
    var newHTTPMethod: HTTPMEthod {
        .delete
    }
    
    var task: HTTPTask<Request> {
        .jsonRequest(request: requestModel)
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

extension DeleteActiveIpSecurityService {
    typealias RequestType = Request
    typealias ResponseType = Response
    typealias ErrorResponseType = ErrorResponse
    
    struct Request: Encodable {
        let id: Int
    }
    
    struct Response: Decodable {
        let status: String
    }
    
    struct ErrorResponse: Decodable {
        let status: String
        let message: String?
    }
    
    static func deleteActiveIp(request: Request, completion: @escaping (Result<NetworkResult<Response, ErrorResponse>, NetworkError>) -> Void) {
        agent.perform(.init(request: request),completion: completion)
    }
}
