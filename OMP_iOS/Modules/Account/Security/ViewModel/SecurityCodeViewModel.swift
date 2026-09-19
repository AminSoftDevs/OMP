//
//  SecurityCodeViewModel.swift
//  OMP_iOS
//
//  Created by AminSoft on 9/10/1400 AP.
//

import Foundation
import LocalAuthentication

protocol AuthenticationUserProtocol: AnyObject {
    func userAuthenticationSuccess()
    func userAuthenticationFailed()
    func userAuthenticationNotConfigured()
}

class SecurityCodeViewModel {
    
    var numberArrayData: [String] {
        return ["1", "2", "3", "4", "5", "6", "7", "8", "9", "", "0", ""]
    }
    
    var numberOfItems: Int {
        return self.numberArrayData.count
    }
    
    var securityCode: String {
        return KeychainData.securityCode
    }
    
    var codeLabelTitle: String {
        return "SecurityViewController.inputSecurityCode".localized
    }
    
    var editSecurityCodeTitle: String {
        return "SecurityViewController.editSecurityCode".localized
    }
    
    var forgottenCodeTitle: String {
        return "SecurityViewController.forgottenPasswordCode".localized
    }
    
    var enterNewPasswordTitle: String {
        return "SecurityViewController.enterNewPassword".localized
    }
    
    var operationIsDone: String {
        return "SecurityViewController.acceptSecurityCodeDone".localized
    }
    
    var correctPasswordTitle: String {
        return "SecurityViewController.correctSecurityCode".localized
    }
    
    func canEvaluatePolicy() -> Bool {
        return LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    // DELEGATE
    weak var delegate: AuthenticationUserProtocol?
    
    func authenticationUser() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [weak self] success, authenticationError in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    if success {
                        self.delegate?.userAuthenticationSuccess()
                    } else {
                        self.delegate?.userAuthenticationFailed()
                    }
                }
            }
        } else {
            delegate?.userAuthenticationNotConfigured()
        }
    }
}

