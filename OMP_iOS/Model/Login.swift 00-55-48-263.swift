//
//  Login.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 8/4/21.
//

import Foundation

// MARK: - Login
struct Login: Codable {
    let email: String
    let emailVerified, phoneVerified, identityCardVerified: AcceptState
    let bankVerified, addressVerified, identityVerified: AcceptState
    let googleAuthEnabled: Bool

    enum CodingKeys: String, CodingKey {
        case email
        case emailVerified = "email_verified"
        case phoneVerified = "phone_verified"
        case identityCardVerified = "identity_card_verified"
        case bankVerified = "bank_verified"
        case addressVerified = "address_verified"
        case identityVerified = "identity_verified"
        case googleAuthEnabled = "google_auth_enabled"
    }
}
