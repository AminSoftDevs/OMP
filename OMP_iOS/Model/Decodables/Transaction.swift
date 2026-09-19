//
//  Transaction.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 8/26/21.
//

import UIKit

enum TransactionType: String, Codable {
    case withdraw
    case trade
    case deposit
    case none
    
    func stringFromType() -> String {
        switch self {
        case .withdraw:
            return "withdraw".localized
        case .deposit:
            return "deposit".localized
        case .trade:
            return "trade".localized
        case .none:
            return "undefined".localized
        }
    }
}

// MARK: - Transaction
struct Transaction: Codable {
    let id: Int
    let type: TransactionType
    let currency: Currency
    let amount, balance: Double
    let datumDescription: String?
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id, type, currency, amount, balance
        case datumDescription = "description"
        case createdAt = "created_at"
    }
}

// MARK: - Currency
struct Currency: Codable {
    let id: String
    let name: String
    let iconPath: String
    let decimalPrecision: Int

    enum CodingKeys: String, CodingKey {
        case id, name
        case iconPath = "icon_path"
        case decimalPrecision = "decimal_precision"
    }
}

extension Transaction {
    var transactionType: String {
        return self.type.stringFromType()
    }
    
    var transactionBalance: String {
        if abs(self.balance) > 1 {
            return String(self.balance.formattedWithSeparator).convertEngNumToPersianNum()
        } else {
           return String(self.balance).convertEngNumToPersianNum()
        }
    }
    
    var createdTime: String {
        return self.createdAt.UTCLocal.convertEngNumToPersianNum()
    }
    
    var iconName: String {
        return self.amount > 0 ? "arrow_up_icon" : "arrow_down_icon"
    }
    
    var color: UIColor {
        return self.amount > 0 ? .submitGreenColor : .rejectOrangeColor
    }
    
    var currencyName: String {
        return self.currency.name
    }
    
    var transactionAmount: String {
        return self.amount > 1 ? String(self.amount.formattedWithSeparator).convertEngNumToPersianNum() + " " + self.currencyName : String(self.amount).convertEngNumToPersianNum() + " " + self.currencyName
    }
}
