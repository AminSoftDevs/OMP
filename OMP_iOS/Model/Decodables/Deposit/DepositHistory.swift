//
//  DepositHistory.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 10/11/21.
//

import UIKit

// MARK: - Datum
struct DepositHistory: Codable {
    let currency: HistoryCurrency
    let amount: Double
    let trackingCode: String?
    let status: Status
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case currency, amount
        case trackingCode = "tracking_code"
        case status
        case createdAt = "created_at"
    }
}

// MARK: - Currency
struct HistoryCurrency: Codable {
    let id, name: String
}

enum Status: String, Codable {
    case accepted   = "ACCEPTED"
    case rejected   = "REJECTED"
    
    func stringFromType() -> String {
        switch self {
        case .accepted:
            return "DepositHistory.successful".localized
        case .rejected:
            return "DepositHistory.unsuccessful".localized
        }
    }
}

extension DepositHistory {
    var creationDate: String {
        return self.createdAt.UTCLocal.convertEngNumToPersianNum()
    }
    
    var statusColor: UIColor {
        return self.status == .accepted ? .submitGreenColor : .rejectOrangeColor
    }
    
    var formattedAmount: String {
        let type: CurrencyType = self.currency.id == "IRR" ? .rial : .digital
        if type == .rial {
            return self.amount.changeToRial.formattedWithSeparator.convertEngNumToPersianNum() + " ".addCurrency()
        } else {
            return self.amount.formattedWithSeparator.convertEngNumToPersianNum() + " " + self.currency.name
        }
    }
}
