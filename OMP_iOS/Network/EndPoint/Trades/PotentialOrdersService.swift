//
//  PotentialOrdersService.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 11/10/21.
//

import Foundation

struct PotentialOrdersService: EndPointType {
    
    static let agent = Router<Self>()
    
    //MARK: - INITIALIZER
    private var requestModel: Request
    
    init(request: Request) {
        self.requestModel = request
    }
    
    var path: String {
        return "/market/\(requestModel.id)/order"
    }
    
    var newHTTPMethod: HTTPMEthod {
        return .get
    }
    
    var task: HTTPTask<Request> {
        return .urlRequest(urlParameters: [:])
    }
    
    var headers: HTTPHeaderss? {
        return NetworkConfig.RequestHeader.getDefaultHeaderWithToken()
    }
    
    var version: String {
        return NetworkConfig.APIVersion.v1.rawValue
    }
    
    var marketType: AppMarket {
        return UserDefaults.standard.selectedMarket
    }
}

extension PotentialOrdersService {
    typealias RequestType = Request
    typealias ResponseType = Response
    typealias ErrorResponseType = ErrorResponse
        
    struct Request: Encodable {
        let id: Int
    }
    
    struct Response: Decodable {
        let status: String
        let data: [PotentialOrders]
    }
    
    struct ErrorResponse: Decodable {
        let status: String
        let errors: Errors
        
        struct Errors: Decodable {
            let id: [String]?
        }
    }
        
    static func getPotentialOrders(request: Request, completion: @escaping (Result<NetworkResult<Response, ErrorResponse>, NetworkError>) -> Void) {
        agent.perform(.init(request: request),
                      completion: completion)
    }
}
