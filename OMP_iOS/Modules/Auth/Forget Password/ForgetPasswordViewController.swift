//
//  ForgetPasswordViewController.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 7/31/21.
//

import UIKit

class ForgetPasswordViewController: BaseViewController {

    lazy var authNavigationView: AuthNavigationView = {
       var view = AuthNavigationView()
        view.navigationTitle = "فراموشی کلمه عبور".localized
        view.delegate = self
        return view
    }()
    
    lazy var forgetPasswordView: ForgetPasswordView = {
       var view = ForgetPasswordView()
        view.delegate = self
        return view
    }()
    
    //MARK: - VIEW CONTROLLER LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackgroundColor(.cardsColor)
        self.createUI()
    }
    
    //MARK: - CREATE UI
    fileprivate func createUI() {
        self.addingAuthenticationNavigationView()
        self.addingForgetPasswordView()
    }
    
    fileprivate func addingAuthenticationNavigationView() {
        self.view.addSubview(authNavigationView)
        self.authNavigationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: authNavigationView, attribute: .top, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: authNavigationView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: authNavigationView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: authNavigationView, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0, constant: 60).isActive = true
    }
    
    fileprivate func addingForgetPasswordView() {
        self.view.addSubview(forgetPasswordView)
        self.forgetPasswordView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: forgetPasswordView, attribute: .top, relatedBy: .equal, toItem: self.authNavigationView, attribute: .bottom, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: forgetPasswordView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: forgetPasswordView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: forgetPasswordView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    }
}

//MARK: - API
extension ForgetPasswordViewController {
    func requestForPasswordRecovery(with email: String) {
        ResetPasswordService.resetPasswordRequest(request: .init(email: email)) { [weak self] results in
            guard let self = self else { return }
            self.forgetPasswordView.stopSubmitButtonAnimating = true
            switch results {
            case let .success(response):
                switch response {
                case let .success(response: responseModel):
                    self.forgetPasswordView.emailSentSuccessfully = true
                    self.forgetPasswordView.resetPasswordMessage = responseModel.data.message
                case let .validation(error: errorModel):
                    if let error = errorModel.errors.email {
                        Popup.showError(body: error.createErrorMessage())
                    }
                }
            case let .failure(error):
                Popup.showError(body: error.localizedStrings)
            }
        }
    }
}

extension ForgetPasswordViewController: AuthNavigationDelegate {
    func backButtonPressed() {
        self.forgetPasswordView.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
}

extension ForgetPasswordViewController: ForgetPasswordViewDelegate {
    func submitButtonPressed(email: String) {
        self.requestForPasswordRecovery(with: email)
    }
    
    func backToLoginButtonPressed() {
        self.forgetPasswordView.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
}
