//
//  WalletBalanceViewController.swift
//  OMP_iOS
//
//  Created by AminSoft on 7/4/1400 AP.
//

import UIKit

class WalletBalanceViewController: BaseViewController {
    
    enum WalletBalanceRow {
        case equal
        case approximateValue
        case available
        case inOrder
        
        var title: String {
            switch self {
            case .available:
                return "OrdersSectionView.available".localized
                
            case .equal:
                return "WalletsViewController.equal".localized
                
            case .approximateValue:
                return "WalletBalanceDetailView.approximateBalance".localized
                
            case .inOrder:
                return "WalletBalanceDetailView.inOrderBalance".localized
            }
        }
    }
    
    //    MARK: - PROPERTIES
    private lazy var walletBalanceNavigationBar: BaseNavigationBarView? = nil
    
    private lazy var inventoryView: WalletBalanceHeaderView = {
        let view = WalletBalanceHeaderView(viewModel: viewModel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var detailView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .cardsColor
        return view
    }()
    private lazy var bottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .cardsColor
        return view
    }()
    
    private lazy var separatorImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "line")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private lazy var depositButton: TransactionButton = {
        let button = TransactionButton(type: .deposit, title: "deposit".localized)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(depositButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var withdrawButton: TransactionButton = {
        let button = TransactionButton(type: .withdraw, title: "withdraw".localized)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(withdrawButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var equalRow: RowView = {
        let row = RowView(title: WalletBalanceRow.equal.title)
        row.translatesAutoresizingMaskIntoConstraints = false
        return row
    }()
    
    private lazy var approximateRow: RowView = {
        let row = RowView(title: WalletBalanceRow.approximateValue.title)
        row.translatesAutoresizingMaskIntoConstraints = false
        return row
    }()
    
    private lazy var availableRow: RowView = {
        let label = RowView(title: WalletBalanceRow.available.title)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var inOrderRow: RowView = {
        let label = RowView(title: WalletBalanceRow.inOrder.title)
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
    
    //    MARK: - INITIALIZERS
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
        detailView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        detailView.layer.cornerRadius = 20
        bottomView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        bottomView.layer.cornerRadius = 20
        //       SETUP UI
        createUI()
        //       UPDATE UI With ViewModel
        updateUI()        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addingButtonsForMarketType()
    }
    
    //    MARK: - CREATE UI
    private func createUI() {
        addingBaseNavigationBar()
        addingDetailView()
        addingInventoryView()
        detailBalanceCurrencyStackLabel()
        AddingBottomView()
        addingWithdrawButton()
        addingDepositButton()
        addingSeparatorImageView()
        
    }
    
    private func addingBaseNavigationBar() {
        self.walletBalanceNavigationBar = BaseNavigationBarView(navigationType: .defaultMode, title: viewModel.walletName)
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
        detailBalanceCurrencyStackView.addArrangedSubview(equalRow)
        detailBalanceCurrencyStackView.addArrangedSubview(approximateRow)
        detailBalanceCurrencyStackView.addArrangedSubview(availableRow)
        detailBalanceCurrencyStackView.addArrangedSubview(inOrderRow)
        self.detailView.addSubview(detailBalanceCurrencyStackView)
        NSLayoutConstraint.activate([
            detailBalanceCurrencyStackView.topAnchor.constraint(equalTo: inventoryView.bottomAnchor, constant: 5),
            detailBalanceCurrencyStackView.centerXAnchor.constraint(equalTo: inventoryView.centerXAnchor),
            detailBalanceCurrencyStackView.bottomAnchor.constraint(equalTo: detailView.bottomAnchor, constant: -5),
            detailBalanceCurrencyStackView.widthAnchor.constraint(equalTo: detailView.widthAnchor, multiplier: 0.85)
        ])
    }
    
    private func addingWithdrawButton() {
        view.addSubview(withdrawButton)
        NSLayoutConstraint.activate([
            withdrawButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            withdrawButton.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -17),
            withdrawButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            withdrawButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func addingDepositButton() {
        view.addSubview(depositButton)
        NSLayoutConstraint.activate([
            depositButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            depositButton.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -17),
            depositButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            depositButton.heightAnchor.constraint(equalToConstant: 48),
            bottomView.topAnchor.constraint(equalTo: depositButton.topAnchor, constant: -15)
        ])
    }
    
    private func AddingBottomView() {
        view.addSubview(bottomView)
        NSLayoutConstraint.activate([
            bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
    }
    
    private func addingSeparatorImageView() {
        view.addSubview(separatorImageView)
        NSLayoutConstraint.activate([
            separatorImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            separatorImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            separatorImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            separatorImageView.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
    
    private func addingButtonsForMarketType() {
        if UserDefaults.standard.selectedMarket == .real {
            depositButton.isHidden = false
            withdrawButton.isHidden = false
        } else if UserDefaults.standard.selectedMarket == .demo {
            depositButton.isHidden = true
            withdrawButton.isHidden = true
            bottomView.isHidden = true
        }
    }
    //    MARK: - OBJC FUNC
    @objc private func depositButtonTapped() {
        let vc = viewModel.getController(type: .deposit)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func withdrawButtonTapped() {
        let vc = viewModel.getController(type: .withdraw)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func updateUI() {
        self.equalRow.setValue(viewModel.equalCurrencyBalance)
        self.approximateRow.setValue(viewModel.approximateCurrency)
        self.availableRow.setValue(viewModel.availableCurrencyBalance)
        self.inOrderRow.setValue(viewModel.inOrderCurrencyBalance)
    }
}

// MARK: - MAKE INSTANCE
extension WalletBalanceViewController {
    static func makeInstance(wallet: Wallet) -> WalletBalanceViewController {
        .init(viewModel: WalletBalanceViewModel(wallet: wallet))
    }
}

// MARK: - BASENAVIGATIONBAR DELEGATE
extension WalletBalanceViewController: BaseNavigationBarDelegate {
    func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
}

