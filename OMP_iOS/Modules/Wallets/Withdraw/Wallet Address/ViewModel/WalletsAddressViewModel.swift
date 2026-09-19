//
//  WalletsAddressViewModel.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 1/25/22.
//

import Foundation

enum WalletAddressListType {
    case full
    case brief
}

class WalletsAddressViewModel {
    
    var walletsList: [WalletAddress] = []
    
    var walletAddressListReceived: (() -> Void)?
    var deletedItemAt: ((Int) -> Void)?
    
    var getTokens: [String] {
        return tokens
    }
    
    var getScreenType: WalletAddressListType {
        return screenType
    }
    //MARK: - INITIALIZER
    private let tokens: [String]
    private let screenType: WalletAddressListType
    
    init(type: WalletAddressListType, tokens: [String]) {
        self.tokens = tokens
        self.screenType = type
    }
    
    //MARK: - FUNCTIONS
    func numberOfItems() -> Int {
        return walletsList.count
    }
    
    func dataForRowAt(indexPath: IndexPath) -> WalletAddress {
        return walletsList[indexPath.row]
    }
    
    private func deleteAddressHandler(id: Int) {
        if let index = walletsList.firstIndex(where: {$0.id == id}) {
            walletsList.remove(at: index)
            deletedItemAt?(index)
        }
    }
    
    //MARK: - API
    func getWalletAddressList() {
        WalletsAddressListService.getWalletsAddressList { [weak self] results in
            Preloader.sharedInstance.stopLoading()
            guard let self = self else { return }
            switch results {
            case let .success(responseReceived):
                switch responseReceived {
                case let .success(response: responseModel):
                    self.walletsList = responseModel.data
                    self.walletAddressListReceived?()
                case let .validation(error: errorModel):
                    print(errorModel.status)
                }
            case let .failure(error):
                Popup.showError(body: error.localizedStrings)
            }
        }
    }
    
    func deleteWalletAddress(id: Int) {
        Preloader.sharedInstance.startLoading()
        DeleteWalletAddressService.deleteWalletAddress(request: .init(id: "\(id)")) { [weak self] results in
            Preloader.sharedInstance.stopLoading()
            guard let self = self else { return }
            switch results {
            case let .success(responseReceived):
                switch responseReceived {
                case .success(_):
                    self.deleteAddressHandler(id: id)
                case let .validation(error: errorModel):
                    if let idError  = errorModel.errors.id {
                        Popup.showError(body: idError.createErrorMessage())
                    }
                }
            case let .failure(error):
                Popup.showError(body: error.localizedStrings)
            }
        }
    }
}
