//
//  AddressInformationService.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 12/20/21.
//

import Foundation

struct AddressInformationService: EndPointType {
    
    static let agent = Router<Self>()
    
    var path: String {
        return "/user/verification/address"
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
    //MARK: - INITIALIZER
    private var requestModel: Request
    
    init(request: Request) {
        self.requestModel = request
    }
}

extension AddressInformationService {
    typealias RequestType = Request
    typealias ResponseType = Response
    typealias ErrorResponseType = ErrorResponse
    
    struct Request: Encodable {
        let provinceID: String
        let cityID: String
        let address: String
        let postalCode: String
        
        enum CodingKeys: String, CodingKey {
            case provinceID = "province_id"
            case cityID = "city_id"
            case address
            case postalCode = "postal_code"
        }
    }
    
    struct Response: Decodable {
        let status: String
    }
    
    struct ErrorResponse: Decodable {
        let status: String
        let errors: Errors
        
        struct Errors: Decodable {
            let provinceID: [String]?
            let cityID: [String]?
            let address: [String]?
            let postalCode: [String]?
            
            enum CodingKeys: String, CodingKey {
                case provinceID = "province_id"
                case cityID = "city_id"
                case address
                case postalCode = "postal_code"
            }
        }
    }
    
    static func registerAddressInformation(request: Request, completion: @escaping (Result<NetworkResult<Response, ErrorResponse>, NetworkError>) -> Void) {
        agent.perform(.init(request: request),completion: completion)
    }
}
