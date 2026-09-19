//
//  NewOrderService.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 11/12/21.
//

import Foundation

struct NewOrderService: EndPointType {
    
    static let agent = Router<Self>()
    
    //MARK: - INITIALIZER
    private var requestModel: Request
    
    init(request: Request) {
        self.requestModel = request
    }
    
    var path: String {
        return "/market/\(requestModel.marketID)/order"
    }
    
    var newHTTPMethod: HTTPMEthod {
        return .post
    }
    
    var task: HTTPTask<Request> {
        return .urlRequest(urlParameters: ["amount": requestModel.amount,
                                           "price": requestModel.price,
                                           "type": requestModel.type,
                                           "execution": requestModel.execution,
                                          ])
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

extension NewOrderService {
    typealias RequestType = Request
    typealias ResponseType = Response
    typealias ErrorResponseType = ErrorResponse
        
    struct Request: Encodable {
        let marketID: Int
        let amount: String
        let price: String
        let type: String
        let execution: String
    }
    
    struct Response: Decodable {
    }
    
    struct ErrorResponse: Decodable {
        let status: String
        let errors: Errors
        
        struct Errors: Decodable {
            let amount: [String]?
            let price: [String]?
            let type: [String]?
            let execution: [String]?
        }
    }
        
    static func createNewOrder(request: Request, completion: @escaping (Result<NetworkResult<Response, ErrorResponse>, NetworkError>) -> Void) {
        agent.perform(.init(request: request),
                      completion: completion)
    }
}
