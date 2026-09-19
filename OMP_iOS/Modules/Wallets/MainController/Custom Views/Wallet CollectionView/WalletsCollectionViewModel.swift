//
//  WalletsCollectionViewModel.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 9/29/21.
//

import Foundation

class WalletsCollectionViewModel {
    
    private var wallets: [Wallet] = []
    
    var updateNeeded: (() -> Void)?
    
    func getNumberOfItems() -> Int {
        return wallets.count
    }
    
    func getWalletWithIndex(_ index: Int) -> Wallet {
        return wallets[index]
    }
    
    func fillWallets(wallets: [Wallet]) {
        self.wallets = wallets
        self.updateNeeded?()
    }
}
