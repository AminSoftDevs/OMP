//
//  DepositOnRialWalletViewModel.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 10/2/21.
//

import UIKit

protocol DepositOnRialWalletViewModelProtocol: AnyObject {
    func creditCardsListReceived()
    func transferToBank(with urlString: String)
}

class DepositOnRialWalletViewModel {
    
    var creditCards: [CreditCard] = []
    var selectedCreditCardIndex: Int = 0
    var amountValue: String  = ""
    
    var screenTitle: String {
        return "deposit".localized + " " + "asRial".localized
    }
    
    var creditCardsNumberOnly: [String] {
        return creditCards.map({ $0.card.convertEngNumToPersianNum()})
    }
    
    var selectedCardID: String {
        return String(creditCards[selectedCreditCardIndex].id)
    }
    
    weak var delegate: DepositOnRialWalletViewModelProtocol?
    
    //MARK: - INITIALIZER
    private let wallet: Wallet
    
    init(wallet: Wallet) {
        self.wallet = wallet
    }
    //MARK: - FUNCTIONS
    func changeValueFieldFormat(text: String) -> String {
        let pureText = text.persianToEng().removeComma
        amountValue = "\(pureText.toInt * 10)"
        return pureText.toDouble.formattedWithSeparator.convertEngNumToPersianNum()
    }
    
    func paymentButtonPressed() {
        prepareRialDepositAPI()
    }
    
    func getDestinationViewController() -> UIViewController {
        return DepositHistoryViewController.makeInstance(wallet: wallet)
    }
    
    //MARK: - Credit Cards List API
    func prepareRialDepositAPI() {
        guard amountValue.isEmpty == false else {
            Popup.showError(body: "DepositOnRialWalletViewModel.amountMustNotBeEmpty".localized)
            return
        }
        
        Preloader.sharedInstance.startLoading()
        PrepareRialDepositService.prepareRialDeposit(request: .init(cardID: selectedCardID, amount: amountValue.removeZeroFromEnd)) { [weak self] results in
            Preloader.sharedInstance.stopLoading()
            guard let self = self else { return }
            switch results {
            case let .success(responseReceived):
                switch responseReceived {
                case let .success(response: responseModel):
                    self.delegate?.transferToBank(with: responseModel.data.url)
                case let .validation(error: errorModel):
                    var errorMessage = ""
                    if let cardIDError  = errorModel.errors.cardID {
                        errorMessage =  cardIDError.createErrorMessage() + "\n"
                    }
                    if let amountError = errorModel.errors.amount {
                        errorMessage += amountError.createErrorMessage()
                    }
                    Popup.showError(body: errorMessage)
                }
            case let .failure(error):
                Popup.showError(body: error.localizedStrings)
            }
        }
    }
    
    func getCreditCardsListAPI() {
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
}
