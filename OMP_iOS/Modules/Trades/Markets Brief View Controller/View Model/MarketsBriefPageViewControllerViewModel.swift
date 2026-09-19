//
//  MarketsBriefPageViewControllerViewModel.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 11/6/21.
//

import UIKit

protocol MarketsBriefPageViewControllerViewModelProtocol: MainMarketsViewControllerProtocol {
    func indexOfShowingController(index: Int)
}

class MarketsBriefPageViewControllerViewModel {
    
    let firstViewController = MainMarketsViewController.makeInstance()
    let secondViewController = ProfessionalMarketsViewController.makeInstance()
    
    var numberOfPages: Int {
        return pages.count
    }
    
    var currentlyShowingPageIndex: Int = 0 {
        didSet {
            delegate?.indexOfShowingController(index: currentlyShowingPageIndex)
        }
    }
    
    private let pages: [UIViewController]
    private let type: MarketOriginalParentType
    
    init(type: MarketOriginalParentType) {
        self.type = type
        self.pages = [firstViewController,secondViewController]
        firstViewController.delegate = self
        secondViewController.delegate = self
    }
    
    weak var delegate: MarketsBriefPageViewControllerViewModelProtocol?
    
    //MARK: - FUNCTIONS
    func getInitialViewController() -> [UIViewController] {
        if let firstViewController = pages.first {
            return [firstViewController]
        } else {
            return []
        }
    }
    
    func getNextViewController(index: Int) -> [UIViewController] {
        return [pages[index]]
    }
    
    func getViewControllerBeforeThisViewController(this vc: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: vc) else { return nil }
        currentlyShowingPageIndex = currentIndex
        let prevuesIndex = currentIndex - 1
        guard prevuesIndex >= 0 else { return nil }
        guard pages.count > prevuesIndex else { return nil }
        return pages[prevuesIndex]
    }
    
    func getViewControllerAfterThisViewController(this vc: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: vc) else { return nil }
        currentlyShowingPageIndex = currentIndex
        let nextIndex = currentIndex + 1
        guard pages.count != nextIndex else { return nil }
        guard pages.count > nextIndex else { return nil }
        return pages[nextIndex]
    }
    
    func filterMarkets(markets: [Markets]) {
        var mainMarkets: [Markets] = []
        var professionalMarkets: [Markets] = []
        for item in markets {
            if item.quoteCurrency.id == "IRR" {
                mainMarkets.append(item)
            } else {
                professionalMarkets.append(item)
            }
        }
        firstViewController.updateDateSource(items: mainMarkets)
        secondViewController.updateDataSource(items: professionalMarkets)
    }
    
    //MARK: - API
    func getMarketsListAPI() {
        Preloader.sharedInstance.startLoading()
        MarketsListService.getMarketsList { [weak self] results in
            Preloader.sharedInstance.stopLoading()
            guard let self = self else { return }
            switch results {
            case let .success(receivedResponse):
                switch receivedResponse {
                case let .success(response: responseModel):
                    self.filterMarkets(markets: responseModel.data)
                case let .validation(error: errorModel):
                    print(errorModel.status)
                }
            case let .failure(error):
                Popup.showError(body: error.localizedStrings)
            }
        }
    }
}

extension MarketsBriefPageViewControllerViewModel: MainMarketsViewControllerProtocol,ProfessionalMarketsViewControllerProtocol {
    func selectedItemFromMarkets(market: Markets) {
        delegate?.selectedItemFromMarkets(market: market)
    }
}
