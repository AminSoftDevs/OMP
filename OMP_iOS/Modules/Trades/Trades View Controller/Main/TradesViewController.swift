//
//  NewTradesViewController.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 11/9/21.
//

import UIKit

class TradesViewController: BaseViewController {

    private let refreshControl = UIRefreshControl()
    
    private lazy var mainScrollView: UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.bounces = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.refreshControl = refreshControl
        return scrollView
    }()
    
    private lazy var tableTitleContainerView: UIView = {
        var view = UIView()
        view.backgroundColor = .cardsColor
        view.layer.cornerRadius = 15
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    private lazy var titleImageView: UIImageView = {
       var imageView = UIImageView()
        imageView.image = UIImage(named: "line")
        return imageView
    }()
    
    private lazy var openOrdersTitleLabel: UILabel = {
       var label = UILabel()
        label.configure(text: "OrdersHistoryCollectionView.openOrders".localized, fontSize: 14, textColor: .mediumGrayColor, textAlignment: .center, fontType: .regular)
        return label
    }()
    
    lazy var mainTableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = true
        tableView.backgroundColor = .cardsColor
        tableView.layer.cornerRadius = 15
        tableView.rowHeight = 100
        tableView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        tableView.register(OrdersTableViewCell.self, forCellReuseIdentifier: OrdersTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    var mainTableViewHeight = NSLayoutConstraint()
    
    private lazy var tradeNavigationBarView: TradeNavigationBarView = TradeNavigationBarView()
    private lazy var potentialOrdersViewController: PotentialOrdersViewController = PotentialOrdersViewController.makeInstance()
    private lazy var openOrdersHeaderView = OrdersTableViewHeaderView(type: .open)
    
    //MARK: - INITIALIZER
    private let viewModel: TradesControllerViewModel
    
    init(viewModel: TradesControllerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - VIEW CONTROLLER LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor()
        hideNavigationBar(true)
        createUI()
        
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        refreshControl.tintColor = .textColor
        
        //delegates
        viewModel.delegate = self
        tradeNavigationBarView.delegate = self
        potentialOrdersViewController.delegate = self
        
        viewModel.getOpenOrders()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.startTimerToRefreshData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.timer.invalidate()
    }
    
    //MARK: - CREATE UI
    private func createUI() {
        addingTradeNavigationBarView()
        addingMainScrollView()
        addingPotentialOrdersViewController()
        addingTableTitleContainerView()
        addingOpenOrdersTitleLabel()
        addingTitleImageView()
        addingTableHeaderView()
        addingOpenOrdersTableView()
        
    }
    
    private func addingTradeNavigationBarView() {
        view.addSubview(tradeNavigationBarView)
        tradeNavigationBarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tradeNavigationBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tradeNavigationBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tradeNavigationBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tradeNavigationBarView.heightAnchor.constraint(equalToConstant: viewModel.navBarHeight)
        ])
    }
    
    private func addingMainScrollView() {
        view.addSubview(mainScrollView)
        mainScrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainScrollView.topAnchor.constraint(equalTo: tradeNavigationBarView.bottomAnchor, constant: 15),
            mainScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func addingPotentialOrdersViewController() {
        add(potentialOrdersViewController, into: mainScrollView)
        potentialOrdersViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            potentialOrdersViewController.view.topAnchor.constraint(equalTo: mainScrollView.topAnchor),
            potentialOrdersViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            potentialOrdersViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            potentialOrdersViewController.view.heightAnchor.constraint(equalToConstant: 480)
        ])
    }
    
    private func addingTableTitleContainerView() {
        mainScrollView.addSubview(tableTitleContainerView)
        tableTitleContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableTitleContainerView.topAnchor.constraint(equalTo: potentialOrdersViewController.view.bottomAnchor, constant: 15),
            tableTitleContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableTitleContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableTitleContainerView.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
    
    private func addingOpenOrdersTitleLabel() {
        tableTitleContainerView.addSubview(openOrdersTitleLabel)
        openOrdersTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            openOrdersTitleLabel.topAnchor.constraint(equalTo: tableTitleContainerView.topAnchor, constant: 15),
            openOrdersTitleLabel.trailingAnchor.constraint(equalTo: tableTitleContainerView.trailingAnchor, constant: -20)
        ])
    }
    
    private func addingTitleImageView() {
        tableTitleContainerView.addSubview(titleImageView)
        titleImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleImageView.topAnchor.constraint(equalTo: openOrdersTitleLabel.bottomAnchor, constant: 10),
            titleImageView.centerXAnchor.constraint(equalTo: tableTitleContainerView.centerXAnchor),
            titleImageView.widthAnchor.constraint(equalTo: tableTitleContainerView.widthAnchor, multiplier: 0.8)
        ])
    }
    
    private func addingTableHeaderView() {
        tableTitleContainerView.addSubview(openOrdersHeaderView)
        openOrdersHeaderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            openOrdersHeaderView.topAnchor.constraint(equalTo: titleImageView.bottomAnchor, constant: 5),
            openOrdersHeaderView.centerXAnchor.constraint(equalTo: tableTitleContainerView.centerXAnchor),
            openOrdersHeaderView.widthAnchor.constraint(equalTo: view.widthAnchor),
            openOrdersHeaderView.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    private func addingOpenOrdersTableView() {
        mainScrollView.addSubview(mainTableView)
        mainTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainTableView.topAnchor.constraint(equalTo: tableTitleContainerView.bottomAnchor),
            mainTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainTableView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor, constant: -20),
        ])
        
        mainTableViewHeight = mainTableView.heightAnchor.constraint(equalToConstant: 50)
        mainTableViewHeight.priority = UILayoutPriority(750)
        mainTableViewHeight.isActive = true
    }
    
    //MARK: - OBJC FUNCTIONS
    @objc func refreshData(_ sender: UIRefreshControl) {
        potentialOrdersViewController.updateDataByRefreshController()
    }
}

