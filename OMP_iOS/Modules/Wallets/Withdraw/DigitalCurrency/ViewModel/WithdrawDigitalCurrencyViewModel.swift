//
//  WithdrawDigitalCurrencyViewModel.swift
//  OMP_iOS
//
//  Created by AminSoft on 7/19/1400 AP.
//

import Foundation

class WithdrawDigitalCurrencyViewModel {
    
    let wallet: Wallet
    
    var withdrawItem:  DigitalWithdrawService.Response?
    
    private var currencyId: String {
        wallet.walletId
    }
    
    var withdrawalAmount: Double?
    
    var destinationCurrencyWalletAddress: String?
    
    var walletBalance: String {
        "\(wallet.walletId)" + "  \(wallet.totalWalletBalanceWithoutNameAndId)"
    }
    
    var minimumWithdrawValue: String {
        return "\(wallet.currency.minimumWithdrawAmount.toString)" + "  \(wallet.walletId)"
    }
    
    var transferFee: String {
        return "\(wallet.currency.withdrawFee)" + "  \(wallet.walletId)"
    }
    
    var tagOrMemo: Bool? {
        wallet.currency.hasTag 
    }
    
    var tagValue: String?
    
    var walletName: String {
        wallet.walletName
    }
    
    init(wallet: Wallet) {
        self.wallet = wallet
    }
    
    func performWithdrawableDigitalCurrency(completion: @escaping (Bool) -> Void) {
        
        guard let amount = withdrawalAmount else {
            Popup.showError(body: "Withdraw.pleaseFillWithdrawValue".localized)
            completion(false)
            return
        }
        
        guard let walletAddress = destinationCurrencyWalletAddress else {
            Popup.showError(body: "Withdraw.pleaseFillAddressWallet".localized)
            completion(false)
            return
        }
        
        Preloader.sharedInstance.startLoading()
        
        DigitalWithdrawService.digitalWithdrawRequest(currencyID: currencyId,request: .init(amount: amount, wallet: walletAddress, tag: tagValue)) { results in
            
            Preloader.sharedInstance.stopLoading()

            switch results {
            case let .success(responseReceived):
                switch responseReceived {
                case let .success(response: responseModel):
                    self.withdrawItem = responseModel
                    completion(true)
                case let .validation(error: errorModel):
                    var errorMessage = ""
                    if let wallet  = errorModel.errors.wallet {
                        errorMessage =  wallet.createErrorMessage() + "\n"
                    }
                    
                    if let amountError = errorModel.errors.amount {
                        errorMessage += amountError.createErrorMessage()
                    }
                    
                    if let tag = errorModel.errors.tag {
                        errorMessage += "\n" + tag.createErrorMessage()
                    }
                    
                    Popup.showError(body: errorMessage)
                }
            case let .failure(error):
                completion(false)
                Popup.showError(body: error.localizedStrings)
            }
        }
    }
}
