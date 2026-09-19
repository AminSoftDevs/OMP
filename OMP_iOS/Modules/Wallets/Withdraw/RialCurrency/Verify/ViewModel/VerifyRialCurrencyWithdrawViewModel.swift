//
//  VerifyRialCurrencyWithdrawViewModel.swift
//  OMP_iOS
//
//  Created by AminSoft on 7/14/1400 AP.
//

import Foundation

class VerifyRialCurrencyWithdrawViewModel {
    
    private let withdrawItem:  RialWithdrawService.Response
    
    var verifyCode: String?
    
    var titleMessage: String {
        withdrawItem.message ?? ""
    }
    
    init(withdraw:  RialWithdrawService.Response) {
        self.withdrawItem = withdraw
    }
    
    func verifyRialWithdraw(completion: @escaping (Bool) -> ()) {
        guard let code = verifyCode, !code.isEmpty else {
            Popup.showError(body: "Withdraw.pleaseFillTheVerifyCode".localized)
            return completion(false)
        }
        
        RialWithdrawVerification.rialWithdrawVerifyRequest(request: .init(id: withdrawItem.data.id, code: code)) { results in
            switch results {
            case let .success(responseReceived):
                switch responseReceived {
                case let .success(response: responseModel):
                    Popup.showSuccess(body: responseModel.message ?? "")
                    completion(true)
                case let .validation(error: errorModel):
                    var errorMessage = ""
                    if let code  = errorModel.errors.code {
                        errorMessage =  code.createErrorMessage() + "\n"
                    }
                    if let id = errorModel.errors.id {
                        errorMessage += id.createErrorMessage()
                    }
                    Popup.showError(body: errorMessage)
                    completion(false)
                }
            case let .failure(error):
                print(error.localizedStrings)
                completion(false)
            }
        }
    }
}
