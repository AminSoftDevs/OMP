//
//  Market.swift
//  OMP_iOS
//
//  Created by AminSoft on 8/18/1400 AP.
//

import UIKit

// MARK: - Market
struct Market: Codable {
    let id: Int
    let baseCurrency, quoteCurrency: MarketCurrency
    let name: String
    let quoteCurrencyPrecision, baseCurrencyPrecision: Int
    let minPrice, maxPrice, lastPrice, lastVolume: String
    let dayChangePercent: Double
    let tradingViewSymbol: String
    var likedByUser: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case baseCurrency = "base_currency"
        case quoteCurrency = "quote_currency"
        case name
        case quoteCurrencyPrecision = "quote_currency_precision"
        case baseCurrencyPrecision = "base_currency_precision"
        case minPrice = "min_price"
        case maxPrice = "max_price"
        case lastPrice = "last_price"
        case lastVolume = "last_volume"
        case dayChangePercent = "day_change_percent"
        case tradingViewSymbol = "tradingview_symbol"
        case likedByUser = "liked_by_user"
    }
}

// MARK: - Market Currency
struct MarketCurrency: Codable {
    let id: String
    var iconPath: String
    let name: String
    let decimalPrecision: Int

    enum CodingKeys: String, CodingKey {
        case id
        case iconPath = "icon_path"
        case name
        case decimalPrecision = "decimal_precision"
    }
}

extension Market {
    
    var marketID: Int {
        return self.id
    }
    
    var mainMarketSymbol: String {
        return self.quoteCurrency.id == "IRR" ? "\(self.baseCurrency.id) / IRT" : "\(self.baseCurrency.id) / \(self.quoteCurrency.id)"
    }
    
    var marketLastPrice: String {
        return self.lastPrice.toDouble.changeToRial.formattedWithSeparator
    }
    
    var marketLastVolume: String {
        self.lastVolume.toDouble.changeToRial.formattedWithSeparator.convertEngNumToPersianNum()
    }

    var marketDailyChangePercent: String {
        if self.dayChangePercent > 0 {
            return self.dayChangePercent.toString.addPercent().replacingOccurrences(of: "-", with: " ").convertEngNumToPersianNum()
        } else {
            return "- " + "\(self.dayChangePercent.toString.replacingOccurrences(of: "-", with: "") )".addPercent().convertEngNumToPersianNum()
        }
    }
    
    var marketIsLiked: Bool {
        return self.likedByUser
    }
    
    var marketDailyChangePercentColor: UIColor {
        if self.dayChangePercent > 0 {
            return .submitGreenColor
        } else {
            return .rejectOrangeColor
        }
    }
    
    var icon: String {
        if self.likedByUser {
            return "star_fill_icon"
        } else {
            return "star_empty_icon"
        }
    }
    
    var lastValueMarket: String {
        self.lastPrice.toDouble.formattedWithSeparator.convertEngNumToPersianNum()
    }

}
