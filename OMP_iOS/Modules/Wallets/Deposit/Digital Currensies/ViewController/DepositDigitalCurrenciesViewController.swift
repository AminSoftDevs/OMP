//
//  DepositViewController.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 9/30/21.
//

import UIKit
import Kingfisher

class DepositDigitalCurrenciesViewController: BaseViewController {
    
    private lazy var containerView: UIView = {
        var view = UIView()
        view.backgroundColor = .cardsColor
        view.layer.cornerRadius = 25
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    private lazy var walletAddressDescriptionLabel: UILabel = {
        var label = UILabel()
        label.configure(text: "walletAddressDescriptionLabel".localized, fontSize: 14, textColor: .textColor, textAlignment: .right, fontType: .regular)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var QRCodeImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var walletBalanceTitleLabel: UILabel = {
       var label = UILabel()
        label.configure(text: "walletBalance".localized + " :", fontSize: 15, textColor: .textColor, textAlignment: .right, fontType: .regular)
        label.contentCompressionResistancePriority(for: .horizontal)
        return label
    }()
    
    private lazy var walletBalanceLabel: UILabel = {
       var label = UILabel()
        label.configure(text: viewModel.balance, fontSize: 16, textColor: .textColor, textAlignment: .center, fontType: .regular)
        return label
    }()
    
    private lazy var refreshBalanceButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(named: "repeat_icon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.tintColor = .rejectOrangeColor
        button.layer.cornerRadius = 15
        button.backgroundColor = .rejectOrangeColor.withAlphaComponent(0.15)
        button.imageView?.layer.transform = CATransform3DMakeScale(0.8, 0.8, 0.8)
        button.addTarget(self, action: #selector(refreshBalanceButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var walletAddressStackView: UIStackView = {
       var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var walletMainAddressView: WalletAddressView  = WalletAddressView()
    private lazy var walletMemoTagView: WalletAddressView  = WalletAddressView()
    
    //MARK: - INITIALIZER
    private let viewModel: DepositDigitalCurrenciesViewModel
    
    init(viewModel: DepositDigitalCurrenciesViewModel) {
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
        
        defaultNavigationBarView.delegate = self
        viewModel.delegate = self
        
        //Request for wallet address
        viewModel.getDepositWalletAddressAPI()
    }
    
    //MARK: - CREATE UI
    private func createUI() {
        addingDefaultNavigationBarView(title: viewModel.navTitle, hasBackButton: true, leftSideButtonName: "history_icon", shouldHaveRadius: true)
        addingContainerView()
        addingWalletAddressDescriptionLabel()
        addingQRCodeImageView()
        addingWalletAddressStackView(hasMemoTag: viewModel.walletHasTag)
        addingRefreshBalanceButton()
        addingWalletBalanceTitleLabel()
        addingWalletBalanceLabel()
    }
    
    private func addingContainerView() {
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: defaultNavigationBarView.bottomAnchor, constant: 15),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func addingWalletAddressDescriptionLabel() {
        containerView.addSubview(walletAddressDescriptionLabel)
        walletAddressDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            walletAddressDescriptionLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
            walletAddressDescriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 25),
            walletAddressDescriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -25),
        ])
    }
    
    private func addingQRCodeImageView() {
        containerView.addSubview(QRCodeImageView)
        QRCodeImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            QRCodeImageView.topAnchor.constraint(equalTo: walletAddressDescriptionLabel.bottomAnchor, constant: 20),
            QRCodeImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            QRCodeImageView.widthAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.25),
            QRCodeImageView.heightAnchor.constraint(equalTo: QRCodeImageView.widthAnchor),
        ])
    }
    
    private func addingWalletAddressStackView(hasMemoTag: Bool) {
        containerView.addSubview(walletAddressStackView)
        walletAddressStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            walletAddressStackView.topAnchor.constraint(equalTo: QRCodeImageView.bottomAnchor, constant: 30),
            walletAddressStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            walletAddressStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
        ])
        self.walletAddressStackView.addArrangedSubview(walletMainAddressView)
        if hasMemoTag {
            self.walletAddressStackView.addArrangedSubview(walletMemoTagView)
        }
    }
        
    private func addingRefreshBalanceButton() {
        containerView.addSubview(refreshBalanceButton)
        refreshBalanceButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            refreshBalanceButton.topAnchor.constraint(equalTo: walletAddressStackView.bottomAnchor, constant: 15),
            refreshBalanceButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            refreshBalanceButton.widthAnchor.constraint(equalToConstant: 60),
            refreshBalanceButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    
    private func addingWalletBalanceTitleLabel() {
        containerView.addSubview(walletBalanceTitleLabel)
        walletBalanceTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            walletBalanceTitleLabel.centerYAnchor.constraint(equalTo: refreshBalanceButton.centerYAnchor),
            walletBalanceTitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            walletBalanceTitleLabel.widthAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    private func addingWalletBalanceLabel() {
        containerView.addSubview(walletBalanceLabel)
        walletBalanceLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            walletBalanceLabel.centerYAnchor.constraint(equalTo: walletBalanceTitleLabel.centerYAnchor, constant: 3),
            walletBalanceLabel.leadingAnchor.constraint(equalTo: refreshBalanceButton.trailingAnchor, constant: 10),
            walletBalanceLabel.trailingAnchor.constraint(equalTo: walletBalanceTitleLabel.leadingAnchor, constant: -10),
        ])
    }
    
    //MARK: - OBJC FUNCTIONS
    @objc func refreshBalanceButtonPressed() {
        viewModel.refreshBalanceButtonPressed()
    }
}

//MARK: - Make Instance Method
extension DepositDigitalCurrenciesViewController {
    static func makeInstance(wallet: Wallet) -> DepositDigitalCurrenciesViewController {
        .init(viewModel: DepositDigitalCurrenciesViewModel(wallet: wallet))
    }
}

//MARK: - DefaultNavigationBarViewProtocol
extension DepositDigitalCurrenciesViewController: DefaultNavigationBarViewProtocol {
    func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    func leftSideButtonPressed() {
        let vc = DepositHistoryViewController.makeInstance(wallet: viewModel.wallet)
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - DepositDigitalCurrenciesViewModelProtocol
extension DepositDigitalCurrenciesViewController: DepositDigitalCurrenciesViewModelProtocol {
    func balanceRefreshed(balance: String) {
        walletBalanceLabel.text = balance
    }
    
    func depositWalletAddressReceived(address: String, memo: String) {
        walletMainAddressView.inputText  = address
        walletMemoTagView.inputText = memo
        QRCodeImageView.kf.setImage(with: address.QRCodeURL)
    }
}