//MARK: - TRADE NAVIGATION BAR
extension TradesViewController: TradeNavigationBarDelegate {
    func actionHappened(with action: TradeNavButtonsAction) {
        switch action {
        case .symbols:
            let marketBriefViewController = MarketBriefViewController.makeInstance()
            marketBriefViewController.delegate = self
            show(marketBriefViewController, sender: self)
        case .graph:
            let vc = MarketGraphViewController.makeInstance(marketSymbol: viewModel.selectedMarketSymbol, marketName: viewModel.selectedMarketName)
            vc.hidesBottomBarWhenPushed = true
            show(vc, sender: self)
        case .orderHistory:
            let ordersHistoryViewController = OrdersHistoryViewController()
            show(ordersHistoryViewController, sender: self)
        case .buy:
            potentialOrdersViewController.changeBuyOrSellStatus(type: .buy)
        case .sell:
            potentialOrdersViewController.changeBuyOrSellStatus(type: .sell)
        }
    }
}

//MARK: - MAKE INSTANCE METHOD
extension TradesViewController {
    static func makeInstance() -> TradesViewController {
        .init(viewModel: TradesControllerViewModel())
    }
}

//MARK: - MARKET BRIEF DELEGATE
extension TradesViewController: MarketBriefViewControllerDelegate {
    func selectedMarket(market: Markets) {
        tradeNavigationBarView.headerTitle = market.formattedSymbol
        viewModel.selectedMarket = market
        potentialOrdersViewController.selectedMarketHandler(market: market)
    }
}

extension TradesViewController: PotentialOrdersControllerViewModelProtocol {
    func handlingBuyOrSellStatus(type: OrdersType) {
        tradeNavigationBarView.setActionType = type
    }
    
    func refreshOpenOrders() {
        viewModel.getOpenOrders()
    }
    
    func stopRefreshControlOnParent() {
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
        }
    }
}

//MARK: - TABLE VIEW DELEGATE
extension TradesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension TradesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mainTableView.dequeueReusableCell(withIdentifier: OrdersTableViewCell.identifier, for: indexPath) as! OrdersTableViewCell
        cell.cellType = .open
        cell.delegate = self
        cell.order = viewModel.itemForRow(at: indexPath)
        return cell
    }
}

extension TradesViewController: OrdersTableViewProtocol {
    func moveToMarketBySelectingOpenOrder(order: Orders) {
        viewModel.getMarketsListAPI(selectedOpenOrder: order)
    }
    
    func cancelPendingOrder(order: Orders) {
        viewModel.cancelPendingOrder(id: order.id)
    }
}

extension TradesViewController: NewTradesControllerViewModelProtocol {
    func responseFromTappingOnOpenOrder(market: Markets) {
        tradeNavigationBarView.headerTitle = market.formattedSymbol
        viewModel.selectedMarket = market
        potentialOrdersViewController.selectedMarketHandler(market: market)
    }
    
    func newDataReceived() {
        mainTableView.reloadData()
        UIView.animate(withDuration: 0.3) {
            self.mainTableViewHeight.constant = 35 + CGFloat(self.viewModel.orders.count * 100)
            self.mainScrollView.layoutIfNeeded()
        }
    }
}
