//
//  BankInfoTableView.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 8/14/21.
//

import UIKit
import MHLoadingButton

enum BankInformationType {
    case credit
    case account
    case profileCredit
    case profileAccount
}

class BankInfoTableView: UIView {
    
    var bankInfoViewModel: [BankInfoAdapter] = [] {
        didSet {
            updateTableHeight()
            creditInformationTableView.reloadData()
            saveButton.hideLoader()
        }
    }
    
    private let rowHeight: CGFloat
    private var tableViewHeight = NSLayoutConstraint()
    private var creditCardNumber: String?
    private var bankAccountNumber: String?
    private var topView: UIView?
    
    private var headerTitleLabel: UILabel = {
       var label = UILabel()
        label.configure(text: "", fontSize: 12, textColor: .mediumGrayColor, textAlignment: .right, fontType: .regular)
        label.numberOfLines = 0
        label.alpha = 0
        return label
    }()
    
    private lazy var creditInformationTableView: UITableView = {
        let tableView = UITableView()
        tableView.bounces = false
        tableView.separatorStyle = .none
        tableView.allowsSelection = true
        tableView.allowsMultipleSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        tableView.alpha = 0
        return tableView
    }()
    
    private var saveButton: LoadingButton = {
       var button = LoadingButton()
        button.configure(fontSize: 12, title: "CreditCardsBankAccountsTableView.saveButtonTitle".localized, fontType: .regular, titleColor: .backgroundColor, backgroundColor: .rejectOrangeColor, borderColor: .clear, cornerRadius: 15)
        button.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        button.indicator = BallPulseSyncIndicator(color: .gray)
        button.cornerRadius  = 15
        button.bgColor = .rejectOrangeColor
        button.indicator.color = .cardsColor
        button.alpha = 0
        return button
    }()
    
    weak var delegate: BankInfoDelegate?
    
    //MARK: - DEFAULT INIT
    private let screenType: BankInformationType
    
    init(type: BankInformationType) {
        self.screenType = type
        if type == .account {
            self.rowHeight = 90
        } else if type == .credit {
            self.rowHeight = 100
        } else {
            self.rowHeight = 110
        }
        super.init(frame: .zero)
        layer.cornerRadius = 10
        backgroundColor = .cardsColor
        clipsToBounds = true
        createUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - CREATE UI
    private func createUI() {
        if screenType == .account || screenType == .credit {
            headerTextConfig()
            addingHeaderTitleLabel()
            addingTableView(padding: 20)
            addingSaveButton()
        } else {
            topView = self
            addingTableView()
        }
    }
    
    private func addingHeaderTitleLabel() {
        addSubview(headerTitleLabel)
        headerTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            headerTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            headerTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15)
        ])
        topView = headerTitleLabel
    }
    
    private func addingTableView(padding: CGFloat = 0) {
        addSubview(creditInformationTableView)
        creditInformationTableView.translatesAutoresizingMaskIntoConstraints = false
        if topView == self {
            creditInformationTableView.topAnchor.constraint(equalTo: topView!.topAnchor, constant: padding).isActive = true
        } else {
            creditInformationTableView.topAnchor.constraint(equalTo: topView!.bottomAnchor, constant: padding).isActive = true
        }
        NSLayoutConstraint.activate([
            creditInformationTableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            creditInformationTableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
        ])
        tableViewHeight = creditInformationTableView.heightAnchor.constraint(equalToConstant: 0)
        tableViewHeight.isActive = true
        
        
        creditInformationTableView.register(BankInfoTableViewCell.self, forCellReuseIdentifier: BankInfoTableViewCell.identifier)
        creditInformationTableView.delegate = self
        creditInformationTableView.dataSource = self
    }
    
    private func addingSaveButton() {
        addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: creditInformationTableView.bottomAnchor, constant: 20),
            saveButton.widthAnchor.constraint(equalToConstant: 100),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            saveButton.centerXAnchor.constraint(equalTo: creditInformationTableView.centerXAnchor)
        ])
    }
    
    private func headerTextConfig() {
        if screenType == .credit {
            headerTitleLabel.text = "CreditCardsBankAccountsTableView.creditTitle".localized
        } else {
            headerTitleLabel.text = "CreditCardsBankAccountsTableView.accountTitle".localized
        }
    }
    
    private func updateTableHeight() {
        let height = CGFloat(bankInfoViewModel.count) * rowHeight
        delegate?.tableHeight(type: self.screenType, height: height)
        tableViewHeight.constant = height
        UIView.animate(withDuration: 1) {
            self.creditInformationTableView.alpha = 1
            self.saveButton.alpha = 1
            self.headerTitleLabel.alpha = 1
        }
    }
    
    //MARK: - OBJC FUNCTIONS
    @objc func saveButtonPressed() {
        saveButton.showLoader(userInteraction: false)
        if screenType == .account {
            guard let bankAccount = bankAccountNumber, bankAccount.count == 24 else {
                Popup.showError(body: "CreditCardsBankAccountsTableView.bankAccount".localized)
                saveButton.hideLoader()
                return
            }
            delegate?.newCreditOrBankAccount(type: self.screenType, with: "IR\(bankAccount)")
        } else {
            guard let cardNumber = creditCardNumber, cardNumber.count == 16 else {
                Popup.showError(body: "CreditCardsBankAccountsTableView.cardNumberWarn".localized)
                saveButton.hideLoader()
                return
            }
            delegate?.newCreditOrBankAccount(type: self.screenType, with: cardNumber)
        }
        saveButton.autoHideLoader()
    }
}

extension BankInfoTableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bankInfoViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BankInfoTableViewCell.identifier, for: indexPath) as! BankInfoTableViewCell
        cell.type = self.screenType
        cell.bankInfoViewModel = bankInfoViewModel[indexPath.row]
        cell.delegate = self
        cell.selectionStyle = .none
        return cell
    }
}

extension BankInfoTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 0.3) {
            cell.alpha = 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
}

extension BankInfoTableView: BankInfoDelegate {
    func deleteBankInfoPressed(type: BankInformationType, item: BankInfoAdapter) {
        delegate?.deleteBankInfoPressed(type: type, item: item)
    }
    
    func infoFieldNumber(type: BankInformationType, number: String) {
        if type == .account {
            bankAccountNumber = number.keepNumbers()
        } else {
            creditCardNumber = number
        }
    }
}
