//
//  WithdrawHistoryViewModel.swift
//  OMP_iOS
//
//  Created by AminSoft on 7/20/1400 AP.
//

import Foundation

protocol WithdrawHistoryViewModelProtocol: AnyObject {
    func withdrawHistoryItemsReceived()
}
class WithdrawHistoryViewModel {
    
    private let wallet: Wallet
    
    var depositHistoryItems: [WithdrawHistory] = [] {
        didSet {
            delegate?.withdrawHistoryItemsReceived()
        }
    }
    
    var numberOfItems: Int {
        return depositHistoryItems.count
    }
    
    var transferFee: String {
        return self.wallet.currency.withdrawFee.toString
    }
    
    
    weak var delegate: WithdrawHistoryViewModelProtocol?
    
    //MARK: - INITIALIZER
    
    
    init(wallet: Wallet) {
        self.wallet = wallet
    }
    
    //MARK: - FUNCTIONS
    func screenTitle() -> String {
        let type: CurrencyType = wallet.currency.id == "IRR" ? .rial : .digital
        let title = "WithdrawHistory.titleNavigation".localized + " "
        return type == .rial ? title + "asRial".localized : title + wallet.currency.name
    }
    
    func filterHistoryItems(items: [WithdrawHistory]) {
        depositHistoryItems = items.filter { $0.currency.id == wallet.currency.id}
    }
    
    func getItemForIndexPath(_ index: Int) -> WithdrawHistory {
        return depositHistoryItems[index]
    }
    
    
    //MARK: - API
    func getDepositHistoryAPI() {
        Preloader.sharedInstance.startLoading()
        WithdrawHistoryService.getWithdrawHistory { [weak self] results in
            Preloader.sharedInstance.stopLoading()
            guard let self = self else { return }
            switch results {
            case let .success(responseReceived):
                switch responseReceived {
                case let .success(response: responseModel):
                    self.filterHistoryItems(items: responseModel.data)
                case let .validation(error: errorModel):
                    print(errorModel.status)
                }
            case let .failure(error):
                Popup.showError(body: error.localizedStrings)
            }
        }
    }
}
