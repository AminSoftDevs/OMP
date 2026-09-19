//
//  ReadingAnnouncementService.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 12/13/21.
//

import Foundation

struct ReadingAnnouncementService: EndPointType {
    
    static let agent = Router<Self>()
    
    var path: String {
        return "/notification"
    }
    
    var newHTTPMethod: HTTPMEthod {
        .put
    }
    
    var task: HTTPTask<Request> {
        .urlRequest(urlParameters: ["id": requestModel.id])
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

extension ReadingAnnouncementService {
    typealias RequestType = Request
    typealias ResponseType = Response
    typealias ErrorResponseType = ErrorResponse
    
    struct Request: Encodable {
        let id: Int
    }
    
    struct Response: Decodable {
        
    }
    
    struct ErrorResponse: Decodable {
        let status: String
        let errors: Errors
        
        struct Errors: Decodable {
            let id: [String]?
        }
    }
    
    static func readingAnnouncement(request: Request, completion: @escaping (Result<NetworkResult<Response, ErrorResponse>, NetworkError>) -> Void) {
        agent.perform(.init(request: request), completion: completion)
    }
}
