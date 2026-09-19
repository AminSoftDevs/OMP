//
//  WithdrawHistory.swift
//  OMP_iOS
//
//  Created by AminSoft on 7/20/1400 AP.
//

import UIKit
// MARK: - WithdrawHistory
struct WithdrawHistory: Codable {
    let currency: HistoryCurrency
    let amount: Double
    let trackingCode: String?
    let status: WithdrawHistoryStatus
    let createdAt: String
    let wallet: String
    let message: String?
    let fee: Double

    enum CodingKeys: String, CodingKey {
        case currency, amount, message, wallet
        case trackingCode = "tracking_code"
        case status
        case createdAt = "created_at"
        case fee
    }
}

enum WithdrawHistoryStatus: String, Codable {
    case canceled = "CANCELED"
    case done = "DONE"
    case pending = "PENDING"
    case processing = "PROCESSING"
    
    func stringFromType() -> String {
        switch self {
        case .done:
            return "DepositHistory.successful".localized
        case .canceled:
            return "DepositHistory.unsuccessful".localized
        case .pending:
            return "WithdrawHistory.pending".localized
        case .processing:
            return "WithdrawHistory.processing".localized
        }
    }
}
extension WithdrawHistory {
    
    var creationDate: String {
        self.createdAt.UTCLocal.convertEngNumToPersianNum()
    }
    
    var statusColor: UIColor {
        switch self.status {
        case .done:
            return .submitGreenColor
        case .canceled:
            return .rejectOrangeColor
        case .pending:
            return .rejectOrangeColor
        case .processing:
            return .rejectOrangeColor
        }
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

