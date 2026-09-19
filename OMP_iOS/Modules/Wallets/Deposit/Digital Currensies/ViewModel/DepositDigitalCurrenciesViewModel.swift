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
        return wallet.currency.hasTag ?? false
    }
    
    var walletAddress: String = ""
    var balance: String
    
    weak var delegate: DepositDigitalCurrenciesViewModelProtocol?
    
    //MARK: - INITIALIZER
    let wallet: Wallet
    
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
        DepositDigitalCurrencyWalletAddressService.getDepositAddress(request: .init(coin: wallet.currency.id)) { [weak self] results in
            Preloader.sharedInstance.stopLoading()
            guard let self = self else { return }
            switch results {
            case let .success(responseReceived):
                switch responseReceived {
                case let .success(response: responseModel):
                    self.delegate?.depositWalletAddressReceived(address: responseModel.data.address, memo: responseModel.data.memo ?? "")
                    self.walletAddress = responseModel.data.address
                case .validation(error: _):
                    print("we don't send any parameter to validate")
                }
            case let .failure(error):
                Popup.showError(body: error.localizedStrings)
            }
        }
    }
    
    func refreshDepositWalletBalanceAPI() {
        Preloader.sharedInstance.startLoading()
        RefreshWalletBalanceService.refreshDepositWalletBalance(request: .init(coin: wallet.currency.id)) { [weak self] results in
            Preloader.sharedInstance.stopLoading()
            guard let self = self else { return }
            switch results {
            case let .success(responseReceived):
                switch responseReceived {
                case let .success(response: responseModel):
                    self.delegate?.balanceRefreshed(balance: responseModel.data.balance.toString.formattedBalance)
                case .validation(error: _):
                    print("we don't send any parameter to validate")
                }
            case let .failure(error):
                Popup.showError(body: error.localizedStrings)
            }
        }
    }
}
