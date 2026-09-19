//
//  CreditCard.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 8/14/21.
//

import Foundation

struct BankInfo {
    
    var id: Int
    var card: String? = nil
    var account: String? = nil
    var name: String? = nil
    var verified: AcceptState
    var created_at: String
    var type: BankInformationType
    
    init(id: Int, card: String?, account:String?, name: String, verified: String, created_at: String, type: BankInformationType) {
        self.id = id
        self.card = card
        self.account = account
        self.name = name
        self.verified = AcceptState.fromString(verified)
        self.created_at = created_at
        self.type = type
    }
}
