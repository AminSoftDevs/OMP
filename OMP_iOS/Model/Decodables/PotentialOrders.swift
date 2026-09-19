//
//  PotentialOrders.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 11/10/21.
//

import UIKit

// MARK: - Datum
struct PotentialOrders: Codable {
    let amount: String
    let price: Double
    let type: OrdersType
    let myOrder: Bool
    
    enum CodingKeys: String, CodingKey {
        case amount, price, type
        case myOrder = "my_order"
    }
}

extension PotentialOrders {
    var color: UIColor {
        return self.type == .sell ? .rejectOrangeColor : .submitGreenColor
    }
    
    var highlightColor: UIColor {
        return self.type == .sell ? .tradeRowsHighlightForSellColor : .tradeRowsHighlightForBuyColor
    }
    
    var formattedAmount: String {
        if self.amount.toDouble >= 1 {
            return self.amount.toDouble.format(f: self.baseCurrencyPrecision).convertEngNumToPersianNum()
        } else {
            return self.amount.toDouble.format(f: self.baseCurrencyPrecision).convertEngNumToPersianNum()
        }
    }
    
    var baseCurrencyPrecision: Int {
        let digitsCount = String(self.price).removeZeroFromEnd.count
        let precision = (digitsCount - 4)
        if precision >= 0 {
            return precision
        } else {
            return 1
        }
    }
    
    var quoteCurrencyPrecision: Int {
        let digitsCount = String(self.price).removeZeroFromEnd.count
        let precision = (digitsCount - 6)
        if precision >= 0 {
            return precision
        } else {
            return 1
        }
    }
    
    func formattedPrice(selectedMarket: Markets?) -> String {
        if let selectedMarket = selectedMarket {
            if selectedMarket.quoteCurrency.id != "IRR" {
                if selectedMarket.baseCurrency.id == "SHIB" {
                    return self.price.format(f: 8).convertEngNumToPersianNum()
                }
                return self.price.format(f: 5).toDouble.formattedWithSeparator.convertEngNumToPersianNum()
            } else {
                if selectedMarket.baseCurrency.id == "SHIB" {
                    return self.price.changeToToman.format(f: 4).convertEngNumToPersianNum()
                }
                return self.price.changeToRial.format(f: self.quoteCurrencyPrecision).toDouble.formattedWithSeparator.convertEngNumToPersianNum()
            }
        }
        return self.price.changeToRial.format(f: self.quoteCurrencyPrecision).toDouble.formattedWithSeparator.convertEngNumToPersianNum()
    }
}
