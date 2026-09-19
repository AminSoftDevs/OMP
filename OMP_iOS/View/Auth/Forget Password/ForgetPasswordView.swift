//
//  ForgetPasswordView.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 7/31/21.
//

import Foundation
import UIKit
import MHLoadingButton

protocol ForgetPasswordViewDelegate: AnyObject {
    func submitButtonPressed(email: String)
    func backToLoginButtonPressed()
}

class ForgetPasswordView: UIView {
    
    let utility = BaseModule.sharedInstance
    
    var stopSubmitButtonAnimating: Bool = false {
        didSet {
            if stopSubmitButtonAnimating  {
                self.submitButton.hideLoader()
            }
        }
    }
    
    var resetPasswordMessage: String?  {
        didSet {
            self.successLabel.text = resetPasswordMessage
        }
    }
    
    var emailSentSuccessfully: Bool = false {
        didSet {
            self.updateUI()
        }
    }
    
    lazy var emailTitleLabel: UILabel = {
       let label = UILabel()
        label.configure(text: "", fontSize: 14, textColor: .textColor, textAlignment: .right, fontType: .regular)
        label.text = "forgetPassword.email".localized
        return label
    }()
    
    lazy var emailTextField: TextFieldWithPadding = {
        let textField = TextFieldWithPadding()
        textField.configure(placeholder: "", borderColor: .clear , fontSize: 13, fontType: .regular, keyboardType: .emailAddress, textAlignment: .left, radius: 10, backgroundColor: .backgroundColor, textColor: .textColor)
        textField.delegate = self
        textField.tag = 100
        textField.returnKeyType = .next
        textField.autocorrectionType = .no
        textField.textPadding = .init(top: 5, left: 0, bottom: 0, right: 0)
        return textField
    }()
    
    lazy var submitButton: LoadingButton = {
       var button = LoadingButton()
        button.configure(fontSize: 14, title: "", fontType: .regular, titleColor: .cardsColor, backgroundColor: .submitButtonColor, borderColor: .clear, cornerRadius: 10)
        button.setTitle("forgetPassword.submitButton".localized, for: .normal)
        button.addTarget(self, action: #selector(submitButtonPressed), for: .touchUpInside)
        button.indicator = BallPulseSyncIndicator(color: .gray)
        button.cornerRadius  = 10
        button.bgColor = .submitButtonColor
        button.indicator.color = .cardsColor
        return button
    }()
    
    lazy var loginButton: UIButton = {
       var button = UIButton()
        button.configure(fontSize: 15, title: "", fontType: .regular, titleColor: .rejectOrangeColor, backgroundColor: .clear, borderColor: .clear, cornerRadius: 0)
        button.setTitle("forgetPassword.loginButton".localized, for: .normal)
        button.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var checkBoxImageView: UIImageView = {
       var imageView = UIImageView()
        imageView.image = UIImage(named: "success_checkBox_icon")
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0
        return imageView
    }()
    
    lazy var successLabel: UILabel = {
        var label = UILabel()
        label.configure(text: "", fontSize: 14, textColor: .init(hex: "55E0B3"), textAlignment: .center, fontType: .bold)
        label.alpha = 0
        return label
    }()
    
    weak var delegate: ForgetPasswordViewDelegate?
    
    //MARK: - DEFAULT INITIALIZER
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.emailTextField.becomeFirstResponder()
        }
    }
    
    //MARK: - CREATE UI
    fileprivate func createUI() {
        self.addingEmailTitleLabel()
        self.addingEmailTextField()
        self.addingSubmitButton()
        self.addingLoginButton()
        self.addingRecoveryEmailSentSuccessfullyState()
    }
    
    fileprivate func addingEmailTitleLabel() {
        self.addSubview(emailTitleLabel)
        self.emailTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: emailTitleLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: emailTitleLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -22).isActive = true
    }
    
    fileprivate func addingEmailTextField() {
        self.addSubview(emailTextField)
        self.emailTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: emailTextField, attribute: .top, relatedBy: .equal, toItem: self.emailTitleLabel, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: emailTextField, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: emailTextField, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: emailTextField, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 50).isActive = true
    }

    fileprivate func addingSubmitButton() {
        self.addSubview(submitButton)
        self.submitButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: submitButton, attribute: .top, relatedBy: .equal, toItem: self.emailTextField, attribute: .bottom, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: submitButton, attribute: .trailing, relatedBy: .equal, toItem: self.emailTextField, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: submitButton, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: submitButton, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 50).isActive = true
    }
   
    fileprivate func addingLoginButton() {
        self.addSubview(loginButton)
        self.loginButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: loginButton, attribute: .top, relatedBy: .equal, toItem: self.submitButton, attribute: .bottom, multiplier: 1, constant: 30).isActive = true
        NSLayoutConstraint(item: loginButton, attribute: .centerX, relatedBy: .equal, toItem: self.submitButton, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    }
    
    fileprivate func addingRecoveryEmailSentSuccessfullyState() {
        self.addSubview(checkBoxImageView)
        self.checkBoxImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: checkBoxImageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: checkBoxImageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: checkBoxImageView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0, constant: 40).isActive = true
        NSLayoutConstraint(item: checkBoxImageView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 40).isActive = true
        
        self.addSubview(successLabel)
        self.successLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: successLabel, attribute: .top, relatedBy: .equal, toItem: self.checkBoxImageView, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: successLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: successLabel, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: successLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 30).isActive = true
    }
    
    //MARK: - FUNCTIONS
    fileprivate func updateUI() {
        UIView.animate(withDuration: 0.3) {
            self.emailTextField.alpha = 0
            self.emailTitleLabel.alpha = 0
            self.submitButton.alpha = 0
            self.loginButton.alpha = 0
        } completion: { _ in
            self.submitButton.setTitle("forgetPassword.backToLogin".localized, for: .normal)
            UIView.animate(withDuration: 0.2) {
                self.checkBoxImageView.alpha = 1
                self.successLabel.alpha = 1
                self.submitButton.alpha = 1
            }
        }
    }
    
    //MARK: - OBJC FUNCTIONS
    @objc func submitButtonPressed(_ sender: LoadingButton) {
        if emailSentSuccessfully == true {
            //true bashe yani email gerefte o mire login
            self.delegate?.backToLoginButtonPressed()
            return
        }
        sender.showLoader(userInteraction: false)
        guard let emailAddress = emailTextField.text, !emailAddress.isEmpty else {
            utility.notification.show(title: "", body: "emailIsEmpty".localized, .error, "error", 2.0)
            return
        }
        if emailAddress.isValidEmail == false {
            utility.notification.show(title: "", body: "emailValidation".localized, .error, "error", 2.0)
            return
        }
        self.emailTextField.endEditing(true)
        self.delegate?.submitButtonPressed(email: emailAddress)
    }
    
    @objc func loginButtonPressed() {
        //it's like to press back button
        self.delegate?.backToLoginButtonPressed()
    }
}

extension ForgetPasswordView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.submitButtonColor.cgColor
        textField.backgroundColor = .cardsColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 0
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.backgroundColor = .backgroundColor
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text! == "" {
            return false
        } else if textField.tag == 101 {
            emailTextField.resignFirstResponder()
            return true
        }else {
            return false
        }
    }
}
