//
//  CreditCardsBankAccountsTableViewCell.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 8/14/21.
//

import UIKit

class BankInfoTableViewCell: UITableViewCell {

    var bankInfoViewModel: BankInfoAdapter? {
        didSet {
            self.updateUI()
        }
    }
    
    var type: BankInformationType? {
        didSet {
            self.createUI()
        }
    }
    
    private lazy var creditCardNumberView: CreditCardNumberView? = CreditCardNumberView(type: .credit)
    private lazy var accountNumberView: AccountNumberView?       = AccountNumberView(type: .account)
    private lazy var profileCreditView: ProfileBankInfoView = ProfileBankInfoView(type: .profileCredit)
    private lazy var profileAccountView: ProfileBankInfoView = ProfileBankInfoView(type: .profileAccount)
    weak var delegate: BankInfoDelegate?
    
    //MARK: - DEFAULT INITIALIZER
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        //self.createUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        creditCardNumberView?.removeFromSuperview()
        accountNumberView?.removeFromSuperview()
        creditCardNumberView = nil
        accountNumberView = nil
    }
    
    //MARK: - CREATE UI
    private func createUI() {
        if type == .credit {
            addingCreditCardNumberView()
        } else if type == .account {
            addingAccountNumberView()
        } else if type == .profileCredit {
            addingProfileCreditCardView()
        } else {
            addingProfileAccountView()
        }
    }
    
    private func addingCreditCardNumberView() {
        creditCardNumberView = CreditCardNumberView(type: .credit)
        creditCardNumberView?.delegate = self
        addSubview(creditCardNumberView!)
        creditCardNumberView?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            creditCardNumberView!.centerYAnchor.constraint(equalTo: centerYAnchor),
            creditCardNumberView!.centerXAnchor.constraint(equalTo: centerXAnchor),
            creditCardNumberView!.heightAnchor.constraint(equalTo: heightAnchor, constant: -20),
            creditCardNumberView!.widthAnchor.constraint(equalTo: widthAnchor)
        ])
    }
    
    private func addingAccountNumberView() {
        accountNumberView = AccountNumberView(type: .account)
        accountNumberView?.delegate = self
        addSubview(accountNumberView!)
        accountNumberView?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            accountNumberView!.centerYAnchor.constraint(equalTo: centerYAnchor),
            accountNumberView!.centerXAnchor.constraint(equalTo: centerXAnchor),
            accountNumberView!.heightAnchor.constraint(equalTo: heightAnchor, constant: -5),
            accountNumberView!.widthAnchor.constraint(equalTo: widthAnchor)
        ])
    }
    
    private func addingProfileCreditCardView() {
        addSubview(profileCreditView)
        profileCreditView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileCreditView.centerYAnchor.constraint(equalTo: centerYAnchor),
            profileCreditView.centerXAnchor.constraint(equalTo: centerXAnchor),
            profileCreditView.heightAnchor.constraint(equalTo: heightAnchor, constant: -15),
            profileCreditView.widthAnchor.constraint(equalTo: widthAnchor)
            
        ])
        profileCreditView.delegate = self
    }
    
    private func addingProfileAccountView() {
        addSubview(profileAccountView)
        profileAccountView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileAccountView.centerYAnchor.constraint(equalTo: centerYAnchor),
            profileAccountView.centerXAnchor.constraint(equalTo: centerXAnchor),
            profileAccountView.heightAnchor.constraint(equalTo: heightAnchor, constant: -15),
            profileAccountView.widthAnchor.constraint(equalTo: widthAnchor)
            
        ])
        profileAccountView.delegate = self
    }

    //MARK: - UPDATE UI
    private func updateUI() {
        guard let item = bankInfoViewModel else { return }
        if type == .credit {
            creditCardNumberView?.bankInfoViewModel = item
        } else if type == .account {
            accountNumberView?.bankInfoViewModel = item
        } else if type == .profileCredit {
            profileCreditView.bankInfoViewModel = item
        } else {
            profileAccountView.bankInfoViewModel = item
        }
    }
}

extension BankInfoTableViewCell: BankInfoDelegate {
    func deleteBankInfoPressed(type: BankInformationType, item: BankInfoAdapter) {
        delegate?.deleteBankInfoPressed(type: type, item: item)
    }
    func infoFieldNumber(type: BankInformationType, number: String) {
        delegate?.infoFieldNumber(type: type ,number: number)
    }
}
