//
//  AnnouncementsService.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 12/13/21.
//

import Foundation
import Alamofire

struct AnnouncementsService: EndPointType {
    
    static let agent = Router<Self>()
    
    var path: String {
        return "/notification"
    }
    
    var newHTTPMethod: HTTPMEthod {
        return .get
    }
    
    var task: HTTPTask<Request> {
        return .urlRequest(urlParameters: ["page": request.page])
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

extension AnnouncementsService {
    typealias RequestType = Request
    typealias ResponseType = Response
    typealias ErrorResponseType = ErrorResponse
    
    struct Request: Encodable {
        let page: Int
    }
    
    struct Response: Decodable {
        let status: String
        let data: [Announcement]
    }
    
    struct ErrorResponse: Decodable {
        let status: String
        let message: String?
    }
    
    static func getAnnouncements(request: Request, completion: @escaping (Result<NetworkResult<Response, ErrorResponse>, NetworkError>) -> Void) {
        agent.perform(.init(request: request), completion: completion)
    }
}
