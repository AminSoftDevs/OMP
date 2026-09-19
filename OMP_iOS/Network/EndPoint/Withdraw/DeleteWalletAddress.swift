//
//  DeleteWalletAddressService.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 1/26/22.
//

import Foundation

struct DeleteWalletAddressService: EndPointType {
    
    static let agent = Router<Self>()
    
    var path: String {
        return "/user/wallet/last-used/\(requestModel.id)"
    }
    
    var newHTTPMethod: HTTPMEthod {
        return .delete
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
        return .real
    }
    
    //MARK: - INITIALIZER
    private var requestModel: Request
    
    init(request: Request) {
        self.requestModel = request
    }
}

extension DeleteWalletAddressService {
    typealias RequestType = Request
    typealias ResponseType = Response
    typealias ErrorResponseType = ErrorResponse
    
    struct Request: Encodable {
        let id: String
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
    
    static func deleteWalletAddress(request: Request, completion: @escaping (Result<NetworkResult<Response, ErrorResponse>, NetworkError>) -> Void) {
        agent.perform(.init(request: request),completion: completion)
    }
}
