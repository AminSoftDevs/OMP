//
//  UserWallet.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 9/26/21.
//

import Foundation

// MARK: - Datum
struct Wallet: Codable {
    let currency: NewCurrency
    let balance, blockedBalance: String

    enum CodingKeys: String, CodingKey {
        case currency, balance
        case blockedBalance = "blocked_balance"
    }
}

// MARK: - Currency
struct NewCurrency: Codable {
    let id, name: String
    let currencyDescription: String?
    let usdcPrice, irrBuyPrice, irrSellPrice, withdrawFee: Double
    let minimumWithdrawAmount: Double
    let iconPath: String
    let color: String
    let hasTag: Bool?
    let tagLabel: String?
    let tokens: [String]

    enum CodingKeys: String, CodingKey {
        case id, name, tokens
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



extension Wallet {
    
    var formattedID: String {
        return self.currency.id == "IRR" ? "IRT" : self.currency.id
    }
    
    func calculateRialWorth() -> String {
        var finalResult: String = ""
        if self.currency.id != "IRR" {
            let value = self.balance.toDouble * self.currency.irrSellPrice
            finalResult = value.changeToRial.format(f: 2).toDouble.formattedWithSeparator.convertEngNumToPersianNum().addCurrency()
        } else {
            finalResult = self.balance.toDouble.changeToRial.formattedWithSeparator.convertEngNumToPersianNum().addCurrency()
        }
        return finalResult
    }
    
    var titleWithID: String {
        "(\(self.currency.name)) \(self.formattedID)"
    }
    
    var totalWalletBalance: String {
        var totalRialBalance:Double = 0
        var totalDollarBalance: Double = 0
        
        if self.currency.id == "IRR" {
            totalRialBalance += (self.balance.toDouble - self.blockedBalance.toDouble)
            return String(totalRialBalance.changeToRial.formattedWithSeparator.convertEngNumToPersianNum()) + " \(self.currency.name)"
        } else {
            totalDollarBalance += ((self.balance.toDouble - self.blockedBalance.toDouble))
            return String(totalDollarBalance.toString.convertEngNumToPersianNum()) + " \(self.currency.name)"
        }
    }
    
    var totalDollarWalletBalance: String {
        var equal:Double = 0
        if self.currency.id == "IRR" {
            equal += (self.balance.toDouble - self.blockedBalance.toDouble) / self.currency.irrBuyPrice
            return String(equal.formattedWithSeparator.convertEngNumToPersianNum().addDollar)
        } else {
            equal += (self.balance.toDouble - self.blockedBalance.toDouble) * self.currency.usdcPrice
            return String(equal.formattedWithSeparator.convertEngNumToPersianNum().addDollar)
        }
    }
    
    var approximateCurrency: String {
        var approximate:Double = 0
        if self.currency.id == "IRR" {
            approximate += (self.balance.toDouble - self.blockedBalance.toDouble)
            return String(approximate.changeToRial.formattedWithSeparator.convertEngNumToPersianNum()).addCurrency()
        } else {
            approximate += (self.balance.toDouble * self.currency.irrSellPrice)
            return String(approximate.changeToRial.formattedWithSeparator.convertEngNumToPersianNum()).addCurrency()
        }
    }
    
    var inOrderCurrencyBalance: String {
        return "\(self.blockedBalance.toDouble.changeToRial.formattedWithSeparator.convertEngNumToPersianNum())  \(self.currency.name)"
    }
    
    var walletIcon: URL? {
        self.currency.iconPath.stringToURL
    }
    
    var walletName: String {
        return self.currency.name
    }
    
    var walletId: String {
        return self.currency.id
    }
    
    var totalWalletBalanceWithoutNameAndId: String {
        var totalRialBalance:Double = 0
        var totalDollarBalance: Double = 0
        
        if self.currency.id == "IRR" {
            totalRialBalance += (self.balance.toDouble - self.blockedBalance.toDouble)
            return String(totalRialBalance.changeToRial.formattedWithSeparator.convertEngNumToPersianNum())
        } else {
            totalDollarBalance += ((self.balance.toDouble - self.blockedBalance.toDouble))
            return String(totalDollarBalance.toString.convertEngNumToPersianNum())
        }
    }
}

extension Wallet: Equatable {
    static func == (lhs: Wallet, rhs: Wallet) -> Bool {
        lhs.currency.name == rhs.currency.name && lhs.currency.id == rhs.currency.id
    }
}

