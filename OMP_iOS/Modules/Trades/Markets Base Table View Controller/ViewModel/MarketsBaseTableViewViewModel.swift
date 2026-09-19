//
//  MarketsBaseTableViewViewModel.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 11/6/21.
//

import UIKit

protocol MarketsTableViewProtocol: AnyObject {
    func tableShouldReloadWithNewData()
    func selectedItemFromMarkets(market: Markets)
}

extension MarketsTableViewProtocol {
    func tableShouldReloadWithNewData() {}
    func selectedItemFromMarkets(market: Markets) {}
}

class MarketsBaseTableViewViewModel {
    
    var markets: [Markets] = []
    
    var numberOfRows: Int {
        return markets.count
    }
    
    weak var delegate: MarketsTableViewProtocol?
    
    //MARK: - FUNCTIONS
    func updateDataSource(items: [Markets]) {
        markets = items
        delegate?.tableShouldReloadWithNewData()
    }
    
    func getItemForRowAtIndex(index: Int) -> Markets {
        return markets[index]
    }
}
