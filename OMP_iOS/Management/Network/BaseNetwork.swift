//
//  BaseNetwork.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 7/28/21.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

enum StatusType: String {
    case ok              = "OK"
    case error           = "ERROR"
    case validationError = "VALIDATION_ERROR"
    case undefined       = "خطای ارتباط با سرور"
    case tooManyRequest  = "TOO MANY REQUEST"
    case forbidden       = "FORBIDDEN"
    case unauthorized
    case noInternet
    
    public static func fromString(_ caseStudy: String) -> StatusType {
        switch caseStudy {
        case "OK":
            return .ok
        case "ERROR":
            return .error
        case "VALIDATION_ERROR":
            return .validationError
        case "TOO MANY REQUEST":
            return .tooManyRequest
        default:
            return .undefined
        }
        
    }
    
    public static func fromCode(_ code: Int) -> StatusType {
        switch code {
        case 200, 201:
            return .ok
        case 400:
            return .error
        case 401:
            return .unauthorized
        case 403:
            return .forbidden
        case 423,422:
            return .validationError
        case 429:
            return .tooManyRequest
        default:
            return .undefined
        }
        
    }
}

class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}

class BaseNetwork {
    static let sharedInstance = BaseNetwork()
    private init(){}
    private let utility = BaseModule.sharedInstance
    private let OS_VERSION = UIDevice.current.systemVersion
    private let DEVICE_NAME = UIDevice.modelName
    private let BUILD_NUMBER = Bundle().buildVersionNumber
    private let RELEASE_VERSION = Bundle().releaseVersionNumber
    
    private func loadData(parameters: [String: AnyObject], url: String = "", needToken: Bool = true, method: HTTPMethod = .post, header: HTTPHeaders? = nil, completionHandler: @escaping ((_ statusCode: StatusType, _ data: JSON, _ error: Bool, _ msg: String ) -> ())){
        
        let final_url = Constants.BASE_URL + url
        var finalParameters = parameters
        var finalHeader = HTTPHeaders()
        
        if needToken {
            finalHeader["Authorization"] = "Bearer \(KeychainData.token)"
        }
        
        finalParameters["user-device"] = "ios" as AnyObject?
        finalParameters["app-version"] = RELEASE_VERSION as AnyObject?
        
        print(final_url)
        print(finalParameters)
        AF.request(final_url, method: method, parameters: finalParameters, headers: finalHeader).validate(statusCode: 200..<500).responseJSON { response in
            //let err = ServerStatusCodeHandling.fromCode(code: response.response?.statusCode ?? 0)
            let status = StatusType.fromCode(response.response?.statusCode ?? 0)
            switch response.result {
            case .success:
                guard let value = response.value, let statusCode = response.response?.statusCode else {
                    print(response.response?.statusCode ?? 0)
                    completionHandler(status, JSON(), false, status.rawValue)
                    return
                }
                
                if status == .unauthorized && UserDefaults.standard.isLogin {
                    
                    UserDefaults.standard.isLogin = false
                    KeychainData.deleteToken()
                    let vc = UINavigationController(rootViewController: LoginViewController())
                    UIApplication.changeRootViewController(vc)
                    NotificationCenter.default.post(name: .logout, object: nil)
                }
                
                print("Done with: ", statusCode)
                
                let json = JSON(value)
                print(json)
                completionHandler(status, json, false, json["message"].stringValue)
            case .failure(_):
                if Connectivity.isConnectedToInternet == false {
                    completionHandler(.noInternet, JSON(), true, "noInternetConnection".localized)
                } else {
                    completionHandler(status, JSON(), true, "serverResponseError".localized)
                }
            }
        }
    }
    
