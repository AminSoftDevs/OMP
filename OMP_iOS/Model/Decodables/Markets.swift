//
//  Markets.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 11/6/21.
//

import UIKit

// MARK: - Markets
struct Markets: Codable, Hashable {
    let id: Int
    let baseCurrency, quoteCurrency: MarketsCurrency
    let name: String
    let minPrice, maxPrice, lastPrice, lastVolume: String
    let dayChangePercent: Double
    let tradingViewSymbol: String
    let likedByUser: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case baseCurrency = "base_currency"
        case quoteCurrency = "quote_currency"
        case name
        case minPrice = "min_price"
        case maxPrice = "max_price"
        case lastPrice = "last_price"
        case lastVolume = "last_volume"
        case dayChangePercent = "day_change_percent"
        case tradingViewSymbol = "tradingview_symbol"
        case likedByUser = "liked_by_user"
    }
}

// MARK: - ECurrency
struct MarketsCurrency: Codable, Hashable {
    let id: String
    let iconPath: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case id
        case iconPath = "icon_path"
        case name
    }
}

extension Markets {
    var formattedSymbolForGraph: String {
        return self.baseCurrency.id + " / " + self.quoteCurrency.id
    }
    
    var formattedSymbol: String {
        return self.quoteCurrency.id == "IRR" ? self.baseCurrency.id + " / " + "IRT" : self.baseCurrency.id + " / " + self.quoteCurrency.id
    }
    
    var color: UIColor {
        return self.dayChangePercent > 0 ? .submitGreenColor : .rejectOrangeColor
    }
    
    var formattedPercent: String {
        return "% \(self.dayChangePercent)".convertEngNumToPersianNum()
    }
    
    var formattedLastPrice: String {
        if self.quoteCurrency.id == "IRR" {
            return self.lastPrice.toDouble.changeToRial.formattedWithSeparator.convertEngNumToPersianNum()
        } else {
            if self.lastPrice.toDouble > 10 {
                return self.lastPrice.toDouble.formattedWithSeparator.convertEngNumToPersianNum()
            } else {
                return self.lastPrice.convertEngNumToPersianNum()
            }
        }
    }
    
    var amountPrecision: Int {
        if let index = self.lastPrice.range(of: ".")?.lowerBound {
            let substring = self.lastPrice.prefix(upTo: index)
            //video said we should subtract 3 digit but he was talking about toman
            return String(substring).count - 4
        } else {
            return self.lastPrice.count - 4
        }
    }
    
    var unitPricePrecision: Int {
        if self.lastPrice.toDouble < 100000 {
            return 0
        }
        if let index = self.lastPrice.range(of: ".")?.lowerBound {
            let substring = self.lastPrice.prefix(upTo: index)
            //video said we should subtract 4 digit but he was talking about toman
            return String(substring).count - 5
        } else {
            return self.lastPrice.count - 5
        }
    }
}
