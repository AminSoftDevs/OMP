//
//  BankInformationView.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 8/14/21.
//

import UIKit

class BankInformationView: UIView {
    
    var cardList: [BankInfoAdapter] = [] {
        didSet {
            self.creditCardsTableView.bankInfoViewModel = cardList
        }
    }
    
    var bankAccountList: [BankInfoAdapter] = [] {
        didSet {
            self.bankAccountTableView.bankInfoViewModel = bankAccountList
        }
    }
    
    lazy var mainScrollView: UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    lazy var continueButton: UIButton = {
       var button = UIButton()
        button.configure(fontSize: 12, title: "BankInformationView.continue".localized, fontType: .regular, titleColor: .backgroundColor, backgroundColor: .submitButtonColor, borderColor: .clear, cornerRadius: 10)
        button.addTarget(self, action: #selector(continueButtonPressed), for: .touchUpInside)
        button.alpha = 0
        return button
    }()
    
    let utility = BaseModule.sharedInstance
    var creditCardsTableViewHeight = NSLayoutConstraint()
    var bankAccountTableViewHeight = NSLayoutConstraint()
    
    let firstViewHeight: CGFloat = 220
    let secondViewHeight: CGFloat = 220
    let continueButtonHeight: CGFloat = 70
    
    lazy var creditCardsTableView: BankInfoTableView = BankInfoTableView(type: .credit)
    lazy var bankAccountTableView: BankInfoTableView = BankInfoTableView(type: .account)
    
    weak var delegate: BankInfoDelegate?
    
    //MARK: - DEFAULT INITIALIZER
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - CREATE UI
    fileprivate func createUI() {
        self.addingMainScrollView()
        self.addingCreditCardsTableView()
        self.addingBankAccountsTableView()
        self.addingContinueButton()
        self.mainScrollView.contentSize.height = firstViewHeight + secondViewHeight + 40 + continueButtonHeight
    }
    
    fileprivate func addingMainScrollView() {
        self.addSubview(mainScrollView)
        self.mainScrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: mainScrollView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: mainScrollView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: mainScrollView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: mainScrollView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    }
    
    fileprivate func addingCreditCardsTableView() {
        self.mainScrollView.addSubview(creditCardsTableView)
        self.creditCardsTableView.delegate = self
        self.creditCardsTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: creditCardsTableView, attribute: .top, relatedBy: .equal, toItem: mainScrollView, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: creditCardsTableView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: creditCardsTableView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        creditCardsTableViewHeight = NSLayoutConstraint(item: creditCardsTableView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 0)
        creditCardsTableViewHeight.isActive = true
        
        self.creditCardsTableView.delegate = self
    }
    
    fileprivate func addingBankAccountsTableView() {
        self.mainScrollView.addSubview(bankAccountTableView)
        self.bankAccountTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: bankAccountTableView, attribute: .top, relatedBy: .equal, toItem: creditCardsTableView, attribute: .bottom, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: bankAccountTableView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: bankAccountTableView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        bankAccountTableViewHeight = NSLayoutConstraint(item: bankAccountTableView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 0)
        bankAccountTableViewHeight.isActive = true
        
        self.bankAccountTableView.delegate = self
    }
    
    fileprivate func addingContinueButton() {
        self.mainScrollView.addSubview(continueButton)
        self.continueButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: continueButton, attribute: .top, relatedBy: .equal, toItem: bankAccountTableView, attribute: .bottom, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: continueButton, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 30).isActive = true
        NSLayoutConstraint(item: continueButton, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -30).isActive = true
        NSLayoutConstraint(item: continueButton, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 50).isActive = true
    }
    
    //MARK: - FUNCTIONS
    fileprivate func changeCreditTableViewHeight(with height: CGFloat) {
        UIView.animate(withDuration: 0.6) {
            self.creditCardsTableViewHeight.constant = height + self.firstViewHeight
            self.layoutIfNeeded()
        } completion: { _ in
            self.mainScrollView.contentSize.height = self.creditCardsTableViewHeight.constant + self.bankAccountTableViewHeight.constant + 40 + self.continueButtonHeight
        }
    }
    
    fileprivate func changeAccountTableViewHeight(with height: CGFloat) {
        UIView.animate(withDuration: 0.6) {
            self.bankAccountTableViewHeight.constant = height + self.secondViewHeight
            self.layoutIfNeeded()
            self.continueButton.alpha = 1
        } completion: { _ in
            self.mainScrollView.contentSize.height = self.creditCardsTableViewHeight.constant + self.bankAccountTableViewHeight.constant + 40 + self.continueButtonHeight
        }
    }
    
    //MARK: - OBJC FUNCTIONS
    @objc func continueButtonPressed() {
        if cardList.count < 2 {
            utility.notification.show(title: "", body: "BankInformationView.oneCardAtLeast".localized, .error, "error", 2.0)
            return
        } else if bankAccountList.count < 2 {
            utility.notification.show(title: "", body: "BankInformationView.oneAccountAtLeast".localized, .error, "error", 2.0)
            return
        } else {
            delegate?.continueButtonPressed()
        }
    }
}

extension BankInformationView: BankInfoDelegate {
    func tableHeight(type: BankInformationType, height: CGFloat) {
        if type == .credit {
            self.changeCreditTableViewHeight(with: height)
        } else {
            self.changeAccountTableViewHeight(with: height)
        }
    }
    
    func newCreditOrBankAccount(type: BankInformationType, with number: String) {
        delegate?.newCreditOrBankAccount(type: type, with: number)
    }
}
