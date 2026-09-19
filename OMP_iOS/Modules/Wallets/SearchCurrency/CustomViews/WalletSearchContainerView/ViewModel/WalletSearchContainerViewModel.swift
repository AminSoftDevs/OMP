//
//  SearchWalletViewModel.swift
//  OMP_iOS
//
//  Created by AminSoft on 7/4/1400 AP.
//

import Foundation

class WalletSearchContainerViewModel {
    
    private var wallets: [Wallet]
    private var nonZeroBalanceWallets: [Wallet] = []
    private var filterWallet: [Wallet] = []
    private var isSearching: Bool = false
    
    var reloadView: (() -> ())?
    
//    MARK: - INITIALIZERS
    init(wallets: [Wallet]) {
        self.wallets = wallets
    }
    
    func getWalletFor(index indexPath: IndexPath) -> Wallet {
        if isSearching {
            return filterWallet[indexPath.row]
        } else {
            return wallets[indexPath.row]
        }
    }
    
    func getNumberOfWallets() -> Int {
        if isSearching {
            return filterWallet.count
        } else {
           return wallets.count
        }
    }
    
    func filterData(walletName: String) {
        isSearching = walletName.isEmpty ? false : true
        let filterArray =  wallets.filter({$0.currency.name.contains(walletName) || $0.currency.id.contains(walletName) })
        if filterArray != filterWallet {
            filterWallet = filterArray
            reloadView?()
        }
    }
}
