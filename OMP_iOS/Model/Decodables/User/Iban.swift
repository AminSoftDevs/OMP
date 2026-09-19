//
//  Iban.swift
//  OMP_iOS
//
//  Created by AminSoft on 7/11/1400 AP.
//

import Foundation

// MARK: - Iban
struct Iban: Codable {
    let id: Int
    let iban, verified, createdAt: String

    enum CodingKeys: String, CodingKey {
        case id, iban, verified
        case createdAt = "created_at"
    }
}

extension Iban {
    var ibanValue: String {
        return self.iban.convertEngNumToPersianNum()
    }
}

