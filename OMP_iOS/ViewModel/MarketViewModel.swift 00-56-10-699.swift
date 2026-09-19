//
//  MarketViewModel.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 8/29/21.
//

import UIKit

class MarketViewModel {
    
    let id: Int
    let symbols: String
    let dailyChangePercent: String
    let lastPrice: String
    let lastVolume: String
    var liked: Bool
    let color: UIColor
    var iconName: String
    let type: OldMarketType
    var market: Market
    
    init(market: Market) {
        self.id = market.id
        self.symbols = "\(market.baseCurrency.id) / \(market.quoteCurrency.id)"
        self.lastPrice = String(market.lastPrice!.changeToRial.formattedWithSeparator).convertEngNumToPersianNum()
        self.liked = market.liked!
        self.dailyChangePercent = "% \(market.dayChangePercent!)".replacingOccurrences(of: "-", with: "").convertEngNumToPersianNum()
        self.market = market
        
        if market.quoteCurrency.id == "IRR" {
            self.type = .mainMarket
            self.lastVolume = String(Int(market.lastVolume!.changeToRial).formattedWithSeparator).convertEngNumToPersianNum()
        } else {
            self.type = .proMarket
            self.lastVolume = String(market.lastVolume!.formattedWithSeparator).convertEngNumToPersianNum()
        }
        if market.dayChangePercent! > 0 {
            self.color = .submitGreen
        } else {
            self.color = .rejectOrange
        }
        
        if market.liked! {
            self.iconName = "star_fill_icon"
        } else {
            self.iconName = "star_empty_icon"
        }
    }
}
