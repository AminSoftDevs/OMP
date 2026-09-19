//
//  NewWalletViewModel.swift
//  OMP_iOS
//

//  Created by soroush amini araste on 9/26/21.
//

import Foundation

class NewWalletViewModel {
    
    var totalPropertyRial: String = ""
    var totalPropertyDollar: String = ""
    var totalPropertyIcon: String = ""
    
    var wallets: [Wallet] = []
    
    var shouldHideZeroBalance: Bool = false {
        didSet {
            self.prepareWalletList(with: wallets)
        }
    }
    
    var userWalletsReceived: (([Wallet]) -> Void)?
    var userWalletHeaderDataReceived: (() -> Void)?
    
    func getTotalBalances(){
        var totalRial: Double = 0
        var totalDollar: Double = 0
        
        for item in wallets {
            if item.currency.id == "IRR" {
                totalRial += (item.balance.toDouble - item.blockedBalance.toDouble)
                totalDollar += ((item.balance.toDouble - item.blockedBalance.toDouble) / item.currency.irrSellPrice)
                totalPropertyIcon = item.currency.iconPath
            } else {
                totalRial += ((item.balance.toDouble - item.blockedBalance.toDouble) * item.currency.irrSellPrice)
                totalDollar += ((item.balance.toDouble - item.blockedBalance.toDouble) * item.currency.usdcPrice)
            }
        }
        self.totalPropertyRial = Double(totalRial.changeToRial.format(f: 2))?.formattedWithSeparator.convertEngNumToPersianNum().addCurrency() ?? ""
        self.totalPropertyDollar = Double(totalDollar.format(f: 2))?.formattedWithSeparator.convertEngNumToPersianNum().addDollar ?? ""
        self.userWalletHeaderDataReceived?()
    }
    
    func prepareWalletList(with wallets: [Wallet]) {
        if shouldHideZeroBalance {
            self.userWalletsReceived?(wallets.filter({ $0.balance.toDouble != 0 }))
        } else  {
            self.userWalletsReceived?(wallets)
        }
    }
    
    //MARK: - Get data from server
    func getUserWalletListAPI() {
        Preloader.sharedInstance.startLoading()
        UserWalletService.getUserWallets { [weak self] results in
            Preloader.sharedInstance.stopLoading()
            guard let self = self else { return }
            switch results {
            case let .success(responseReceived):
                switch responseReceived {
                case let .success(response: responseModel):
                    self.wallets = responseModel.data
                    self.getTotalBalances()
                    self.prepareWalletList(with: responseModel.data)
                default:
                    print("will be empty")
                }
            case let .failure(error):
                Popup.showError(body: error.localizedStrings)
            }
        }
    }
}
