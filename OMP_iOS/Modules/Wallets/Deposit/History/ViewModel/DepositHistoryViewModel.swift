//
//  DepositHistoryViewModel.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 10/11/21.
//

import UIKit

protocol DepositHistoryViewModelProtocol: AnyObject {
    func depositHistoryItemsReceived()
}

class DepositHistoryViewModel {
    
    var depositHistoryItems: [DepositHistory] = [] {
        didSet {
            delegate?.depositHistoryItemsReceived()
        }
    }
    
    var numberOfItems: Int {
        return depositHistoryItems.count
    }
    
    weak var delegate: DepositHistoryViewModelProtocol?
    
    //MARK: - INITIALIZER
    private let wallet: Wallet
    
    init(wallet: Wallet) {
        self.wallet = wallet
    }
    
    //MARK: - FUNCTIONS
    func screenTitle() -> String {
        let type: CurrencyType = wallet.currency.id == "IRR" ? .rial : .digital
        let title = "history".localized + " " + "deposit".localized + " "
        return type == .rial ? title + "asRial".localized : title + wallet.currency.name
    }
    
    func filterHistoryItems(items: [DepositHistory]) {
        depositHistoryItems = items.filter { $0.currency.id == wallet.currency.id}
    }
    
    func getItemForIndexPath(_ index: Int) -> DepositHistory {
        return depositHistoryItems[index]
    }
    
    //MARK: - API
    func getDepositHistoryAPI() {
        Preloader.sharedInstance.startLoading()
        DepositHistoryService.getDepositHistory { [weak self] results in
            Preloader.sharedInstance.stopLoading()
            guard let self = self else { return }
            switch results {
            case let .success(responseReceived):
                switch responseReceived {
                case let .success(response: items):
                    self.filterHistoryItems(items: items.data)
                case let .validation(error: errorModel):
                    print(errorModel.status)
                }
            case let .failure(error):
                Popup.showError(body: error.localizedStrings)
            }
        }
    }
}
