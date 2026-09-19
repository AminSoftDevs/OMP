//
//  MarketBriefViewController.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 9/1/21.
//

import UIKit

class MarketBriefViewController: BaseViewController {
    
    private let marketNavBarHeight: CGFloat = 50
    private lazy var marketNavBarView: SecondaryMarketNavBarView = SecondaryMarketNavBarView(type: .brief)
    private lazy var marketsPageViewController = MarketsBriefPageViewController.makeInstance()
    
    weak var delegate: MarketBriefViewControllerDelegate?
    
    private let viewModel: MarketBriefViewControllerViewModel
    
    init(viewModel: MarketBriefViewControllerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - VIEW CONTROLLER LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBar(true)
        setBackgroundColor()
        createUI()
        marketsPageViewController.viewModel.delegate = self
    }
    
    //MARK: - CREATE UI
    private func createUI() {
        addingDefaultNavBar()
        addingMarketNavBarView()
        addingMarketsBriefPageViewController()
    }
    
    private func addingDefaultNavBar() {
        addingDefaultNavigationBarView(title: "MarketBriefViewController.navTitle".localized, hasBackButton: true, shouldHaveRadius: false)
        defaultNavigationBarView.delegate = self
    }
    
    private func addingMarketNavBarView() {
        marketNavBarView.delegate = self
        view.addSubview(marketNavBarView)
        marketNavBarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            marketNavBarView.topAnchor.constraint(equalTo: defaultNavigationBarView.bottomAnchor),
            marketNavBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            marketNavBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            marketNavBarView.heightAnchor.constraint(equalToConstant: marketNavBarHeight),
        ])
    }
    
    private func addingMarketsBriefPageViewController() {
        add(marketsPageViewController)
        marketsPageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            marketsPageViewController.view.topAnchor.constraint(equalTo: marketNavBarView.bottomAnchor, constant: 15),
            marketsPageViewController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            marketsPageViewController.view.widthAnchor.constraint(equalTo: view.widthAnchor),
            marketsPageViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
// MARK: - DefaultNavigationBarViewProtocol
extension MarketBriefViewController: DefaultNavigationBarViewProtocol {
    func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
}

extension MarketBriefViewController: MarketDelegate {
    func selectedNavItem(type: MarketsType) {
        //self.marketMainView?.selectedTab = type
    }
    
    func changeTabByScrolling(type: MarketsType) {
        self.marketNavBarView.changeTab = type
    }
    
    func selectedTabTag(tag: Int) {
        marketsPageViewController.shouldShowPageWithIndex(index: tag)
    }
}

extension MarketBriefViewController {
    static func makeInstance() -> MarketBriefViewController {
        .init(viewModel: MarketBriefViewControllerViewModel())
    }
}

extension MarketBriefViewController: MarketsBriefPageViewControllerViewModelProtocol {
    func indexOfShowingController(index: Int) {
        marketNavBarView.selectedTag = index
    }
    
    func selectedItemFromMarkets(market: Markets) {
        self.delegate?.selectedMarket(market: market)
        self.navigationController?.popViewController(animated: true)
    }
}
