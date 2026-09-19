//
//  CreditCard.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 10/2/21.
//

import Foundation

// MARK: - CreditCard
struct CreditCard: Codable {
    let id: Int
    let card, name, verified, createdAt: String

    enum CodingKeys: String, CodingKey {
        case id, card, name, verified
        case createdAt = "created_at"
    }
}
