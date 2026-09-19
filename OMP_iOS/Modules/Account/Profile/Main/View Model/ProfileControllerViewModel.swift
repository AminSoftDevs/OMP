//
//  ProfileControllerViewModel.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 12/14/21.
//

import UIKit

protocol ProfileControllerViewModelProtocol: AnyObject {
    func editPasswordButtonPressed()
    func creditCardTemplateOnScreen(status: Bool)
    func storedCreditCardsTableHeight(height: CGFloat)
    func newBankInfoAdded(type: BankInformationType ,number: String)
    func deleteBankInfo(type: BankInformationType, item : BankInfoAdapter)
    func creditCardsListReceived()
    func bankAccountListReceived()
}

class ProfileControllerViewModel {
    
    private let personalInfoHeight: CGFloat = 260
    private let editPasswordHeight: CGFloat = 80
    private let accountStateHeight: CGFloat = 260
    
    var bankInfoHeight: CGFloat = 270
    
    var numberOfRows: Int {
        return 4
    }
    var navigationTitle: String {
        return "ProfileViewController.navTitle".localized
    }
    
    var getUserInfo: UserInfo? {
        return userInfo
    }
    
    private var creditCards: [CreditCard] = []
    private var bankAccounts: [Iban] = []
    
    var getCreditCards: [BankInfoAdapter] {
        let cards = creditCards.map({ BankInfo(id: $0.id, card: $0.card, account: nil, name: $0.name, verified: $0.verified, created_at: $0.createdAt, type: .credit)})
        return cards.map({ BankInfoAdapter(bankInfo: $0)})
    }
    
    var getBankAccounts: [BankInfoAdapter] {
        let accounts = bankAccounts.map({ BankInfo(id: $0.id, card: nil, account: $0.iban, name: "", verified: $0.verified, created_at: $0.createdAt, type: .account)})
        return accounts.map({ BankInfoAdapter(bankInfo: $0)})
    }

    weak var delegate: ProfileControllerViewModelProtocol?
    
    //MARK: - INITIALIZER
    private let userInfo: UserInfo?
    
    init(userInfo: UserInfo?) {
        self.userInfo = userInfo
    }
    
    //MARK: - FUNCTIONS
    func getItemSizeFor(indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        switch indexPath.row {
        case 0:
            return CGSize(width: width, height: personalInfoHeight)
        case 1:
            return CGSize(width: width, height: editPasswordHeight)
        case 2:
            return CGSize(width: width, height: accountStateHeight)
        case 3:
            return CGSize(width: width, height: bankInfoHeight)
        default:
            return CGSize(width: width, height: 50)
        }
    }
    
    //MARK: - API
    func addNewCreditCard(with number: String) {
        AddNewCreditCardService.addNewCreditCardRequest(request: .init(card: number)) { [weak self] results in
            guard let self = self else { return }
            switch results {
            case let .success(success):
                switch success {
                case .success(response: _):
                    self.getCreditCardsList()
                case let .validation(error: errorModel):
                    if let cardNumberError  = errorModel.errors.card {
                        Popup.showError(body: cardNumberError.createErrorMessage())
                    }
                }
            case let .failure(error):
                Popup.showError(body: error.localizedStrings)
            }
        }
    }
    
    func getCreditCardsList() {
        CreditCardsService.getCreditCards { [weak self] results in
            guard let self = self else { return }
            switch results {
            case let .success(success):
                switch success {
                case let.success(response: responseModel):
                    self.creditCards = responseModel.data
                    self.delegate?.creditCardsListReceived()
                case let .validation(error: errorModel):
                    print(errorModel)
                }
            case let .failure(error):
                Popup.showError(body: error.localizedStrings)
            }
        }

    }
    
    func getBankAccountList() {
        iBankListService.getIBanList { [weak self] results in
            guard let self = self else { return }
            switch results {
            case let .success(success):
                switch success {
                case let .success(response: responseModel):
                    self.bankAccounts = responseModel.data
                    self.delegate?.bankAccountListReceived()
                case let .validation(error: errorModel):
                    print(errorModel)
                }
            case let .failure(error):
                Popup.showError(body: error.localizedStrings)
            }
        }
    }
    
    func deleteCreditCard(with id: String) {
        DeleteCreditCardService.deleteCreditCardRequest(request: .init(id: id)) { [weak self] results in
            guard let self = self else { return }
            switch results {
            case let .success(response):
                switch response {
                case .success(response: _):
                    self.getCreditCardsList()
                case let .validation(error: errorModel):
                    if let idError  = errorModel.errors.id {
                        Popup.showError(body: idError.createErrorMessage())
                    }
                }
            case let .failure(error):
                Popup.showError(body: error.localizedStrings)
            }
        }
    }
    
    func addNewBankAccount(with number: String) {
        AddNewBankAccountService.addNewBankAccountRequest(request: .init(iban: "IR" + number)) { [weak self] results in
            guard let self = self else { return }
            switch results {
            case let .success(success):
                switch success {
                case .success(response: _):
                    self.getBankAccountList()
                case let .validation(error: errorModel):
                    if let bankAccountError  = errorModel.errors.iban {
                        Popup.showError(body: bankAccountError.createErrorMessage())
                    }
                }
            case let .failure(error):
                Popup.showError(body: error.localizedStrings)
            }
        }
    }
    
    func deleteBankAccount(with id: String) {
        DeleteBankAccountService.deleteBankAccountRequest(request: .init(id: id)) { [weak self] results in
            guard let self = self else { return }
            switch results {
            case let .success(response):
                switch response {
                case .success(response: _):
                    self.getBankAccountList()
                case let .validation(error: errorModel):
                    if let idError  = errorModel.errors.id {
                        Popup.showError(body: idError.createErrorMessage())
                    }
                }
            case let .failure(error):
                Popup.showError(body: error.localizedStrings)
            }
        }
    }
}
