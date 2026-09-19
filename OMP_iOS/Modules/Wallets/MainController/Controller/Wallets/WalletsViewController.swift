//
//  WalletsViewController.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 7/28/21.
//

import UIKit

class WalletsViewController: BaseViewController {
    
    var walletsCollectionViewHeight = NSLayoutConstraint()
    var walletsCollectionViewDefaultHeight: CGFloat = 100
    
    lazy var mainScrollView: UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    lazy var headerContainerView: UIView = {
        var view = UIView()
        view.backgroundColor = .cardsColor
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return view
    }()

    lazy var USDTitleLabel: UILabel  = {
        var label = UILabel()
        label.configure(text: "WalletsViewController.equal".localized, fontSize: 14, textColor: .textColor, textAlignment: .right, fontType: .regular)
        return label
    }()
    
    lazy var USDValueLabel: UILabel = {
       var label = UILabel()
        label.configure(text: "- " + "dollar".localized, fontSize: 15, textColor: .textColor, textAlignment: .left, fontType: .regular)
        return label
    }()
    
    lazy var transactionButtonsStackView: UIStackView = {
       var stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution =  .fillEqually
        stackView.spacing = 25
        return stackView
    }()
    
    lazy var withdrawButton: TransactionButton = {
        var button = TransactionButton(type: .withdraw, title: "withdraw".localized)
        button.addTarget(self, action: #selector(transactionButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var depositButton: TransactionButton = {
        var button = TransactionButton(type: .deposit, title: "deposit".localized)
        button.addTarget(self, action: #selector(transactionButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var navigationBarView = BaseNavigationBarView(navigationType: .walletMainScreen, title: "wallets".localized)
    lazy var walletsCollectionView = WalletsCollectionView.makeInstance()
    lazy var propertiesValueView: PropertiesValueView = PropertiesValueView.makeInstance(title: "WalletsViewController.totalProperty".localized)
    
    var bottomHeaderContainerView = NSLayoutConstraint()
    //MARK: - INITIALIZER
    let viewModel: NewWalletViewModel
    
    init(viewModel: NewWalletViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .signIn, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - VIEW CONTROLLER LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.changeStatusBarColor(color: .cardsColor)
        self.setBackgroundColor()
        self.hideNavigationBar(true)
        self.createUI()
        
        //wallets list delegate
        self.walletsCollectionView.delegate = self
        
        self.viewModel.userWalletsReceived = { [weak self] wallets in
            self?.walletsCollectionView.fillWallets(wallets: wallets)
            self?.updateWalletsCollectionView()
        }
        
        self.viewModel.userWalletHeaderDataReceived = { [weak self]  in
            self?.propertiesValueView.propertyInfo(value: self?.viewModel.totalPropertyRial ?? "", icon: self?.viewModel.totalPropertyIcon ?? "")
            self?.USDValueLabel.text = self?.viewModel.totalPropertyDollar
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        addingButtonsForMarketType()
        viewModel.getUserWalletListAPI()
    }
    
    //MARK: - OBSERVER
    fileprivate func addNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(signInHandler), name: .signIn, object: nil)
    }
    
    //MARK: - ADDING UI ELEMENTS TO VIEW SECTION
    fileprivate func createUI() {
        self.addingBaseNavigationBarView()
        self.addingMainScrollView()
        self.addingHeaderContainerView()
        self.addingTotalPropertiesValueView()
        self.addingUSDTitleLabel()
        self.addingUSDValueLabel()
        self.addingTransactionButtonsStackView()
        self.addNotificationObserver()
        //collection view
        self.addingWalletsCollectionView()
    }
    
    fileprivate func addingBaseNavigationBarView() {
        self.view.addSubview(navigationBarView)
        self.navigationBarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            navigationBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBarView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    fileprivate func addingMainScrollView() {
        self.view.addSubview(mainScrollView)
        self.mainScrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainScrollView.topAnchor.constraint(equalTo: navigationBarView.bottomAnchor),
            mainScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    fileprivate func addingHeaderContainerView() {
        self.mainScrollView.addSubview(headerContainerView)
        self.headerContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerContainerView.topAnchor.constraint(equalTo: mainScrollView.topAnchor),
            headerContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    //Total Property
    fileprivate func addingTotalPropertiesValueView() {
        self.headerContainerView.addSubview(propertiesValueView)
        self.propertiesValueView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            propertiesValueView.topAnchor.constraint(equalTo: headerContainerView.topAnchor, constant: 10),
            propertiesValueView.centerXAnchor.constraint(equalTo: headerContainerView.centerXAnchor),
            propertiesValueView.widthAnchor.constraint(equalTo: headerContainerView.widthAnchor, constant: -20),
            propertiesValueView.heightAnchor.constraint(equalTo: headerContainerView.heightAnchor, multiplier: 0, constant: 110)
        ])
    }
        
    fileprivate func addingUSDTitleLabel() {
        self.headerContainerView.addSubview(USDTitleLabel)
        self.USDTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            USDTitleLabel.topAnchor.constraint(equalTo: propertiesValueView.bottomAnchor, constant: 20),
            USDTitleLabel.trailingAnchor.constraint(equalTo: propertiesValueView.trailingAnchor, constant: -20),
        ])
    }
    
    fileprivate func addingUSDValueLabel() {
        self.headerContainerView.addSubview(USDValueLabel)
        self.USDValueLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            USDValueLabel.leadingAnchor.constraint(equalTo: propertiesValueView.leadingAnchor, constant: 25),
            USDValueLabel.centerYAnchor.constraint(equalTo: USDTitleLabel.centerYAnchor, constant: 0)
        ])
    }
    
    fileprivate func addingTransactionButtonsStackView() {
        self.headerContainerView.addSubview(transactionButtonsStackView)
        self.transactionButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            transactionButtonsStackView.topAnchor.constraint(equalTo: USDValueLabel.bottomAnchor, constant: 10),
            transactionButtonsStackView.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor, constant: 20),
            transactionButtonsStackView.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor, constant: -20),
            transactionButtonsStackView.heightAnchor.constraint(equalToConstant: 48),
        ])
        bottomHeaderContainerView = NSLayoutConstraint(item: headerContainerView, attribute: .bottom, relatedBy: .equal, toItem: transactionButtonsStackView, attribute: .bottom, multiplier: 1, constant: 15)

    }
    
    //MARK: - WALLETS COLLECTION VIEW
    fileprivate func addingWalletsCollectionView() {
        self.mainScrollView.addSubview(walletsCollectionView)
        self.walletsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            walletsCollectionView.topAnchor.constraint(equalTo: headerContainerView.bottomAnchor, constant: 15),
            walletsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            walletsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        walletsCollectionViewHeight = walletsCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0, constant: walletsCollectionViewDefaultHeight)
        walletsCollectionViewHeight.isActive = true
    }
    
    fileprivate func updateWalletsCollectionView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.mainScrollView.contentSize.height = self.headerContainerView.frame.height + 15 + self.walletsCollectionView.mainCollectionView.contentSize.height + self.walletsCollectionViewDefaultHeight
            UIView.animate(withDuration: 0.3) {
                self.walletsCollectionViewHeight.constant = self.walletsCollectionView.mainCollectionView.contentSize.height + self.walletsCollectionViewDefaultHeight
                self.mainScrollView.layoutIfNeeded()
            }
        }
    }
    
    private func addingButtonsForMarketType() {
        if UserDefaults.standard.selectedMarket == .real {
            transactionButtonsStackView.addArrangedSubview(withdrawButton)
            transactionButtonsStackView.addArrangedSubview(depositButton)
            bottomHeaderContainerView = NSLayoutConstraint(item: headerContainerView, attribute: .bottom, relatedBy: .equal, toItem: transactionButtonsStackView, attribute: .bottom, multiplier: 1, constant: 15)
            bottomHeaderContainerView.isActive = true
        } else if UserDefaults.standard.selectedMarket == .demo {
            transactionButtonsStackView.removeArrangedSubview(depositButton)
            transactionButtonsStackView.removeArrangedSubview(withdrawButton)
            bottomHeaderContainerView = NSLayoutConstraint(item: headerContainerView, attribute: .bottom, relatedBy: .equal, toItem: USDValueLabel, attribute: .bottom, multiplier: 1, constant: 15)
            bottomHeaderContainerView.isActive = true
        }
    }

    //MARK: - OBJC FUNCTIONS
    @objc func transactionButtonPressed(_ sender: TransactionButton) {
        let vc = SearchCurrencyViewController.makeInstance(wallets: viewModel.wallets, transactionType: sender.type)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func signInHandler() {
        viewModel.getUserWalletListAPI()
    }
}

//MARK: - MAKE INSTANCE METHOD
extension WalletsViewController {
    static func makeInstance() -> WalletsViewController {
        .init(viewModel: NewWalletViewModel())
    }
}

extension WalletsViewController: WalletsCollectionViewProtocol {
    func hideZeroBalance(_ hide: Bool) {
        viewModel.shouldHideZeroBalance = hide
    }
    
    func selectedItem(item wallet: Wallet) {
        let vc = WalletBalanceViewController.makeInstance(wallet: wallet)
        navigationController?.pushViewController(vc, animated: true)
    }
}