    private func uploadData(imageKey: String, image: Data, parameters: [String: String], url: String, method: HTTPMethod = .post, header: HTTPHeaders? = nil, completionHandler: @escaping ((_ statusCode: StatusType, _ data: JSON, _ error: Bool, _ msg: String ) -> ())) {
        
        let final_url = Constants.BASE_URL + url
        
        var finalParameters = parameters
        finalParameters["user-device"] = "ios"
        finalParameters["app-version"] = BUILD_NUMBER
        
        var header = HTTPHeaders()
        header["Authorization"] = "Bearer \(KeychainData.token)"
        
        print("IMAGE UPLOADER: ", parameters)
        
        AF.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(image, withName: imageKey, fileName: "\(imageKey).png", mimeType: "image/png")
            for (key, value) in finalParameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to: final_url, headers: header).validate(statusCode: 200..<500).responseJSON { response in
            
            let status = StatusType.fromCode(response.response?.statusCode ?? 0)
            let statusCode = response.response?.statusCode ?? 0
            
            print("Done with: ", statusCode)
            
            switch response.result {
            case .success:
                guard let value = response.value else {
                    completionHandler(status, JSON(), true, "serverResponseError".localized)
                    return
                }
                let json = JSON(value)
                let message = json["message"].stringValue
                completionHandler(status, json , false, message)
            case .failure:
                completionHandler(status, JSON(), true, "serverResponseError".localized)
            }
        }
    }
    
    func uploadIdentityPhotoAPI(userInformation: UserIdentity, image: Data, completionHandler: @escaping (_ status: StatusType, _ error: Bool, _ msg: String) -> ()) {
        
        let parameters = [
                          "national_id": userInformation.nationalId,
                          "birthday": userInformation.birthDay]
        
        uploadData(imageKey: "national_id_image", image: image, parameters: parameters, url: PostWebService.uploadIdentityInformation.rawValue) { status, json, error, msg in
            if error {
                completionHandler(status, true, msg)
            } else {
                if status == .ok {
                    completionHandler(status, false,msg)
                } else {
                    let error               = json["errors"]
                    let nationalId          = error["national_id"].arrayValue.first?.stringValue
                    let birthday            = error["birthday"].arrayValue.first?.stringValue
                    let nationalIdImage     = error["national_id_image"].arrayValue.first?.stringValue
                    
                    var message = ""
                    if nationalId != nil {
                        message = nationalId!
                    } else if birthday != nil {
                        message = birthday!
                    } else if nationalIdImage != nil {
                        message = nationalIdImage!
                    } else {
                        message = msg
                    }
                    completionHandler(status, true, message)
                }
            }
        }
    }
            
    func uploadAddressDocumentsPhotoAPI(userAddress: UserAddress, completionHandler: @escaping (_ status: StatusType, _ error: Bool, _ msg: String) -> ()) {
        
        let parameters = [
                          "province_id": userAddress.province_id,
                          "city_id": userAddress.city_id,
                          "address": userAddress.address,
                          "postal_code": userAddress.postal_code,
        ] as [String : AnyObject]
        
        loadData(parameters: parameters , url: PostWebService.addressVerification.rawValue, needToken: true) { (status, json, error, msg) in
            if error {
                completionHandler(status, true, msg)
            } else {
                let error                   = json["errors"]
                let province_id             = error["province_id"].arrayValue.first?.stringValue
                let city_id                 = error["city_id"].arrayValue.first?.stringValue
                let address                 = error["address"].arrayValue.first?.stringValue
                let postal_code             = error["postal_code"].arrayValue.first?.stringValue
                
                var message = ""
                
                if province_id != nil {
                    message = province_id!
                } else if city_id != nil {
                    message = city_id!
                } else if address != nil {
                    message = address!
                } else if postal_code != nil {
                    message = postal_code!
                }
                completionHandler(status, true, message)
            }
        }
    }
    
    func uploadSelfIdentityImageAPI(image: Data, completionHandler: @escaping (_ status: StatusType, _ error: Bool, _ msg: String) -> ()) {
        let parameters: [String: String] = [:]
        uploadData(imageKey: "identity_photo", image: image, parameters: parameters, url: PostWebService.identityImage.rawValue) { status, json, error, msg in
            if error {
                completionHandler(status, true, msg)
            } else {
                if status == .ok {
                    completionHandler(status, false,msg)
                } else {
                    let error               = json["errors"]
                    let message             = error["identity_photo"].arrayValue.first?.stringValue
                    completionHandler(status, true, message ?? msg)
                }
            }
        }
    }
}
