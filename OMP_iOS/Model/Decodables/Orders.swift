//
//  Orders.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 11/3/21.
//

import UIKit

// MARK: - Orders

enum OrderStatus: String, Codable {
    case completed      = "COMPLETED"
    case pending        = "PENDING"
    case canceling      = "CANCELING"
    case canceled       = "CANCELED"
    case undefined      = "undefined"

    public static func stringFromType(_ type: OrderStatus) -> String {
        switch type {
        case .canceled:
            return "OrderStatus.canceled".localized
        case .completed:
            return "OrderStatus.completed".localized
        case .pending:
            return "OrderStatus.pending".localized
        case .canceling:
            return "OrderStatus.canceling".localized
        case .undefined:
            return "OrderStatus.undefined".localized
        }
    }

    func stringFromType() -> String {
        switch self {
        case .canceled:
            return "OrderStatus.canceled".localized
        case .completed:
            return "OrderStatus.completed".localized
        case .pending:
            return "OrderStatus.pending".localized
        case .canceling:
            return "OrderStatus.canceling".localized
        case .undefined:
            return "OrderStatus.undefined".localized
        }
    }
}

struct Orders: Codable, Hashable {
    let id: Int
    let type: OrdersType
    let market: OrderMarkets
    let amount, completedAmount, price, fee: Double
    let status: OrderStatus
    let execution: Execution
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id, type, market, amount
        case completedAmount = "completed_amount"
        case price, fee, status, execution
        case createdAt = "created_at"
    }
}

enum Execution: String, Codable {
    case limit = "LIMIT"
    case market = "MARKET"
    
    func stringFromType() -> String {
        switch self {
        case .limit:
            return "OrdersSectionView.limitOrder".localized
        case .market:
            return "OrdersSectionView.fastOrder".localized
        }
    }
}

// MARK: - Market
struct OrderMarkets: Codable, Hashable  {
    let id: Int
    let name: String
    let quoteCurrency, baseCurrency: ECurrency
    let baseCurrencyPrecision, quoteCurrencyPrecision: Int

    enum CodingKeys: String, CodingKey {
        case id, name
        case quoteCurrency = "quote_currency"
        case baseCurrency = "base_currency"
        case baseCurrencyPrecision = "base_currency_precision"
        case quoteCurrencyPrecision = "quote_currency_precision"
    }
}

// MARK: - ECurrency
struct ECurrency: Codable, Hashable  {
    let id: String
    let decimalPrecision: Int

    enum CodingKeys: String, CodingKey {
        case id
        case decimalPrecision = "decimal_precision"
    }
}

enum OrdersType: String, Codable {
    case buy    = "buy"
    case sell   = "sell"
}

extension Orders {
    var totalPrice: String {
        return (self.amount * self.price.changeToToman).formattedWithSeparator.convertEngNumToPersianNum()
    }
    
    var formattedAmount: String {
        return String(self.amount.format(f: "\(self.market.baseCurrency.decimalPrecision)")).removeZeroFromEnd.convertEngNumToPersianNum()
    }
    
    var orderColor: UIColor {
        return self.type == .buy ? .submitGreenColor : .rejectOrangeColor
    }
}
