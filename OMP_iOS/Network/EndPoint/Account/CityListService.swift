//
//  CityListService.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 12/15/21.
//

import Foundation

struct CityListService: EndPointType {
    
    static let agent = Router<Self>()
    
    var path: String {
        return "/city"
    }
    
    var newHTTPMethod: HTTPMEthod {
        return .get
    }
    
    var task: HTTPTask<Request> {
        return .urlRequest(urlParameters: ["province_id": requestModel.id])
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

extension CityListService {
    typealias RequestType = Request
    typealias ResponseType = Response
    typealias ErrorResponseType = ErrorResponse
    
    struct Request: Encodable {
        let id: Int
    }
    
    struct Response: Decodable {
        let status: String
        let data: [City]
    }
    
    struct ErrorResponse: Decodable {
        let status: String
        let errors: Errors
        
        struct Errors: Decodable {
            let provinceID: [String]?
            
            enum CodingKeys: String, CodingKey {
                case provinceID = "province_id"
            }
        }
    }
    
    static func getCityList(request: Request, completion: @escaping (Result<NetworkResult<Response, ErrorResponse>, NetworkError>) -> Void) {
        agent.perform(.init(request: request), completion: completion)
    }
}
