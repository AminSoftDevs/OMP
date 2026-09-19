//
//  AccountTable.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 8/5/21.
//

import Foundation
import UIKit

enum AccountTableItemsType {
    case identityVerification
    case profile
    case transactionHistory
    case setting
    case support
    case security
    case logout
    case userGuid
    case referral
}

struct AccountTableOptions {
    let title: String
    let iconName: String
    let type: AccountTableItemsType
}

extension AccountTableOptions {
    var color: UIColor {
        return type == .logout ? .rejectOrangeColor : .textColor
    }
}
