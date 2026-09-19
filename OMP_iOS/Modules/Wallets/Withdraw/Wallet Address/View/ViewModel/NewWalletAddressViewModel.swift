//
//  NewWalletAddressViewModel.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 1/27/22.
//

import Foundation

enum WalletAddressMode {
    case edit
    case new
}

class NewWalletAddressViewModel {
    
    var selectedCurrencyToken: String?
    
    var tokensButtonTitle: String {
        return type == .new ? (tokens.first ?? "") : (walletAddress?.currencyToken ?? "")
    }
    
    var title: String {
        return type == .new ? "NewWalletAddressView.addAddress".localized : "NewWalletAddressView.editAddress".localized
    }
    
    var getName: String {
        return walletAddress?.name ?? ""
    }
    
    var getAddress: String {
        return walletAddress?.wallet ?? (singleAddress)
    }
    
    var tokenList: [String] {
        return tokens
    }
    var getType: WalletAddressMode {
        return type
    }
    
    var getWallet: WalletAddress? {
        return walletAddress
    }
    
    var editWalletAddressWas: ((Bool) -> Void)?
    var addWalletAddressWas: ((Bool) -> Void)?
    
    //MARK: - INITIALIZER
    private let singleAddress: String
    private let walletAddress: WalletAddress?
    private let tokens: [String]
    private let type: WalletAddressMode
    
    init(wallet: WalletAddress?, tokens: [String], singleAddress: String?, type: WalletAddressMode) {
        self.walletAddress = wallet
        self.tokens = tokens
        self.type = type
        self.singleAddress = singleAddress ?? ""
    }
    
    //MARK: - API
    func editWalletAddress(walletAddress: WalletAddress) {
        Preloader.sharedInstance.startLoading()
        EditWalletAddressService.editWalletAddress(request: .init(id: walletAddress.id, wallet: walletAddress.wallet,name: walletAddress.name)){ [weak self] results in
            Preloader.sharedInstance.stopLoading()
            switch results {
            case let .success(responseReceived):
                switch responseReceived {
                case .success(response: _):
                    self?.editWalletAddressWas?(true)
                case let .validation(error: errorModel):
                    var errorMessage = ""
                    
                    if let name  = errorModel.errors.name {
                        errorMessage =  name.createErrorMessage() + "\n"
                    }
                    if let address = errorModel.errors.wallet {
                        errorMessage += address.createErrorMessage() + "\n"
                    }
                    if let id  = errorModel.errors.id {
                        errorMessage =  id.createErrorMessage()
                    }
                    Popup.showError(body: errorMessage)
                    self?.editWalletAddressWas?(false)
                }
            case let .failure(error):
                Popup.showError(body: error.localizedStrings)
                self?.editWalletAddressWas?(false)
            }
        }
    }
    
    func addNewWallet(name: String, address: String, token: String) {
        Preloader.sharedInstance.startLoading()
        AddNewWalletAddressService.addNewWalletAddress(request: .init(wallet: address, name: name, currencyToken: token)) { [weak self] results in
            Preloader.sharedInstance.stopLoading()
            switch results {
            case let .success(responseReceived):
                switch responseReceived {
                case .success(response: _):
                    self?.addWalletAddressWas?(true)
                case let .validation(error: errorModel):
                    var errorMessage = ""
                    if let name  = errorModel.errors.name {
                        errorMessage =  name.createErrorMessage() + "\n"
                    }
                    if let address = errorModel.errors.wallet {
                        errorMessage += address.createErrorMessage() + "\n"
                    }
                    if let token  = errorModel.errors.currencyToken {
                        errorMessage =  token.createErrorMessage()
                    }
                    Popup.showError(body: errorMessage)
                    self?.addWalletAddressWas?(false)
                }
            case let .failure(error):
                self?.addWalletAddressWas?(false)
                Popup.showError(body: error.localizedStrings)
            }
            
        }
    }
}
