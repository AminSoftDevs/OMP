//
//  Login.swift
//  OMP_iOS
//
//  Created by AminSoft on 7/1/1400 AP.
//

import Foundation

struct LogIn: Decodable {
    let emailVerified: String
    let phoneVerified: String
    let identityCardVerified: String
    let addressVerified: String
    let email: String
    let identityVerified: String
    let googleAuthEnabled: Bool
    let bankVerified: String
    let token: String
    
    enum DataCodingKeys: String, CodingKey {
        case emailVerified = "email_verified"
        case phoneVerified = "phone_verified"
        case identityCardVerified = "identity_card_verified"
        case addressVerified = "address_verified"
        case email
        case identityVerified = "identity_verified"
        case googleAuthEnabled = "google_auth_enabled"
        case bankVerified = "bank_verified"
    }
    
    enum CodingKeys: String, CodingKey {
        case data
        case token
        case status
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.token = try container.decode(String.self, forKey: .token)
        
        let dataContainer = try container.nestedContainer(keyedBy: DataCodingKeys.self, forKey: .data)
        
        self.emailVerified = try dataContainer.decode(String.self, forKey: .emailVerified)
        self.phoneVerified = try dataContainer.decode(String.self, forKey: .phoneVerified)
        self.identityCardVerified = try dataContainer.decode(String.self, forKey: .identityCardVerified)
        self.addressVerified = try dataContainer.decode(String.self, forKey: .addressVerified)
        self.email = try dataContainer.decode(String.self, forKey: .email)
        self.identityVerified = try dataContainer.decode(String.self, forKey: .identityVerified)
        self.googleAuthEnabled = try dataContainer.decode(Bool.self, forKey: .googleAuthEnabled)
        self.bankVerified = try dataContainer.decode(String.self, forKey: .bankVerified)
    }
}
