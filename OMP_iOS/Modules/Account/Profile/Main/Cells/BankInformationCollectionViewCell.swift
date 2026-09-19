//
//  BankInformationCollectionViewCell.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 8/22/21.
//

import UIKit
import MHLoadingButton

class BankInformationCollectionViewCell: UICollectionViewCell {

    var creditsTableHeight: CGFloat = 0
    var bankAccountsTableHeight: CGFloat = 0
    
    var creditCardNumber: String?
    var bankAccountNumber: String?
    
    private var creditCardNumberViewHeight  = NSLayoutConstraint()
    private var saveButtonHeight            = NSLayoutConstraint()
    private var creditCardInfoViewHeight    = NSLayoutConstraint()
    private var creditCardNumberViewTop     = NSLayoutConstraint()
    
    private var accountNumberViewTop        = NSLayoutConstraint()
    private var accountNumberViewHeight     = NSLayoutConstraint()
    private var accountSaveButtonHeight     = NSLayoutConstraint()
    private var accountInfoTableViewHeight  = NSLayoutConstraint()
    
    var creditCardList: [BankInfoAdapter] = [] {
        didSet {
            self.creditCardInfoTableView?.bankInfoViewModel = creditCardList
            self.updateHeightOfCreditCardInfoView()
            self.resetCreditCardNumberView()
        }
    }
    
    var bankAccountList: [BankInfoAdapter] = [] {
        didSet {
            self.accountInfoTableView?.bankInfoViewModel = bankAccountList
            self.updateHeightOfBankAccountTableView()
            self.resetBankAccountNumberView()
        }
    }
    
    private lazy var titleLabel: UILabel = {
       var label = UILabel()
        label.configure(text: "BankInformationCollectionViewCell.title".localized, fontSize: 16, textColor: .textColor, textAlignment: .center, fontType: .regular)
        return label
    }()
    
    private lazy var titleImageView: UIImageView = {
       var imageView = UIImageView()
        imageView.image = UIImage(named: "line")
        return imageView
    }()
    
    private lazy var creditTitleLabel: UILabel = {
       var label = UILabel()
        label.configure(text: "BankInformationCollectionViewCell.creditTitle".localized, fontSize: 16, textColor: .textColor, textAlignment: .center, fontType: .regular)
        return label
    }()
    
