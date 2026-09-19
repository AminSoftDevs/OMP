//
//  KeychainData.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 7/28/21.
//

import Foundation

public enum GenderType: String {
    case male
    case female
    
    public static func fromString(caseStudy: String) -> GenderType {
        switch caseStudy {
        case "مرد":
            return .male
        default:
            return .female
        }
    }
}

class KeychainData {
    
    static var token: String {
        get {
            return KeyChain.loadString(key: UserDefaults.standard.tokenRef) ?? ""
        }
        set {
            _ = KeyChain.save(key: UserDefaults.standard.tokenRef, value: newValue)
        }
    }
    
    static var securityCode: String {
        get {
            return KeyChain.loadString(key: UserDefaults.standard.securityCodeReference) ?? ""
        }
        set {
            _ = KeyChain.save(key: UserDefaults.standard.securityCodeReference, value: newValue)
        }
    }
    
    static func deleteToken() {
        KeyChain.delete(key: KeyChain.ServerToken.token)
    }
    
    static func deleteSecurityCode() {
        KeyChain.delete(key: KeyChain.SecurityCode.code)
    }
}
