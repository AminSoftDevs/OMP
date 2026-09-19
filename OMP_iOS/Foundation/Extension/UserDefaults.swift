//
//  UserDefault.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 9/23/21.
//

import Foundation

extension UserDefaults {
    
    struct Keys {
        static let IS_LOGIN          = "isLogin"
        static let EMAIL_ADDRESS     = "emailAddress"
        static let APP_CONFIG        = "appConfig"
        static let SELECTED_LANGUAGE = "selectedLanguage"
        static let SELECTED_THEME    = "selectedTheme"
        static let SELECTED_MARKET   = "selectedMarket"
        static let IS_BIOMETRIC      = "isBiometric"
        static let TOKEN_REFERENCE   = "token"
        static let SECURITY_CODE     = "code"
        static let USER_NAME         = "userName"
    }
    
    var tokenRef: String {
        get {
            guard let value = object(forKey: Keys.TOKEN_REFERENCE) as? String else {
                return ""
            }
            return value
        }
        
        set {
            set(newValue, forKey: Keys.TOKEN_REFERENCE)
        }
    }
    
    var securityCodeReference: String {
        get {
            guard let value = object(forKey: Keys.SECURITY_CODE) as? String else {
                return ""
            }
            return value
        }
        
        set {
            set(newValue, forKey: Keys.SECURITY_CODE)
        }
    }
    
    var isLogin: Bool {
        get {
            guard let value = object(forKey: Keys.IS_LOGIN) as? Bool else {
                return false
            }
            return value
        }
        set {
            set(newValue, forKey: Keys.IS_LOGIN)
        }
    }
    
    var appConfig: AppConfig? {
        get {
            do {
                let value = try getObject(forKey: Keys.APP_CONFIG, castTo: AppConfig.self)
                return value
            } catch {
                return nil
            }
        }
        set {
            do {
                try setObject(newValue, forKey: Keys.APP_CONFIG)
            } catch let error{
                print(error)
            }
        }
    }
    
    var selectedLanguage: AppLanguage? {
        get {
            do {
                let value = try getObject(forKey: Keys.SELECTED_LANGUAGE, castTo: AppLanguage.self)
                return value
            } catch {
                return nil
            }
        }
        set {
            do {
                try setObject(newValue, forKey: Keys.SELECTED_LANGUAGE)
            } catch let error{
                print(error)
            }
        }
    }
    
    var selectedTheme: AppTheme {
        get {
            do {
                let value = try getObject(forKey: Keys.SELECTED_THEME, castTo: AppTheme.self)
                return value
            } catch {
                return .OMP
            }
        }
        set {
            do {
                try setObject(newValue, forKey: Keys.SELECTED_THEME)
            } catch let error{
                print(error)
            }
        }
    }
    
    var selectedMarket: AppMarket {
        get {
            do {
                let value = try getObject(forKey: Keys.SELECTED_MARKET, castTo: AppMarket.self)
                return value
            } catch {
                return .real
            }
        }
        set {
            do {
                try setObject(newValue, forKey: Keys.SELECTED_MARKET)
            } catch let error{
                print(error)
            }
        }
    }
    
    var userEmail: String {
        get {
            guard let value = object(forKey: Keys.EMAIL_ADDRESS) as? String else {
                return "email not found"
            }
            return value
        }
        set {
            set(newValue, forKey: Keys.EMAIL_ADDRESS)
        }
    }
    
    var isBiometric: Bool {
        get {
            guard let value = object(forKey: Keys.IS_BIOMETRIC) as? Bool else {
                return false
            }
            return value
        }
        set {
            set(newValue, forKey: Keys.IS_BIOMETRIC)
        }
    }
    
    var userName: String {
        get {
            guard let value = object(forKey: Keys.USER_NAME) as? String else {
                return "user name not found"
            }
            return value
        }
        set {
            set(newValue, forKey: Keys.USER_NAME)
        }
    }
}

protocol ObjectSavable {
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable
}

enum ObjectSavableError: String, LocalizedError {
    case unableToEncode = "Unable to encode object into data"
    case noValue = "No data object found for the given key"
    case unableToDecode = "Unable to decode object into given type"
    
    var errorDescription: String? {
        rawValue
    }
}

extension UserDefaults: ObjectSavable {
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            set(data, forKey: forKey)
        } catch {
            throw ObjectSavableError.unableToEncode
        }
    }
    
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable {
        guard let data = data(forKey: forKey) else { throw ObjectSavableError.noValue }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            throw ObjectSavableError.unableToDecode
        }
    }
}
