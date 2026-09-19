//
//  BaseNotification.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 7/28/21.
//

import UIKit
import SwiftMessages

class Popup {
    
    static func showError(title: String = "", body: String, _ duration: TimeInterval = 2.0) {
        DispatchQueue.main.async {
            guard let alert: MessageView = try? SwiftMessages.viewFromNib() else {
                return
            }
            alert.configureContent(title: title, body: body, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: "Hide", buttonTapHandler: { _ in SwiftMessages.hide() })
            alert.bodyLabel?.font = UIFont.init(name: FontString.bold.rawValue, size: 13.0)
            alert.titleLabel?.font = UIFont.init(name: FontString.regular.rawValue, size: 13.0)
            alert.configureTheme(.error, iconStyle: .light)
            alert.accessibilityPrefix = "error"
            alert.bodyLabel?.textAlignment = .right
            alert.titleLabel?.textAlignment = .right
            
            var config = SwiftMessages.defaultConfig
            config.duration = .seconds(seconds: duration)
            alert.button?.isHidden = true
            SwiftMessages.show(config: config, view: alert)
        }
    }
    
    static func showSuccess(title: String = "", body: String, _ duration: TimeInterval = 2.0) {
        DispatchQueue.main.async {
            guard let alert: MessageView = try? SwiftMessages.viewFromNib() else {
                return
            }
            alert.configureContent(title: title, body: body, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: "Hide", buttonTapHandler: { _ in SwiftMessages.hide() })
            alert.bodyLabel?.font = UIFont.init(name: FontString.bold.rawValue, size: 13.0)
            alert.titleLabel?.font = UIFont.init(name: FontString.regular.rawValue, size: 13.0)
            alert.configureTheme(.success, iconStyle: .light)
            alert.accessibilityPrefix = "success"
            alert.bodyLabel?.textAlignment = .right
            alert.titleLabel?.textAlignment = .right
            
            var config = SwiftMessages.defaultConfig
            config.duration = .seconds(seconds: duration)
            alert.button?.isHidden = true
            SwiftMessages.show(config: config, view: alert)
        }
    }
}


class BaseNotification {
    static let sharedInstance = BaseNotification()
    private init() {} //This prevents others from using the default '()' initializer for this class.
//    public var font = Font.sharedInstance
    var alert:MessageView = MessageView()
    
    public func show(title: String = "", body:String, _ type:Theme = .error, _ typeString:String = "error", _ duration:TimeInterval = 2.0){
        alert = try! SwiftMessages.viewFromNib()
        alert.configureContent(title: title, body: body, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: "Hide", buttonTapHandler: { _ in SwiftMessages.hide() })
        let iconStyle: IconStyle
        iconStyle = .light
        alert.bodyLabel?.font = UIFont.init(name: FontString.bold.rawValue, size: 13.0)
        alert.titleLabel?.font = UIFont.init(name: FontString.regular.rawValue, size: 13.0)
        alert.configureTheme(type, iconStyle: iconStyle)
        alert.accessibilityPrefix = typeString
        alert.bodyLabel?.textAlignment = .right
        alert.titleLabel?.textAlignment = .right
        
        var config = SwiftMessages.defaultConfig
        config.duration = .seconds(seconds: duration)
        alert.button?.isHidden = true
        SwiftMessages.show(config: config, view: alert)
    }
}
