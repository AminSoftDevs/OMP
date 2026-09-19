//
//  NewMarketGraphViewModel.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 11/8/21.
//

import Foundation
import UIKit

class MarketGraphViewModel {
    
    private var marketStatus: String {
        return UserDefaults.standard.selectedMarket == .real ? "REAL" : "DEMO"
    }
    
    private var dataSource: [MarketGraph] = []
    
    var currentTab: MarketsType = .ompMarket
    
    var navigationTitle: String {
        return marketName.replacingOccurrences(of: "IRR", with: "IRT")
    }
    
    var numberOfMarkets: Int {
        return dataSource.count
    }
    
    var currentPage: IndexPath {
        if let index = dataSource.firstIndex(where: {$0.type == currentTab}) {
            return IndexPath(item: index, section: 0)
        } else {
            return IndexPath(item: 0, section: 0)
        }
    }
    
    //let selectedTheme = UserDefaults.standard.selectedTheme
    let selectedTheme = "dark"
    
    //MARK: - INITIALIZER
    
    private let marketSymbol: String
    private let marketName: String
    
    init(symbol: String, name: String) {
        self.marketSymbol = symbol
        self.marketName = name
        dataSource = [
            MarketGraph(type: .ompMarket, url: "https://www.ompfinex.com/trading-view.html?symbol=\(name.removeForwardSlash)&market=\(marketStatus)"),
            MarketGraph(type: .worldMarket, url: "https://s.tradingview.com/widgetembed/?frameElementId=tradingview_d3277&symbol=\(symbol)&interval=D&hidesidetoolbar=0&symboledit=1&saveimage=1&toolbarbg=f1f3f6&studies=%5B%5D&theme=\(selectedTheme)&style=1&timezone=Asia%2FTehran&withdateranges=1&studies_overrides=%7B%7D&overrides=%7B%22paneProperties.topMargin%22%3A15%7D&enabled_features=%5B%22header_fullscreen_button%22%5D&disabled_features=%5B%22volume_force_overculay%22%5D&locale=fa_IR&utm_source=wallex.ir&utm_medium=widget&utm_campaign=chart&utm_term=KRAKEN%3AUSDTUSD")
        ]
    }
    
    func getItemForRowAt(index: Int) -> MarketGraph {
        return dataSource[index]
    }
    
    func backgroundSyncWithTheme() -> UIColor {
        return .backgroundColor
    }
}

struct MarketGraph {
    let type: MarketsType
    let url: String
}

extension String {
    var removeForwardSlash: String {
        return self.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: " ", with: "")
    }
}
