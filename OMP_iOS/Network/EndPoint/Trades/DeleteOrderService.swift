//
//  DeleteOrderService.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 11/10/21.
//

import Foundation

struct DeleteOrderService: EndPointType {
    
    static let agent = Router<Self>()
    
    var path: String {
        return "/user/order"
    }
    
    var newHTTPMethod: HTTPMEthod {
        return .delete
    }
    
    var task: HTTPTask<Request> {
        return .urlRequest(urlParameters: ["id":requestModel.id])
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
    
    //MARK: - INITIALIZER
    private var requestModel: Request
    
    init(request: Request) {
        self.requestModel = request
    }
}

extension DeleteOrderService {
    typealias RequestType = Request
    typealias ResponseType = Response
    typealias ErrorResponseType = ErrorResponse
    
    struct Request: Encodable {
        let id: Int
    }
    
    struct Response: Decodable {
        let status: String
        let message: String?
    }
    
    struct ErrorResponse: Decodable {
        let status: String
        let errors: Errors
        
        struct Errors: Decodable {
            let id: [String]?
        }
    }
    
    static func deleteOrderService(request: Request, completion: @escaping (Result<NetworkResult<Response, ErrorResponse>, NetworkError>) -> Void) {
        agent.perform(.init(request: request),completion: completion)
    }
}
