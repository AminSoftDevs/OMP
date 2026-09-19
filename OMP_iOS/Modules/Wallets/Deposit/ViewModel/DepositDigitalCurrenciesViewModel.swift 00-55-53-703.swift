//
//  DepositViewModel.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 9/30/21.
//

import Foundation

protocol DepositDigitalCurrenciesViewModelProtocol: AnyObject {
    func balanceRefreshed(balance: String)
    func depositWalletAddressReceived(address: String, memo: String)
}

class DepositDigitalCurrenciesViewModel {
    
    var navTitle: String {
        return "deposit".localized + " \(wallet.currency.name)"
    }
    
    var walletHasTag: Bool {
        return wallet.currency.hasTag
    }
    
    var walletAddress: String = ""
    var balance: String
    
    weak var delegate: DepositDigitalCurrenciesViewModelProtocol?
    
    //MARK: - INITIALIZER
    private let wallet: Wallet
    
    init(wallet: Wallet) {
        self.wallet = wallet
        self.balance = wallet.balance.formattedBalance
    }
    
    func refreshBalanceButtonPressed() {
        refreshDepositWalletBalanceAPI()
    }
    
    //MARK: - API
    func getDepositWalletAddressAPI() {
        Preloader.sharedInstance.startLoading()
        WalletEndPoint.getDepositAddress(id: wallet.currency.id) { [weak self] results in
            Preloader.sharedInstance.stopLoading()
            switch results {
            case .success(let response):
                self?.delegate?.depositWalletAddressReceived(address: response.data.address, memo: response.data.memo ?? "")
                self?.walletAddress = response.data.address
            case .failure(let error):
                Popup.showError(body: error.localizedStrings)
            }
        }
    }
    
    func refreshDepositWalletBalanceAPI() {
        WalletEndPoint.refreshDepositWalletBalance(id: wallet.currency.id) { [weak self] results in
            switch results {
            case .success(let response):
                self?.delegate?.balanceRefreshed(balance: response.data.balance.toString.formattedBalance)
            case .failure(let error):
                Popup.showError(body: error.localizedStrings)
            }
        }
    }
}
