//
//  Keychain.swift
//
//  Created by Moein Barzegaran on 9/23/21.
//

import Foundation
import Security

class KeyChain {
    
    struct ServerToken {
        static let token = "token"
    }
    
    struct SecurityCode {
        static let code = "code"
    }
    
    class func save(key: String, data: Data) -> OSStatus {
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: key,
            kSecValueData as String: data ] as [String: Any]

        SecItemDelete(query as CFDictionary)

        return SecItemAdd(query as CFDictionary, nil)
    }

    class func load(key: String) -> Data? {
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne ] as [String: Any]

        var dataTypeRef: AnyObject?

        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        if status == noErr {
            return dataTypeRef as? Data
        } else {
            return nil
        }
    }

    class func loadString(key: String) -> String? {
        guard let data = load(key: key) else {
            return nil
        }
        print("### token", String(data: data, encoding: .utf8)!)
        return String(data: data, encoding: .utf8)
    }

    class func save(key: String, value: String) -> OSStatus {
        guard let data = value.data(using: .utf8) else {
            return .zero
        }
        return save(key: key, data: data)
    }

    class func createUniqueID() -> String {
        let uuid: CFUUID = CFUUIDCreate(nil)
        let cfStr: CFString = CFUUIDCreateString(nil, uuid)

        let swiftString: String = cfStr as String
        return swiftString
    }

    class func delete(key: String) {
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: key
        ] as [String: Any]
        SecItemDelete(query as CFDictionary)
    }
}

extension Data {
    init<T>(from value: T) {
        var value = value
        var data = Data()
        withUnsafePointer(to: &value, { (ptr: UnsafePointer<T>) -> Void in
            data = Data( buffer: UnsafeBufferPointer(start: ptr, count: 1))
        })
        self.init(data)
    }

    func to<T>(type: T.Type) -> T {
        return self.withUnsafeBytes { $0.load(as: T.self) }
    }
}
