//
//  WalletBalanceViewController.swift
//  OMP_iOS
//
//  Created by AminSoft on 7/4/1400 AP.
//

import UIKit

class WalletBalanceViewController: BaseViewController {
    
    //    MARK: - PROPERTIES
    private lazy var walletBalanceNavigationBar: BaseNavigationBarView? = nil
    
    private lazy var inventoryView: WalletBalanceHeaderView = {
        let view = WalletBalanceHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var detailView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .cardsColor
        return view
    }()
    
    private lazy var equalLabel: WalletBalanceLabelView = {
        let label = WalletBalanceLabelView(mode: .equal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var approximateValueLabel: WalletBalanceLabelView = {
        let label = WalletBalanceLabelView(mode: .approximateValue)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var availableLabel: WalletBalanceLabelView = {
        let label = WalletBalanceLabelView(mode: .available)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var inOrderLabel: WalletBalanceLabelView = {
        let label = WalletBalanceLabelView(mode: .inOrder)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var detailBalanceCurrencyStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.alignment = .fill
        return stackView
    }()
    

    //    MARK: - INITILIZERS
    private let viewModel: WalletBalanceViewModel
    
    init(viewModel: WalletBalanceViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.changeStatusBarColor(color: .cardsColor)
        self.hideNavigationBar(true)
        self.setBackgroundColor()
        createUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        detailView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        detailView.layer.cornerRadius = 20
    }

    //    MARK: - CREATE UIa
    private func createUI() {
        addingBaseNavigationBar()
        addingDetailView()
        addingInventoryView()
        detailBalanceCurrencyStackLabel()
    }
    
    private func addingBaseNavigationBar() {
        self.walletBalanceNavigationBar = BaseNavigationBarView(navigationType: .defaultMode, title: "تومان")
        self.walletBalanceNavigationBar?.delegate = self
        self.view.addSubview(walletBalanceNavigationBar!)
        self.walletBalanceNavigationBar?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            walletBalanceNavigationBar!.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            walletBalanceNavigationBar!.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            walletBalanceNavigationBar!.widthAnchor.constraint(equalTo: view.widthAnchor),
            walletBalanceNavigationBar!.heightAnchor.constraint(equalToConstant: 75)
        ])
    }
    
    private func addingDetailView() {
        view.addSubview(detailView)
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: walletBalanceNavigationBar!.bottomAnchor, constant: 10),
            detailView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            detailView.widthAnchor.constraint(equalTo: view.widthAnchor),
            detailView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.45)
        ])
    }
    
    private func addingInventoryView() {
        self.detailView.addSubview(inventoryView)
        NSLayoutConstraint.activate([
            inventoryView.topAnchor.constraint(equalTo: detailView.topAnchor, constant: 10),
            inventoryView.centerXAnchor.constraint(equalTo: detailView.centerXAnchor),
            inventoryView.widthAnchor.constraint(equalTo: detailView.widthAnchor, multiplier: 0.95),
            inventoryView.heightAnchor.constraint(equalTo: detailView.heightAnchor, multiplier: 0.35)
        ])
    }
    
    private func detailBalanceCurrencyStackLabel() {
        detailBalanceCurrencyStackView.addArrangedSubview(equalLabel)
        detailBalanceCurrencyStackView.addArrangedSubview(approximateValueLabel)
        detailBalanceCurrencyStackView.addArrangedSubview(availableLabel)
        detailBalanceCurrencyStackView.addArrangedSubview(inOrderLabel)
        self.detailView.addSubview(detailBalanceCurrencyStackView)
        NSLayoutConstraint.activate([
            detailBalanceCurrencyStackView.topAnchor.constraint(equalTo: inventoryView.bottomAnchor, constant: 5),
            detailBalanceCurrencyStackView.centerXAnchor.constraint(equalTo: inventoryView.centerXAnchor),
            detailBalanceCurrencyStackView.bottomAnchor.constraint(equalTo: detailView.bottomAnchor, constant: -5),
            detailBalanceCurrencyStackView.widthAnchor.constraint(equalTo: detailView.widthAnchor, multiplier: 0.9)
        ])
    }
}

extension WalletBalanceViewController {
    static func makeInstance(wallet: Wallet) -> WalletBalanceViewController {
        .init(viewModel: WalletBalanceViewModel(wallet: wallet ))
    }
}
//extension WalletBalanceViewController {
//    static func makeInstance() -> WalletBalanceViewController {
//        .init(wallet: WalletBalanceViewModel(wallet: Wallet))
//    }
//}
extension WalletBalanceViewController: BaseNavigationBarDelegate {
    func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
}
