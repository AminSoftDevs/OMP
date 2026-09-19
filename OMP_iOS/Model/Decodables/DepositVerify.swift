//
//  DepositVerify.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 10/3/21.
//

import Foundation

struct DepositVerify: Decodable {
    
    let message: String
    let trackingCode: String
    
    enum CodingKeys: String, CodingKey {
        case message
        case trackingCode = "tracking_code"
    }
}
