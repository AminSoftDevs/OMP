//
//  BankInfoViewModel.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 8/14/21.
//

import UIKit

class BankInfoAdapter {
    
    let id: Int
    let name: String
    let isAccepted: String
    let color: UIColor
    let mainInfo: String
    let editable: Bool
    let type: BankInformationType
    
    init(bankInfo: BankInfo) {
        switch bankInfo.verified {
        case .accepted:
            self.isAccepted = "confirmed".localized
        case .rejected:
            self.isAccepted = "rejected".localized
        case .pending:
            self.isAccepted = "pending".localized
        case .notStarted:
            self.isAccepted = "notStarted".localized
        case .none:
            self.isAccepted = "undefined".localized
        }
        
        self.id = bankInfo.id
        self.type = bankInfo.type
        if type == .credit {
            self.mainInfo = bankInfo.card!.secureCreditCard
            self.name = bankInfo.name!
            if bankInfo.card == "" {
                self.editable = true
                self.color = .mediumGrayColor
            } else {
                self.editable = false
                self.color = .submitGreenColor
            }
        } else {
            self.mainInfo = bankInfo.account!.keepNumbers().secureBankAccount
            self.name = ""
            if bankInfo.account == "" {
                self.editable = true
                self.color = .mediumGrayColor
            } else {
                self.editable = false
                self.color = .submitGreenColor
            }
        }
    }
}

extension String {
    var secureCreditCard: String {
        var temp = ""
        for (index, char) in self.enumerated() {
            if index > 3 && index < 12 {
                temp.append("*")
            } else {
                temp.append(char)
            }
        }
        return temp
    }
    
    var secureBankAccount: String {
        var temp = ""
        for (index, char) in self.enumerated() {
            if index > 2 && index < 20 {
                temp.append("*")
            } else {
                temp.append(char)
            }
        }
        return temp
    }
}
