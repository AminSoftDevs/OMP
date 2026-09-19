//
//  MarketDelegate.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 8/29/21.
//

import Foundation

protocol MarketDelegate: AnyObject {
    func selectedNavItem(type: MarketsType)
    func changeTabByScrolling(type: MarketsType)
    func selectedTabTag(tag: Int)
}

extension MarketDelegate {
    func selectedNavItem(type: MarketsType) {}
    func changeTabByScrolling(type: MarketsType) {}
    func selectedTabTag(tag: Int) {}
}
