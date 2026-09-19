//
//  NewTradesControllerViewModel.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 11/9/21.
//

import UIKit

protocol NewTradesControllerViewModelProtocol: AnyObject {
    func newDataReceived()
    func responseFromTappingOnOpenOrder(market: Markets)
}

class TradesControllerViewModel {
    
    var currentRequestInProgress: Bool = false
    var selectedMarket: Markets?
    
    var navBarHeight: CGFloat {
        return 120
    }
    
    var selectedMarketName: String {
        guard let market = selectedMarket else { return "BTC / IRR"}
        return market.formattedSymbolForGraph
    }
    
    var selectedMarketSymbol: String {
        guard let market = selectedMarket else { return DefaultCoin.symbol}
        return market.tradingViewSymbol
    }
    
    
    var timer = Timer()
    
    var orders: [Orders] = [] {
        didSet {
            delegate?.newDataReceived()
        }
    }
    
    var numberOfItems: Int {
        return orders.count
    }
    
    weak var delegate: NewTradesControllerViewModelProtocol?
    
    //MARK: - FUNCTIONS
//    func fetchNewDataFromServer() {
//        if page > 0 {
//            page += 1
//            getOpenOrders()
//        }
//    }
    
    func startTimerToRefreshData() {
        if !timer.isValid {
            timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(updateByTimer), userInfo: nil, repeats: true)
        }
    }
    
    func filterMarkets(selectedOpenOrder: Orders, markets: [Markets]) {
        if let index = markets.firstIndex(where: {$0.id == selectedOpenOrder.market.id}) {
            delegate?.responseFromTappingOnOpenOrder(market: markets[index])
        }
    }
    
    //MARK: - OBJC FUNCTIONS
    @objc func updateByTimer() {
        if currentRequestInProgress == false {
            getOpenOrders()
        }
    }
    
    func itemForRow(at indexPath: IndexPath) -> Orders {
        return orders[indexPath.row]
    }
    
    func getOpenOrders() {
        if UserDefaults.standard.isLogin == false {
            return
        }
        currentRequestInProgress = true
        OpenOrdersService.getOpenOrders(request: .init(status: .pending)) { [weak self] results in
            guard let self = self else { return }
            self.currentRequestInProgress = false
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
    
    func cancelPendingOrder(id: Int) {
        DeleteOrderService.deleteOrderService(request: .init(id: id)) { [weak self] results in
            guard let self = self else { return }
            self.updateByTimer()
            switch results {
            case let .success(responseReceived):
                switch responseReceived {
                case let .success(response: status):
                    print(status.message ?? "")
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
    
    func getMarketsListAPI(selectedOpenOrder: Orders) {
        Preloader.sharedInstance.startLoading()
        MarketsListService.getMarketsList { [weak self] results in
            Preloader.sharedInstance.stopLoading()
            guard let self = self else { return }
            switch results {
            case let .success(receivedResponse):
                switch receivedResponse {
                case let .success(response: responseModel):
                    self.filterMarkets(selectedOpenOrder: selectedOpenOrder,markets: responseModel.data)
                case let .validation(error: errorModel):
                    print(errorModel.status)
                }
            case let .failure(error):
                Popup.showError(body: error.localizedStrings)
            }
        }
    }
}
