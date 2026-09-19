//
//  WalletBalanceViewModel.swift
//  OMP_iOS
//
//  Created by AminSoft on 7/7/1400 AP.
//

import UIKit

enum CurrencyType {
    case digital
    case rial
    
    func withdrawController(wallet: Wallet) -> UIViewController {
        switch self {
        case .rial:
            return WithdrawRialViewController.makeInstance(wallet: wallet)
        case .digital:
            return WithdrawDigitalCurrencyViewController.makeInstance(wallet: wallet)
        }
    }
    
    func depositController(wallet: Wallet) -> UIViewController {
        switch self {
        case .rial:
            return DepositOnRialWalletViewController.makeInstance(wallet: wallet)
            
        case .digital:
            return DepositDigitalCurrenciesViewController.makeInstance(wallet: wallet)
        }
    }
}

class WalletBalanceViewModel {
    
    var walletName: String {
        wallet.titleWithID // navBarTitle
    }
    
    var totalPropertyCurrency: String {
        wallet.totalWalletBalance
    }
    
    var equalCurrencyBalance: String {
        wallet.totalDollarWalletBalance
    }
    
    var approximateCurrency: String {
        wallet.approximateCurrency
    }
    
    var inOrderCurrencyBalance: String {
        wallet.inOrderCurrencyBalance
    }
    
    var availableCurrencyBalance: String {
        totalPropertyCurrency
    }
    
    var walletIcon: URL? {
        wallet.walletIcon
    }

    let wallet: Wallet
    
    init(wallet: Wallet) {
        self.wallet = wallet
    }
    
    func getController(type transaction: TransactionType) -> UIViewController {
        let type: CurrencyType = wallet.currency.id == "IRR" ? .rial : .digital
        
        switch transaction {
        case .deposit:
            return type.depositController(wallet: wallet)
            
        case .withdraw:
            return type.withdrawController(wallet: wallet)

        default:
            return UIViewController()
        }
    }
}

