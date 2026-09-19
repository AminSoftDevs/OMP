//
//  AddNewWalletAddressService.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 1/27/22.
//

import Foundation

struct AddNewWalletAddressService: EndPointType {
    
    static let agent = Router<Self>()
    
    var path: String {
        return "/user/wallet/last-used"
    }
    
    var newHTTPMethod: HTTPMEthod {
        return .post
    }
    
    var task: HTTPTask<Request> {
        return .jsonRequest(request: requestModel)
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
    
    private let requestModel: Request
    
    init(requestModel: Request) {
        self.requestModel = requestModel
    }
}

extension AddNewWalletAddressService {
    typealias RequestType = Request
    typealias ResponseType = Response
    typealias ErrorResponseType = ErrorResponse
    
    struct Request: Encodable {
        let wallet: String
        let name: String
        let currencyToken: String
        
        enum CodingKeys: String, CodingKey {
            case currencyToken = "currency_token"
            case wallet
            case name
        }
    }
    
    struct Response: Decodable {
        let status: String
    }
    
    struct ErrorResponse: Decodable {
        let status: String
        let errors: Errors
        
        struct Errors: Decodable {
            let wallet: [String]?
            let name: [String]?
            let currencyToken: [String]?
            
            enum CodingKeys: String, CodingKey {
                case currencyToken = "currency_token"
                case wallet
                case name
            }
        }
    }
    
    static func addNewWalletAddress(request: Request, completion: @escaping (Result<NetworkResult<Response, ErrorResponse>, NetworkError>) -> Void) {
        agent.perform(.init(requestModel: request),completion: completion)
    }
}
