//
//  WithdrawDigitalCurrencyViewController.swift
//  OMP_iOS
//
//  Created by AminSoft on 7/17/1400 AP.
//

import UIKit
import PanModal

class WithdrawDigitalCurrencyViewController: BaseViewController {
    
    //    MARK: - PROPERTIES
    private lazy var mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .cardsColor
        scrollView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        scrollView.layer.cornerRadius = 20
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isScrollEnabled = true
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configure(text: "Withdraw.descriptionWithdrawDigitalCurrency".localized, fontSize: 14, textColor: .textColor, textAlignment: .right, fontType: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var withdrawValue: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configure(text: "Withdraw.withdrawValue".localized, fontSize: 14, textColor: .textColor, textAlignment: .right, fontType: .regular)
        return label
    }()
    
    private lazy var withdrawValueTextfield: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.configure(placeholder: "", borderColor: .clear, fontSize: 14, fontType: .regular, keyboardType: .decimalPad, textAlignment: .right, radius: 14, backgroundColor: .backgroundColor, textColor: .textColor)
        textField.delegate = self
        return textField
    }()
    
    private lazy var withdrawValueLabelStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 5
        return stack
    }()
    
    private lazy var withdrawableInventoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configure(text: "Withdraw.withdrawableInventory".localized + " :" + " \(viewModel.walletBalance)", fontSize: 13, textColor: .textFieldPlaceholderColor, textAlignment: .right, fontType: .regular)
        return label
    }()
    
    private lazy var lowestWithdrawalRateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configure(text: "Withdraw.lowestWithdrawalRate".localized + " :" + " \(viewModel.minimumWithdrawValue)", fontSize: 13, textColor: .textFieldPlaceholderColor, textAlignment: .right, fontType: .regular)
        return label
    }()
    
    private lazy var destinationWalletAddressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configure(text: "Withdraw.destinationWalletAddress".localized, fontSize: 14, textColor: .textColor, textAlignment: .right, fontType: .regular)
        return label
    }()
    
    private lazy var destinationWalletAddressTextfield: TextFieldWithPadding = {
        let showWalletsHistoryButton = UIButton()
        showWalletsHistoryButton.setImage(UIImage(named: "wallet_history")?.withRenderingMode(.alwaysTemplate), for: .normal)
        showWalletsHistoryButton.imageView?.tintColor = .submitButtonColor
        showWalletsHistoryButton.addTarget(self, action: #selector(showWalletsHistoryButtonPressed), for: .touchUpInside)
        let textField = TextFieldWithPadding()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.configure(placeholder: "", borderColor: .clear, fontSize: 14, fontType: .regular, keyboardType: .default, textAlignment: .left, radius: 14, backgroundColor: .backgroundColor, textColor: .textColor)
        textField.delegate = self
        textField.leftView = showWalletsHistoryButton
        textField.textPadding = .init(top: 0, left: 10, bottom: 0, right: 0)
        textField.leftViewPadding = .init(top: 0, left: 20, bottom: 0, right: -20)
        return textField
    }()
    
    private lazy var incorrectAddressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configure(text: "Withdraw.uncorrectAddress".localized, fontSize: 13, textColor: .textFieldPlaceholderColor, textAlignment: .right, fontType: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var transferFeeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configure(text: "Withdraw.transferFee".localized + " :" + " \(viewModel.transferFee)", fontSize: 14, textColor: .textColor, textAlignment: .right, fontType: .regular)
        return label
    }()
    
    private lazy var descriptionTransferFeeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configure(text: "Withdraw.descriptionTransferFee".localized , fontSize: 13, textColor: .textFieldPlaceholderColor, textAlignment: .right, fontType: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var createWithdrawButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configure(fontSize: 14, title: "Withdraw.createRequestWithdraw".localized, fontType: .regular, titleColor: .backgroundColor, backgroundColor: .submitButtonColor, borderColor: .clear, cornerRadius: 14)
        button.addTarget(self, action: #selector(createWithdrawButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var saveWalletAddress: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configure(fontSize: 14, title: "Withdraw.saveWalletAddress".localized, fontType: .regular, titleColor: .submitButtonColor, backgroundColor: .clear, borderColor: .clear, cornerRadius: 0)
        button.addTarget(self, action: #selector(saveWalletAddressPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var TagOrMemoView: TagView = {
        let view = TagView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    
    private lazy var walletAddressBriefListController = WalletsAddressViewController.makeInstance(type: .brief, tokens: viewModel.wallet.currency.tokens)
    private lazy var newWalletAddressView: NewWalletAddressViewController = NewWalletAddressViewController.makeInstance(wallet: nil, tokens: viewModel.wallet.currency.tokens, singleAddress: "" , type: .new)
    
    //    MARK: - INITIALIZER
    private var viewModel: WithdrawDigitalCurrencyViewModel
    
    init(viewModel: WithdrawDigitalCurrencyViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    MARK: - VIEW CONTROLLER LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBar(true)
        setBackgroundColor()
        createUI()
        
        walletAddressBriefListController.selectedWallet = { [weak self] wallet in
            guard let self = self else { return }
            self.destinationWalletAddressTextfield.text = wallet.wallet
        }
        
        walletAddressBriefListController.dismissBriefTable = { [weak self] in
            guard let self = self else { return }
            let vc = WalletsAddressViewController.makeInstance(type: .full, tokens: self.viewModel.wallet.currency.tokens)
            vc.hidesBottomBarWhenPushed = true
            self.show(vc, sender: self)
            
            vc.selectedWallet = { [weak self] wallet in
                guard let self = self else { return }
                self.destinationWalletAddressTextfield.text = wallet.wallet
            }
        }
    }
    //    MARK: - UPDATE UI
    private func createUI() {
        addingNavBar()
        addingMainScrollView()
        addingDescriptionLabel()
        addingWithdrawValue()
        addingWithdrawValueTextfield()
        addingWithdrawValueLabelStack()
        addingDestinationWalletAddressLabel()
        addingDestinationWalletAddressTextfield()
        addingSaveWalletAddressButton()
        addingIncorrectAddressLabel()
        addedTagView()
        addingDescriptionTransferFeeLabel()
        addingCreateWithdrawButton()
    }
    
    private func addingNavBar() {
        addingDefaultNavigationBarView(title: "withdraw".localized + " \(viewModel.walletName)", hasBackButton: true, leftSideButtonName: "history_icon", shouldHaveRadius: true)
        defaultNavigationBarView.delegate = self
    }
    private func addingMainScrollView() {
        view.addSubview(mainScrollView)
        NSLayoutConstraint.activate([
            mainScrollView.topAnchor.constraint(equalTo: defaultNavigationBarView.bottomAnchor, constant: 10),
            mainScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }
    private func addingDescriptionLabel() {
        mainScrollView.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: mainScrollView.topAnchor, constant: 30),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        ])
    }
    private func addingWithdrawValue() {
        mainScrollView.addSubview(withdrawValue)
        NSLayoutConstraint.activate([
            withdrawValue.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            withdrawValue.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    private func addingWithdrawValueTextfield() {
        mainScrollView.addSubview(withdrawValueTextfield)
        NSLayoutConstraint.activate([
            withdrawValueTextfield.topAnchor.constraint(equalTo: withdrawValue.bottomAnchor, constant: 5),
            withdrawValueTextfield.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            withdrawValueTextfield.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            withdrawValueTextfield.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    private func addingWithdrawValueLabelStack() {
        withdrawValueLabelStack.addArrangedSubview(withdrawableInventoryLabel)
        withdrawValueLabelStack.addArrangedSubview(lowestWithdrawalRateLabel)
        mainScrollView.addSubview(withdrawValueLabelStack)
        NSLayoutConstraint.activate([
            withdrawValueLabelStack.topAnchor.constraint(equalTo: withdrawValueTextfield.bottomAnchor, constant: 15),
            withdrawValueLabelStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    private func addingDestinationWalletAddressLabel() {
        mainScrollView.addSubview(destinationWalletAddressLabel)
        NSLayoutConstraint.activate([
            destinationWalletAddressLabel.topAnchor.constraint(equalTo: withdrawValueLabelStack.bottomAnchor, constant: 20),
            destinationWalletAddressLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func addingDestinationWalletAddressTextfield() {
        mainScrollView.addSubview(destinationWalletAddressTextfield)
        NSLayoutConstraint.activate([
            destinationWalletAddressTextfield.topAnchor.constraint(equalTo: destinationWalletAddressLabel.bottomAnchor, constant: 5),
            destinationWalletAddressTextfield.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            destinationWalletAddressTextfield.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            destinationWalletAddressTextfield.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func addingSaveWalletAddressButton() {
        mainScrollView.addSubview(saveWalletAddress)
        saveWalletAddress.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveWalletAddress.topAnchor.constraint(equalTo: destinationWalletAddressTextfield.bottomAnchor, constant: 5),
            saveWalletAddress.trailingAnchor.constraint(equalTo: destinationWalletAddressTextfield.trailingAnchor),
            saveWalletAddress.heightAnchor.constraint(equalToConstant: 35),
        ])
    }
    
    private func addingIncorrectAddressLabel() {
        mainScrollView.addSubview(incorrectAddressLabel)
        NSLayoutConstraint.activate([
            incorrectAddressLabel.topAnchor.constraint(equalTo: saveWalletAddress.bottomAnchor, constant: 15),
            incorrectAddressLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            incorrectAddressLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func addedTagView() {
        if let tagValue = viewModel.tagOrMemo {
            if tagValue {
                mainScrollView.addSubview(TagOrMemoView)
                NSLayoutConstraint.activate([
                    TagOrMemoView.topAnchor.constraint(equalTo: incorrectAddressLabel.bottomAnchor, constant: 15),
                    TagOrMemoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                    TagOrMemoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                ])
                mainScrollView.addSubview(transferFeeLabel)
                NSLayoutConstraint.activate([
                    transferFeeLabel.topAnchor.constraint(equalTo: TagOrMemoView.bottomAnchor, constant: 15),
                    transferFeeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                    transferFeeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
                ])
            } else {
                addingTransferFeeLabel()
            }
        }
    }
    private func addingTransferFeeLabel() {
        mainScrollView.addSubview(transferFeeLabel)
        NSLayoutConstraint.activate([
            transferFeeLabel.topAnchor.constraint(equalTo: incorrectAddressLabel.bottomAnchor, constant: 15),
            transferFeeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            transferFeeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    private func addingDescriptionTransferFeeLabel() {
        mainScrollView.addSubview(descriptionTransferFeeLabel)
        NSLayoutConstraint.activate([
            descriptionTransferFeeLabel.topAnchor.constraint(equalTo: transferFeeLabel.bottomAnchor, constant: 15),
            descriptionTransferFeeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionTransferFeeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    private func addingCreateWithdrawButton() {
        mainScrollView.addSubview(createWithdrawButton)
        NSLayoutConstraint.activate([
            createWithdrawButton.topAnchor.constraint(equalTo: descriptionTransferFeeLabel.bottomAnchor, constant: 10),
            createWithdrawButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            createWithdrawButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            createWithdrawButton.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor, constant: -20)
        ])
        let buttonHeight = createWithdrawButton.heightAnchor.constraint(equalToConstant: 48)
        buttonHeight.priority = UILayoutPriority(750)
        buttonHeight.isActive = true
    }
        
    //    MARK: - OBJC FUNC
    @objc private func createWithdrawButtonTapped() {
        viewModel.performWithdrawableDigitalCurrency { [weak self] withdrawItem in
            guard let self = self else { return }
            if let withdraw = self.viewModel.withdrawItem  {
                let vc = VerifyDigitalCurrencyWithdrawViewController.makeInstance(withdrawItem: withdraw, wallet: self.viewModel.wallet)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    @objc func showWalletsHistoryButtonPressed() {
        presentPanModal(walletAddressBriefListController)
    }
    
    @objc func saveWalletAddressPressed() {
        guard let walletAddress = destinationWalletAddressTextfield.text, !walletAddress.isEmpty else { return }
        newWalletAddressView = NewWalletAddressViewController.makeInstance(wallet: nil, tokens: viewModel.wallet.currency.tokens, singleAddress: walletAddress, type: .new)
        presentPanModal(newWalletAddressView)
    }
}
//MARK: - MAKE INSTANCE
extension WithdrawDigitalCurrencyViewController {
    static func makeInstance(wallet: Wallet) -> WithdrawDigitalCurrencyViewController {
        .init(viewModel: WithdrawDigitalCurrencyViewModel(wallet: wallet))
    }
}
// MARK: - TEXTFIELD DELEGATE
extension WithdrawDigitalCurrencyViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == withdrawValueTextfield {
            withdrawValueTextfield.layer.borderColor = UIColor.submitButtonColor.cgColor
            withdrawValueTextfield.layer.borderWidth = 2.5
        } else if textField == destinationWalletAddressTextfield {
            destinationWalletAddressTextfield.layer.borderColor = UIColor.submitButtonColor.cgColor
            destinationWalletAddressTextfield.layer.borderWidth = 2.5
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField == withdrawValueTextfield {
            withdrawValueTextfield.layer.borderColor = UIColor.clear.cgColor
            withdrawValueTextfield.layer.borderWidth = 0
        } else if textField == destinationWalletAddressTextfield {
            destinationWalletAddressTextfield.layer.borderColor = UIColor.clear.cgColor
            destinationWalletAddressTextfield.layer.borderWidth = 0
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == withdrawValueTextfield {
            if let text = textField.text {
                textField.text = text.convertEngNumToPersianNum()
                viewModel.withdrawalAmount = text.toDoubleNumber()
            }
        } else if textField == destinationWalletAddressTextfield {
            if let text = textField.text {
                self.viewModel.destinationCurrencyWalletAddress = text
            }
        }
    }
}

extension WithdrawDigitalCurrencyViewController: SendingTagText {
    func sendingTagValue(value: String) {
        self.viewModel.tagValue = value
    }
}
//MARK: - DefaultNavigationBarViewProtocol
extension WithdrawDigitalCurrencyViewController: DefaultNavigationBarViewProtocol {
    func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func leftSideButtonPressed() {
        let vc = HistoryWithdrawDigitalCurrencyViewController.makeInstance(wallet: viewModel.wallet)
        navigationController?.pushViewController(vc, animated: true)
    }
}

