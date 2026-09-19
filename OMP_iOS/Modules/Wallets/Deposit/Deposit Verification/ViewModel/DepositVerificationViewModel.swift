//
//  DepositVerificationViewModel.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 10/4/21.
//

import Foundation

protocol DepositVerificationProtocol: AnyObject {
    func messageReceived(message: String)
}

enum PaymentStatus: String {
    case success = "SUCCESS"
    case failed = "FAILED"
    case none
}

class DepositVerificationViewModel {
    
    var iconName: String {
       return status == .success ? "success_payment" : "failure_payment"
    }
    
    var title: String {
        return status == .success ? "successfulTransaction".localized : "failedTransaction".localized
    }
    
    weak var delegate: DepositVerificationProtocol?
    
    //MARK: - INITIALIZER
    
    private let status: PaymentStatus
    private let token: String
    
    init(status: PaymentStatus, token: String) {
        self.status = status
        self.token = token
    }
    
    //MARK: - API
    func rialDepositVerifyAPI() {
        RialDepositVerificationService.rialDepositVerify(request: .init(payToken: token)) { [weak self] results in
            guard let self = self else { return }
            switch results {
            case let .success(responseReceived):
                switch responseReceived {
                case let .success(response: responseModel):
                    self.delegate?.messageReceived(message: responseModel.data.message)
                case let .validation(error: errorModel):
                    Popup.showError(body: errorModel.errors.payToken.createErrorMessage())
                }
            case let .failure(error):
                print(error.localizedStrings)
            }
        }
    }
}
