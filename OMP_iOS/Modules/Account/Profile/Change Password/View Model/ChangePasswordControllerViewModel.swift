//
//  ChangePasswordControllerViewModel.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 12/13/21.
//

import Foundation

class ChangePasswordControllerViewModel {
    
    var currentPassword: String?
    var newPassword: String?
    var repeatNewPassword: String?
    
    var changePasswordButtonTitle: String {
        return "EditPasswordViewController.changePassword".localized
    }
    var navigationTitle: String {
        return "EditPasswordViewController.navTitle".localized
    }
    
    var hideSubmitButtonLoader: (() -> ())?
    
    //MARK: - FUNCTIONS
    func handleUserInputs(input: String, type: UserInputType) {
        switch type {
        case .currentPassword:
            currentPassword = input
        case .newPassword:
            newPassword = input
        case .repeatNewPassword:
            repeatNewPassword = input
        default:
            break
        }
    }
    
    func checkToChangePassword() {
        guard let current = currentPassword, current != "" else {
            Popup.showError(body: "EditPasswordViewController.currentCan'tBeEmpty".localized)
            hideSubmitButtonLoader?()
            return
        }
        
        guard let new = newPassword, new !=  "" else {
            Popup.showError(body: "EditPasswordViewController.newCan'tBeEmpty".localized)
            hideSubmitButtonLoader?()
            return
        }
        
        if new.count < 8 {
            Popup.showError(body: "passwordLimit".localized)
            return
        }
        
        guard let repeatNew = repeatNewPassword, repeatNew != "" else {
            Popup.showError(body: "EditPasswordViewController.repeatCan'tBeEmpty".localized)
            hideSubmitButtonLoader?()
            return
        }
        
        guard new == repeatNew else {
            Popup.showError(body: "EditPasswordViewController.oldAndNewAreNotSame".localized)
            hideSubmitButtonLoader?()
            return
        }
        
        changePassword(oldPassword: current, newPassword: new)
    }
    
    //MARK: - API
    private func changePassword(oldPassword: String, newPassword: String) {
        ChangePasswordService.changePassword(request: .init(newPassword: newPassword, oldPassword: oldPassword)) { [weak self] results in
            self?.hideSubmitButtonLoader?()
            switch results {
            case let .success(response):
                switch response {
                case let .success(response: responseModel):
                    Popup.showSuccess(body: responseModel.message ?? "")
                case let .validation(error: errorModel):
                    var errorMessage = ""
                    if let newPasswordError  = errorModel.errors.newPassword {
                        errorMessage =  newPasswordError.createErrorMessage() + "\n"
                    }
                    if let oldPasswordError = errorModel.errors.oldPassword {
                        errorMessage += oldPasswordError.createErrorMessage()
                    }
                    Popup.showError(body: errorMessage)
                }
            case let .failure(error):
                Popup.showError(body: error.localizedStrings)
            }
        }
    }
}
