//
//  EditWalletAddressService.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 1/27/22.
//

import Foundation

struct EditWalletAddressService: EndPointType {
    
    static let agent = Router<Self>()
    
    var path: String {
        return "/user/wallet/last-used/\(requestModel.id)"
    }
    
    var newHTTPMethod: HTTPMEthod {
        .put
    }
    
    var task: HTTPTask<Request> {
        .urlRequest(urlParameters: ["wallet": requestModel.wallet,
                                    "name": requestModel.name ?? ""
                                   ])
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

extension EditWalletAddressService {
    typealias RequestType = Request
    typealias ResponseType = Response
    typealias ErrorResponseType = ErrorResponse
    
    struct Request: Encodable {
        let id: Int
        let wallet: String
        let name: String?
    }
    
    struct Response: Decodable {
        
    }
    
    struct ErrorResponse: Decodable {
        let status: String
        let errors: Errors
        
        struct Errors: Decodable {
            let id: [String]?
            let wallet: [String]?
            let name: [String]?
        }
    }
    
    static func editWalletAddress(request: Request, completion: @escaping (Result<NetworkResult<Response, ErrorResponse>, NetworkError>) -> Void) {
        agent.perform(.init(request: request), completion: completion)
    }
}
