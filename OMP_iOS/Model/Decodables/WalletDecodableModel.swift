//
//  WalletDecodableModel.swift
//  OMP_iOS
//
//  Created by AminSoft on 7/7/1400 AP.
//

import Foundation
// MARK: - WalletDecodable
struct WalletDecodable: Codable {
    let status: String
    let data: [CurrencyDecodable]
}

// MARK: - CurrencyDecodable
struct CurrencyDecodable: Codable {
    let currency: NewCurrency
    let balance, blockedBalance: String

    enum CodingKeys: String, CodingKey {
        case currency, balance
        case blockedBalance = "blocked_balance"
    }
}

// MARK: - NewCurrency
struct NewCurrency: Codable {
    let id, name: String
    let currencyDescription: String?
    let usdcPrice: Double
    let irrBuyPrice, irrSellPrice: Double
    let withdrawFee, minimumWithdrawAmount: Double
    let iconPath: String
    let color: String
    let hasTag: Bool
    let tagLabel: TagLabel

    enum CodingKeys: String, CodingKey {
        case id, name
        case currencyDescription = "description"
        case usdcPrice = "usdc_price"
        case irrBuyPrice = "irr_buy_price"
        case irrSellPrice = "irr_sell_price"
        case withdrawFee = "withdraw_fee"
        case minimumWithdrawAmount = "minimum_withdraw_amount"
        case iconPath = "icon_path"
        case color
        case hasTag = "has_tag"
        case tagLabel = "tag_label"
    }
}

enum TagLabel: String, Codable {
    case memo = "Memo"
    case tag = "Tag"
}

extension CurrencyDecodable: Equatable {
    static func == (lhs: CurrencyDecodable, rhs: CurrencyDecodable) -> Bool {
        lhs.currency.id == rhs.currency.id && lhs.currency.name == rhs.currency.name && lhs.currency.currencyDescription == rhs.currency.currencyDescription
    }
}
