//
//  SearchCurrencyViewModel.swift
//  OMP_iOS
//
//  Created by Moein Barzegaran on 10/11/21.
//

import UIKit

class SearchCurrencyViewModel {
    
    let wallets: [Wallet]
    
    private var transactionType: TransactionType
    
    var titleString: String {
        transactionType.stringFromType()
    }
    
    init(wallets: [Wallet], transactionType: TransactionType) {
        self.wallets = wallets
        self.transactionType = transactionType
    }
    
    
    func handleSelection(item wallet: Wallet) -> UIViewController {
        let type: CurrencyType = wallet.currency.id == "IRR" ? .rial : .digital
        
        
        switch transactionType {
        case .deposit:
            return type.depositController(wallet: wallet)
            
        case .withdraw:
            return type.withdrawController(wallet: wallet)

        default:
            return UIViewController()
        }
    }
}
