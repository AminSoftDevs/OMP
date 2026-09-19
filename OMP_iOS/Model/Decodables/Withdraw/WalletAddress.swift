//
//  WalletAddress.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 1/25/22.
//

import Foundation

struct WalletAddress: Codable {
    let id: Int
    let currencyToken: String
    let wallet: String
    let createdAt: String
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case id, wallet, name
        case currencyToken = "currency_token"
        case createdAt = "created_at"
    }
}
