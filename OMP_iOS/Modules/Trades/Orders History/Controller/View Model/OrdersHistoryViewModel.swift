//
//  OrdersHistoryViewModel.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 11/4/21.
//

import Foundation

protocol OrdersHistoryViewModelProtocol: OrdersTableViewProtocol {
    func newItemsReceived()
}

class OrdersHistoryViewModel {
    
    
    var orders: [Orders] = [] {
        didSet {
            delegate?.newItemsReceived()
        }
    }
    
    var numberOfItems: Int {
        return orders.count
    }
    
    weak var delegate: OrdersHistoryViewModelProtocol?
    
    //MARK: - FUNCTIONS
    func requestForData() {
        getOrdersHistory()
    }
    
    //MARK: - API
    func getOrdersHistory() {
        Preloader.sharedInstance.startLoading()
        OrdersHistoryService.getOrdersHistory(request: .init()) { [weak self] results in
            Preloader.sharedInstance.stopLoading()
            guard let self = self else { return }
            switch results {
            case let .success(responseReceived):
                switch responseReceived {
                case let .success(response: items):
                    self.orders = items.data
                case let .validation(error: errorModel):
                    print(errorModel.status)
                }
            case let .failure(error):
                Popup.showError(body: error.localizedStrings)
            }
        }
    }
}