    private lazy var creditPlusButton: UIButton = {
       var button = UIButton()
        button.setImage(UIImage(named: "add_icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .submitButtonColor
        button.setImage(UIImage(named: "close_icon2")?.withRenderingMode(.alwaysTemplate), for: .selected)
        button.addTarget(self, action: #selector(creditCardPlusButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var accountTitleLabel: UILabel = {
       var label = UILabel()
        label.configure(text: "BankInformationCollectionViewCell.accountTitle".localized, fontSize: 16, textColor: .textColor, textAlignment: .center, fontType: .regular)
        return label
    }()
    
    private lazy var accountPlusButton: UIButton = {
       var button = UIButton()
        button.setImage(UIImage(named: "add_icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.setImage(UIImage(named: "close_icon2")?.withRenderingMode(.alwaysTemplate), for: .selected)
        button.tintColor = .submitButtonColor
        button.addTarget(self, action: #selector(accountPlusButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var accountSaveButton: LoadingButton = {
       var button = LoadingButton()
        button.configure(fontSize: 12, title: "CreditCardsBankAccountsTableView.saveButtonTitle".localized, fontType: .regular, titleColor: .backgroundColor, backgroundColor: .rejectOrangeColor, borderColor: .clear, cornerRadius: 15)
        button.addTarget(self, action: #selector(accountSaveButtonPressed), for: .touchUpInside)
        button.indicator = BallPulseSyncIndicator(color: .mediumGrayColor)
        button.cornerRadius  = 15
        button.bgColor = .rejectOrangeColor
        button.indicator.color = .cardsColor
        button.alpha = 0
        return button
    }()
    
    private lazy var saveButton: LoadingButton = {
       var button = LoadingButton()
        button.configure(fontSize: 12, title: "CreditCardsBankAccountsTableView.saveButtonTitle".localized, fontType: .regular, titleColor: .backgroundColor, backgroundColor: .rejectOrangeColor, borderColor: .clear, cornerRadius: 15)
        button.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        button.indicator = BallPulseSyncIndicator(color: .mediumGrayColor)
        button.cornerRadius  = 15
        button.bgColor = .rejectOrangeColor
        button.indicator.color = .cardsColor
        button.alpha = 0
        return button
    }()
    
    private lazy var creditCardNumberView: CreditCardNumberView? = nil
    private lazy var creditCardInfoTableView: BankInfoTableView? = nil
    private lazy var accountInfoTableView: BankInfoTableView? = nil
    private lazy var accountNumberView: AccountNumberView? = nil
    
    weak var delegate: ProfileControllerViewModelProtocol?
    
    //MARK: - DEFAULT INITIALIZER
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .cardsColor
        layer.cornerRadius = 15
        clipsToBounds = true
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        saveButton.hideLoader()
    }
    
    //MARK: - CREATE UI
    private func createUI() {
        addingTitleLabel()
        addingTitleImageView()
        addingCreditTitleLabel()
        addingPlusButton()
        addingCreditCardNumberView()
        addingSaveButton()
        addingSavedCreditCardsTable()
        addingAccountTitleLabel()
        addingAccountPlusButton()
        addingAccountNumberView()
        addingAccountSaveButton()
        addingSavedBankAccountTable()
    }
    
    private func addingTitleLabel() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 25),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8)
        ])
    }
    
    private func addingTitleImageView() {
        addSubview(titleImageView)
        titleImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            titleImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8)
        ])
    }
    
    private func addingCreditTitleLabel() {
        addSubview(creditTitleLabel)
        creditTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            creditTitleLabel.topAnchor.constraint(equalTo: titleImageView.bottomAnchor, constant: 30),
            creditTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
    }
    
    private func addingPlusButton() {
        addSubview(creditPlusButton)
        creditPlusButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            creditPlusButton.centerYAnchor.constraint(equalTo: creditTitleLabel.centerYAnchor),
            creditPlusButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
        ])
    }
    
    private func addingCreditCardNumberView() {
        creditCardNumberView = CreditCardNumberView(type: .profileCredit)
        creditCardNumberView?.delegate = self
        creditCardNumberView?.alpha = 0
        addSubview(creditCardNumberView!)
        creditCardNumberView?.translatesAutoresizingMaskIntoConstraints = false
        creditCardNumberViewTop = creditCardNumberView!.topAnchor.constraint(equalTo: creditTitleLabel.bottomAnchor)
        creditCardNumberViewTop.isActive = true
        NSLayoutConstraint.activate([
            creditCardNumberView!.centerXAnchor.constraint(equalTo: centerXAnchor),
            creditCardNumberView!.widthAnchor.constraint(equalTo: widthAnchor, constant: -30)
        ])
        creditCardNumberViewHeight = creditCardNumberView!.heightAnchor.constraint(equalToConstant: 0)
        creditCardNumberViewHeight.isActive = true
    }
    
    private func addingSaveButton() {
        addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: creditCardNumberView!.bottomAnchor, constant: 20),
            saveButton.centerXAnchor.constraint(equalTo: creditCardNumberView!.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 100)
            
        ])
        saveButtonHeight = saveButton.heightAnchor.constraint(equalToConstant: 1)
        saveButtonHeight.isActive = true
    }
    
    private func addingSavedCreditCardsTable() {
        creditCardInfoTableView = BankInfoTableView(type: .profileCredit)
        creditCardInfoTableView?.delegate = self
        addSubview(creditCardInfoTableView!)
        creditCardInfoTableView?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            creditCardInfoTableView!.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 15),
            creditCardInfoTableView!.trailingAnchor.constraint(equalTo: trailingAnchor),
            creditCardInfoTableView!.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
        creditCardInfoViewHeight = creditCardInfoTableView!.heightAnchor.constraint(equalToConstant: 0)
        creditCardInfoViewHeight.isActive = true
    }
    
    private func addingAccountTitleLabel() {
        addSubview(accountTitleLabel)
        accountTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            accountTitleLabel.topAnchor.constraint(equalTo: creditCardInfoTableView!.bottomAnchor, constant: 30),
            accountTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
    }
    
    private func addingAccountPlusButton() {
        addSubview(accountPlusButton)
        accountPlusButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            accountPlusButton.centerYAnchor.constraint(equalTo: accountTitleLabel.centerYAnchor),
            accountPlusButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        ])
        
    }
    
    private func addingAccountNumberView() {
        accountNumberView = AccountNumberView(type: .profileAccount)
        accountNumberView?.delegate = self
        accountNumberView?.alpha = 0
        addSubview(accountNumberView!)
        accountNumberView?.translatesAutoresizingMaskIntoConstraints = false
        accountNumberViewTop = accountNumberView!.topAnchor.constraint(equalTo: accountTitleLabel.bottomAnchor)
        accountNumberViewTop.isActive = true
        NSLayoutConstraint.activate([
            accountNumberView!.centerXAnchor.constraint(equalTo: centerXAnchor),
            accountNumberView!.widthAnchor.constraint(equalTo: widthAnchor, constant: -30)
        ])
        accountNumberViewHeight = accountNumberView!.heightAnchor.constraint(equalToConstant: 0)
        accountNumberViewHeight.isActive = true
    }
    
    private func addingAccountSaveButton() {
        addSubview(accountSaveButton)
        accountSaveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            accountSaveButton.topAnchor.constraint(equalTo: accountNumberView!.bottomAnchor, constant: 20),
            accountSaveButton.centerXAnchor.constraint(equalTo: accountNumberView!.centerXAnchor),
            accountSaveButton.widthAnchor.constraint(equalToConstant: 100)
        ])
        accountSaveButtonHeight = accountSaveButton.heightAnchor.constraint(equalToConstant: 1)
        accountSaveButtonHeight.isActive = true
    }
    
    private func addingSavedBankAccountTable() {
        accountInfoTableView = BankInfoTableView(type: .profileAccount)
        accountInfoTableView?.delegate = self
        addSubview(accountInfoTableView!)
        accountInfoTableView?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            accountInfoTableView!.topAnchor.constraint(equalTo: accountSaveButton.bottomAnchor, constant: 15),
            accountInfoTableView!.trailingAnchor.constraint(equalTo: trailingAnchor),
            accountInfoTableView!.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
        accountInfoTableViewHeight = accountInfoTableView!.heightAnchor.constraint(equalToConstant: 0)
        accountInfoTableViewHeight.isActive = true
    }
    
    private func showCreditCardNumberView() {
        UIView.animate(withDuration: 0.3) {
            self.creditCardNumberView?.alpha = 1
            self.saveButton.alpha = 1
            self.creditCardNumberViewTop.constant = 20
            self.creditCardNumberViewHeight.constant = 90
            self.saveButtonHeight.constant = 50
            self.layoutIfNeeded()
        }
    }
    
    private func removeCreditCardNumberView() {
        UIView.animate(withDuration: 0.3) {
            self.creditCardNumberView?.alpha = 0
            self.saveButton.alpha = 0
            self.creditCardNumberViewHeight.constant = 0
            self.creditCardNumberViewTop.constant = 0
            self.saveButtonHeight.constant = 0
            self.layoutIfNeeded()
        }
    }
    
    private func updateHeightOfCreditCardInfoView() {
        let height = CGFloat(creditCardList.count) *  120
        creditsTableHeight = height
        UIView.animate(withDuration: 0.3) {
            self.creditCardInfoViewHeight.constant = height
            self.delegate?.storedCreditCardsTableHeight(height: self.bankAccountsTableHeight + self.creditsTableHeight +  270)
            self.layoutIfNeeded()
        }
    }
    
    func resetCreditCardNumberView() {
        if creditCardNumberViewHeight.constant > 10 {
            creditPlusButton.isSelected = false
            removeCreditCardNumberView()
            creditCardNumberView?.clearTextFields()
        }
    }
    
    private func showAccountNumberView() {
        UIView.animate(withDuration: 0.3) {
            self.accountNumberView?.alpha = 1
            self.accountSaveButton.alpha = 1
            self.accountNumberViewTop.constant = 20
            self.accountNumberViewHeight.constant = 90
            self.accountSaveButtonHeight.constant = 50
            self.layoutIfNeeded()
        }
    }
    
    private func removeAccountNumberView() {
        UIView.animate(withDuration: 0.3) {
            self.accountNumberView?.alpha = 0
            self.accountSaveButton.alpha = 0
            self.accountNumberViewHeight.constant = 0
            self.accountNumberViewTop.constant = 0
            self.accountSaveButtonHeight.constant = 0
            self.layoutIfNeeded()
        }
    }
    
    private func updateHeightOfBankAccountTableView() {
        let height = CGFloat(bankAccountList.count) *  120
        bankAccountsTableHeight = height
        UIView.animate(withDuration: 0.3) {
            self.accountInfoTableViewHeight.constant = height
            self.delegate?.storedCreditCardsTableHeight(height: self.bankAccountsTableHeight + self.creditsTableHeight +  270)
            self.layoutIfNeeded()
        }
    }
    
    func resetBankAccountNumberView() {
        if accountNumberViewHeight.constant > 10 {
            accountPlusButton.isSelected = false
            removeAccountNumberView()
            accountNumberView?.clearTextField()
        }
    }
    
    //MARK: - OBJC FUNCTIONS
    @objc func accountPlusButtonPressed() {
        accountPlusButton.isSelected = !accountPlusButton.isSelected
        if accountPlusButton.isSelected {
            showAccountNumberView()
            delegate?.creditCardTemplateOnScreen(status: true)
        } else {
            removeAccountNumberView()
            delegate?.creditCardTemplateOnScreen(status: false)
        }
    }
    
    @objc func accountSaveButtonPressed() {
        accountSaveButton.showLoader(userInteraction: false)
        accountSaveButton.autoHideLoader()
        guard let accountNumber = self.bankAccountNumber, accountNumber.count == 24 else {
            Popup.showError(body: "BankInformationCollectionViewCell.bankAccount".localized)
            accountSaveButton.hideLoader()
            return
        }
        delegate?.newBankInfoAdded(type: .profileAccount, number: accountNumber)
        bankAccountNumber = nil
    }
    
    @objc func creditCardPlusButtonPressed() {
        creditPlusButton.isSelected = !creditPlusButton.isSelected
        if creditPlusButton.isSelected {
            showCreditCardNumberView()
            delegate?.creditCardTemplateOnScreen(status: true)
        } else {
            removeCreditCardNumberView()
            delegate?.creditCardTemplateOnScreen(status: false)
        }
    }
    
    @objc func saveButtonPressed() {
        saveButton.showLoader(userInteraction: false)
        saveButton.autoHideLoader()
        guard let cardNumber = self.creditCardNumber, cardNumber.count == 16 else {
            Popup.showError(body: "BankInformationCollectionViewCell.cardNumberWarn".localized)
            saveButton.hideLoader()
            return
        }
        
        delegate?.newBankInfoAdded(type: .profileCredit, number: cardNumber)
        self.creditCardNumber = nil
    }
}

extension BankInformationCollectionViewCell: BankInfoDelegate {
    func deleteBankInfoPressed(type: BankInformationType, item: BankInfoAdapter) {
        delegate?.deleteBankInfo(type: type, item: item)
    }
    
    func infoFieldNumber(type: BankInformationType, number: String) {
        if type == .profileCredit {
            self.creditCardNumber = number
        } else if type == .profileAccount {
            self.bankAccountNumber = number
        }
    }
}

extension LoadingButton {
    func autoHideLoader() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.hideLoader()
        }
    }
}
