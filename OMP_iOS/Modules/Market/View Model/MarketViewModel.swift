//
//  MarketViewModel.swift
//  OMP_iOS
//
//  Created by AminSoft on 8/24/1400 AP.
//

import Foundation

protocol MarketViewModelProtocol: AnyObject {
    func shouldReloadCollectionView()
    func likeButtonAction(with item: Market)
}

extension MarketViewModelProtocol {
    func shouldReloadCollectionView() {}
}

class MarketViewModel {
    
    var firstReload: Bool = true
    
    var timer: Timer = Timer()
    
    var markets: [Market] = [] {
        didSet {
            prepareMarkets(markets: markets)
        }
    }
    
    var dataSource: [Int: [Market]] = [:] {
        didSet {
            delegate?.shouldReloadCollectionView()
        }
    }
    
    var numberOfItems: Int {
        return dataSource.count
    }
    
    var marketNavBarItems: [MarketPage] = MarketPage.allCases
    
    weak var delegate: MarketViewModelProtocol?
    
    //MARK: - FUNCTIONS
    func prepareMarkets(markets: [Market]) {
        var mainMarket: [Market] = []
        var favoriteMarket: [Market] = []
        var professionalMarket: [Market] = []
        mainMarket = markets.filter({$0.quoteCurrency.id == "IRR"})
        professionalMarket = markets.filter({$0.quoteCurrency.id != "IRR"})
        favoriteMarket = markets.filter({$0.likedByUser})
        dataSource = [0: favoriteMarket, 1: mainMarket, 2: professionalMarket]
    }
    
    func getMarketsForIndexPath(for index: IndexPath) -> [Market] {
        return dataSource[index.row] ?? []
    }
    
    func handlingLikeAction(market: Market) {
        var oldMarkets: [Market] = self.markets
        var newMarket = market
        newMarket.likedByUser = !newMarket.likedByUser
        if let index = markets.firstIndex(where: { $0.marketID == newMarket.marketID}) {
            oldMarkets.remove(at: index)
            oldMarkets.insert(newMarket, at: index)
            self.markets = oldMarkets
        }
    }
    
    //MARK: - Fetch Data
    func getMarket() {
        MarketService.getMarket { [weak self] results in
            Preloader.sharedInstance.stopLoading()
            guard let self = self else { return }
            switch results {
            case let .success(responseReceived):
                switch responseReceived {
                case let .success(response: response):
                    self.markets = response.data
                case let .validation(error: errorModel):
                    print(errorModel.status)
                    
                }
            case let .failure(error):
                Popup.showError(body: error.localizedStrings)
                
            }
        }
    }
    
    func addOrRemoveMarketLiked(market: Market) {
        FavoriteMarketService.favoriteMarketRequest(currencyID: market.marketID) { [weak self] results in
            guard let self = self else { return }
            switch results {
            case .success(response: _ ):
                self.handlingLikeAction(market: market)
            case let .failure(error):
                Popup.showError(body: error.localizedStrings)
            }
        }
    }
    //MARK: - Update Markets With Timer
    func updateMarketsForTimers() {
        timer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(updateMarketsWithTimer), userInfo: nil, repeats: true)
    }
    
    @objc private func updateMarketsWithTimer() {
        getMarket()
    }
    
    func invalidTimer() {
        timer.invalidate()
    }
}
