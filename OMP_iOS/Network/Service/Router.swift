//
//  Router.swift
//  OMP_iOS
//
//  Created by AminSoft on 7/1/1400 AP.
//

import Foundation

class Router<EndPoint: EndPointType> {

    private var task: URLSessionTask?
    
    func perform(_ route: EndPoint, _ decoder: JSONDecoder = JSONDecoder(), completion: @escaping (Result<NetworkResult<EndPoint.Response, EndPoint.ErrorResponse>, NetworkError>) -> Void) {
        let session = URLSession.shared
        do {
            let request = try self.buildRequest(from: route)
            task = session.dataTask(with: request, completionHandler: { [weak self] data, response, error in
                
                guard let self = self else { return }
                
                guard let data = data else {
                    return completion(.failure(.noData))
                }
                
                guard let response = response as? HTTPURLResponse else {
                    return completion(.failure(.noData))
                }
                
                NetworkLogger.log(request: request, data: data, response: response)
                
                self.handleRequestResponse(response,
                                                                data: data,
                                                                decoder: decoder,
                                                                completion: completion)
                
            })
        } catch {
            DispatchQueue.main.async {
                completion(.failure(.requestBuildFailed))
            }
        }
        self.task?.resume()
    }
    
    // MARK: - Handle status codes and actions -
    fileprivate func handleRequestResponse(_ response: HTTPURLResponse,
                                           data: Data,
                                           decoder: JSONDecoder,
                                           completion: @escaping (Result<NetworkResult<EndPoint.Response, EndPoint.ErrorResponse>, NetworkError>) -> Void) {
        
        switch response.statusCode {
        case 200...299:
            
            do {
                let decodedModel = try decoder.decode(EndPoint.Response.self, from: data)
                
                DispatchQueue.main.async {
                    completion(.success(.success(response: decodedModel)))
                }
                
            } catch let error {
                DispatchQueue.main.async {
                    completion(.failure(.unableToDecode(error: error)))
                }
            }
            
        case 400:
            do {
                let decodedModel = try decoder.decode(BaseResponse.self, from: data)
                Popup.showError(body: decodedModel.message ?? "")
            } catch let error {
                DispatchQueue.main.async {
                    completion(.failure(.unableToDecode(error: error)))
                }
            }
        case 403:
            do {
                let decodedModel = try decoder.decode(BaseResponse.self, from: data)
                completion(.failure(.forbidden(message: decodedModel.message ?? "")))
            } catch let error {
                DispatchQueue.main.async {
                    completion(.failure(.unableToDecode(error: error)))
                }
            }
        case 401:
            // TODO: handle logout
            // You can send notification in order to handle logout
            // or
            // Use coordinator to handle root view controller change action
            NotificationCenter.default.post(name: .shouldLogin, object: nil)
            completion(.failure(.unauthorized))
            
        case 422:
            
            do {
                let decodedModel = try decoder.decode(EndPoint.ErrorResponse.self, from: data)
                
                DispatchQueue.main.async {
                    completion(.success(.validation(error: decodedModel)))
                }
                
            } catch let error {
                DispatchQueue.main.async {
                    completion(.failure(.unableToDecode(error: error)))
                }
            }
            
        case 429:
            do {
                let decodedModel = try decoder.decode(BaseResponse.self, from: data)
                Popup.showError(body: decodedModel.message ?? "")
            } catch let error {
                DispatchQueue.main.async {
                    completion(.failure(.unableToDecode(error: error)))
                }
            }
        case 400...499:
            completion(.failure(.badRequest(error: data)))
            
        case 500...599:
            completion(.failure(.internalServerError))
            
        default:
            completion(.failure(.unknown))
        }
    }
    
    func cancel() {
        self.task?.cancel()
    }
    
    fileprivate func buildRequest(from route: EndPoint) throws -> URLRequest {
        
        let marketType = route.marketType.rawValue // setup MarketType For Handled Change Market
            
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.version + marketType + route.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)
        
        request.httpMethod = route.newHTTPMethod.rawValue
        
        self.addAdditionalHeaders(route.headers, request: &request)
        
        do {
            switch route.task {
            case let .urlRequest(urlParameters):
                try URLParameterEncoder().encode(urlRequest: &request, with: urlParameters)
                
            case let .jsonRequest(requestModel):
                try JSONParameterEncoder().encode(urlRequest: &request, with: requestModel)
                
            case let .jsonAndURLRequest(urlParameters, requestModel):
                try URLParameterEncoder().encode(urlRequest: &request, with: urlParameters)
                try JSONParameterEncoder().encode(urlRequest: &request, with: requestModel)
            }
            return request
        } catch {
            throw error
        }
    }
    
    fileprivate func addAdditionalHeaders(_ additionalHeaders: HTTPHeaderss?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
}
