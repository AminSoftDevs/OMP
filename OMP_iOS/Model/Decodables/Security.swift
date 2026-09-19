//
//  Security.swift
//  OMP_iOS
//
//  Created by AminSoft on 9/5/1400 AP.
//

import Foundation

// MARK: - Security
struct Security: Codable {
    let id, impersonate: Int
    let device, platform: String
    let ip: String
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, impersonate
        case device, platform
        case ip
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

extension Security {
    
    var entryDate: String {
        return self.createdAt?.UTCLocal.addLineBreaker.convertEngNumToPersianNum() ?? ""
    }
    
    var exitDate: String {
        return self.updatedAt?.UTCLocal.addLineBreaker.convertEngNumToPersianNum() ?? ""
    }
}
