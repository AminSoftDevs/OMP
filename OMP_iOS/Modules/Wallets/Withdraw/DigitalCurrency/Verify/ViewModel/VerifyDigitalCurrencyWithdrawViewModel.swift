//
//  VerifyDigitalCurrencyWithdrawViewModel.swift
//  OMP_iOS
//
//  Created by AminSoft on 7/20/1400 AP.
//

import Foundation

protocol VerifyDigitalCurrencyWithdrawViewModelProtocol: AnyObject {
    func shouldShowGoogleAuthField()
}

class VerifyDigitalCurrencyWithdrawViewModel {
    
    private let withdrawItem: DigitalWithdrawService.Response
    
    var wallet: Wallet
    
    var withdrawCurrencyName: String {
        return wallet.walletName
    }
    var verifyCode: String?
    
    var googleAuthCode: Int?
    
    var currencyId: String {
        return wallet.walletId
    }
    
    var titleMessage: String {
        withdrawItem.message ?? ""
    }
    
    weak var delegate: VerifyDigitalCurrencyWithdrawViewModelProtocol?
    
    init(withdraw: DigitalWithdrawService.Response, wallet: Wallet) {
        self.withdrawItem = withdraw
        self.wallet = wallet
    }
    
    func verifyDigitalWithdraw(completion: @escaping (Bool) -> ()) {
        
        guard let code = verifyCode, !code.isEmpty else {
            Popup.showError(body: "Withdraw.pleaseFillTheVerifyCode".localized)
            return
        }
        
        DigitalWithdrawVerification.digitalWithdrawVerification(id: currencyId, request: .init(id: withdrawItem.data.id, code: verifyCode, googleAuthCode: googleAuthCode)) { [weak self] results in
            guard let self = self else { return }
            
            switch results {
            case let .success(responseReceived):
                switch responseReceived {
                    
                case let .success(response: responseModel):
                    if let responseMessage = responseModel.message {
                        Popup.showSuccess(body: responseMessage)
                        completion(true)
                    } else {
                        completion(false)
                    }
                    
                case let .validation(error: errorModel):
                    var errorMessage = ""
                    
                    if errorModel.status.contains("GOOGLE_AUTH") {
                        
                        self.delegate?.shouldShowGoogleAuthField()
                        
                        guard let googleAuthCode = self.googleAuthCode, (googleAuthCode != 0) else {
                            Popup.showError(body: "Withdraw.pleaseFillTheGoogleAuthCode".localized)
                            return
                        }
                    }
                    
                    if let code = errorModel.errors.code {
                        errorMessage =  code.createErrorMessage() + "\n"
                    }
                    
                    if let googleAuthCode = errorModel.errors.googleAuthCode {
                        errorMessage += googleAuthCode.createErrorMessage()
                    }
                    
                    if let id = errorModel.errors.id {
                        errorMessage += "\n" + id.createErrorMessage()
                    }
                    Popup.showError(body: errorMessage)
                }
                
            case let .failure(error):
                completion(false)
                Popup.showError(body: error.localizedStrings)
            }
        }
    }
}
