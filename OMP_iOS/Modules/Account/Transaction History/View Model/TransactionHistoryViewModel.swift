//
//  TransactionHistoryViewModel.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 12/12/21.
//

import UIKit

protocol TransactionHistoryProtocol: AnyObject {
    func responseReceived()
}

class TransactionHistoryViewModel {
    
    private var transactions: [Transaction] = []
    
    let cellHeight: CGFloat = 120
    
    var numberOfItems: Int {
        return transactions.count
    }
    
    var navigationTitle: String {
        return "TransactionHistoryViewController.navTitle".localized
    }
    
    weak var delegate: TransactionHistoryProtocol?
    
    //MARK: - FUNCTIONS
    func getItemForRowAt(indexPath: IndexPath) -> Transaction {
        return transactions[indexPath.row]
    }
    
    //MARK: - API
    func getTransactionHistory() {
        Preloader.sharedInstance.startLoading()
        TransactionHistoryService.getTransactionsHistory { [weak self] results in
            Preloader.sharedInstance.stopLoading()
            guard let self = self else { return }
            switch results {
            case let .success(responseReceived):
                switch responseReceived {
                case let .success(response: items):
                    self.transactions = items.data
                    self.delegate?.responseReceived()
                case let .validation(error: errorModel):
                    print(errorModel.status)
                }
            case let .failure(error):
                self.delegate?.responseReceived()
                Popup.showError(body: error.localizedStrings)
            }
        }
    }
}
