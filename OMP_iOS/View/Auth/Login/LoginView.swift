//
//  LoginView.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 7/31/21.
//

import Foundation
import UIKit

protocol LoginViewDelegate: AnyObject {
    func buttonsActionHandler(action: ButtonsAction, email: String?, password: String?)
}

enum ButtonsAction {
    case login
    case forgetPassword
    case signup
}

class LoginView: UIView {
    
    let utility = BaseModule.sharedInstance
    let currentTheme = UserDefaults.standard.selectedTheme
    
    lazy var logoImageView: UIImageView = {
      let imageView = UIImageView()
        imageView.image = currentTheme == (.light) ? UIImage(named: "logo_white") : UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var emailTitleLabel: UILabel = {
       let label = UILabel()
        label.configure(text: "loginView.email".localized, fontSize: 14, textColor: .textColor, textAlignment: .right, fontType: .regular)
        return label
    }()
    
    lazy var emailTextField: TextFieldWithPadding = {
        let textField = TextFieldWithPadding()
        textField.configure(placeholder: "", borderColor: .clear , fontSize: 14, fontType: .regular, keyboardType: .emailAddress, textAlignment: .left, radius: 10, backgroundColor: .backgroundColor, textColor: .textColor)
        textField.delegate = self
        textField.tag = 100
        textField.returnKeyType = .next
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.textPadding = .init(top: 4, left: 10, bottom: 0, right: 0)
        return textField
    }()
    
    lazy var passwordTitleLabel: UILabel = {
       let label = UILabel()
        label.configure(text: "loginView.password".localized, fontSize: 14, textColor: .textColor, textAlignment: .right, fontType: .regular)
        return label
    }()
    
    lazy var passwordTextField: TextFieldWithPadding = {
        let textField = TextFieldWithPadding()
        textField.configure(placeholder: "", borderColor: .clear , fontSize: 14, fontType: .regular, keyboardType: .default, textAlignment: .left, radius: 10, backgroundColor: .backgroundColor, textColor: .textColor)
        textField.tag = 101
        textField.delegate = self
        textField.isSecureTextEntry = true
        textField.autocorrectionType = .default
        textField.autocapitalizationType = .none
        textField.textPadding = .init(top: 4, left: 40, bottom: 0, right: 0)
        return textField
    }()
    
    lazy var loginButton: UIButton = {
       var button = UIButton()
        button.configure(fontSize: 14, title: "", fontType: .regular, titleColor: .cardsColor, backgroundColor: .submitButtonColor, borderColor: .clear, cornerRadius: 10)
        button.setTitle("loginView.loginButton".localized, for: .normal)
        button.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var signupButton: UIButton = {
       var button = UIButton()
        button.configure(fontSize: 13, title: "", fontType: .regular, titleColor: .rejectOrangeColor, backgroundColor: .clear, borderColor: .clear, cornerRadius: 0)
        button.setTitle("loginView.signupButton".localized, for: .normal)
        button.addTarget(self, action: #selector(signupButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var forgetPasswordButton: UIButton = {
       var button = UIButton()
        button.configure(fontSize: 13, title: "", fontType: .regular, titleColor: .submitButtonColor, backgroundColor: .clear, borderColor: .clear, cornerRadius: 0)
        button.setTitle("loginView.forgetPassword".localized, for: .normal)
        button.addTarget(self, action: #selector(forgetPasswordButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var showPasswordButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "hide_password_icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.setImage(UIImage(named: "show_password_icon")?.withRenderingMode(.alwaysTemplate), for: .selected)
        button.tintColor = .textColor
        button.addTarget(self, action: #selector(hideAndShowPasswordButtonPressed), for: .touchUpInside)
        return button
    }()
    
    weak var delegate: LoginViewDelegate?
    
    //MARK: - DEFAULT INITIALIZER
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createUI()
        self.passwordTextField.keyboardDistanceFromTextField = 70
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.emailTextField.becomeFirstResponder()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - CREATE UI
    fileprivate func createUI() {
        self.addingLogoImageView()
        self.addingEmailTitleLabel()
        self.addingEmailTextField()
        self.addingPasswordTitleLabel()
        self.addingPasswordTextField()
        self.addingLoginButton()
        self.addingForgetPasswordButton()
        self.addingSignupButton()
        self.addingShowPasswordButton()
    }
    
    fileprivate func addingLogoImageView() {
        self.addSubview(logoImageView)
        self.logoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: logoImageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 40).isActive = true
        NSLayoutConstraint(item: logoImageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: logoImageView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: -80).isActive = true
        NSLayoutConstraint(item: logoImageView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 60).isActive = true
    }
    
    fileprivate func addingEmailTitleLabel() {
        self.addSubview(emailTitleLabel)
        self.emailTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: emailTitleLabel, attribute: .top, relatedBy: .equal, toItem: self.logoImageView, attribute: .bottom, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: emailTitleLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -20).isActive = true
    }
    
    fileprivate func addingEmailTextField() {
        self.addSubview(emailTextField)
        self.emailTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: emailTextField, attribute: .top, relatedBy: .equal, toItem: self.emailTitleLabel, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: emailTextField, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: emailTextField, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: emailTextField, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 50).isActive = true
    }
    
    fileprivate func addingPasswordTitleLabel() {
        self.addSubview(passwordTitleLabel)
        self.passwordTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: passwordTitleLabel, attribute: .top, relatedBy: .equal, toItem: self.emailTextField, attribute: .bottom, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: passwordTitleLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -20).isActive = true
    }
    
    fileprivate func addingPasswordTextField() {
        self.addSubview(passwordTextField)
        self.passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: passwordTextField, attribute: .top, relatedBy: .equal, toItem: self.passwordTitleLabel, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: passwordTextField, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: passwordTextField, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: passwordTextField, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 50).isActive = true
    }
    
    fileprivate func addingLoginButton() {
        self.addSubview(loginButton)
        self.loginButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: loginButton, attribute: .top, relatedBy: .equal, toItem: self.passwordTextField, attribute: .bottom, multiplier: 1, constant: 35).isActive = true
        NSLayoutConstraint(item: loginButton, attribute: .trailing, relatedBy: .equal, toItem: self.passwordTextField, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: loginButton, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: loginButton, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 50).isActive = true
    }
    
    fileprivate func addingForgetPasswordButton() {
        self.addSubview(forgetPasswordButton)
        self.forgetPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: forgetPasswordButton, attribute: .top, relatedBy: .equal, toItem: self.loginButton, attribute: .bottom, multiplier: 1, constant: 25).isActive = true
        NSLayoutConstraint(item: forgetPasswordButton, attribute: .trailing, relatedBy: .equal, toItem: self.loginButton, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
    }
    
    fileprivate func addingSignupButton() {
        self.addSubview(signupButton)
        self.signupButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: signupButton, attribute: .top, relatedBy: .equal, toItem: self.loginButton, attribute: .bottom, multiplier: 1, constant: 25).isActive = true
        NSLayoutConstraint(item: signupButton, attribute: .leading, relatedBy: .equal, toItem: self.loginButton, attribute: .leading, multiplier: 1, constant: 0).isActive = true
    }
    
    fileprivate func addingShowPasswordButton() {
        self.addSubview(showPasswordButton)
        self.showPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: showPasswordButton, attribute: .centerY, relatedBy: .equal, toItem: self.passwordTextField, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: showPasswordButton, attribute: .leading, relatedBy: .equal, toItem: self.passwordTextField, attribute: .leading, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: showPasswordButton, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0, constant: 25).isActive = true
        NSLayoutConstraint(item: showPasswordButton, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 25).isActive = true
    }
    
    //MARK: - OBJC FUNCTIONS
    @objc func loginButtonPressed() {
        guard let emailAddress = emailTextField.text, !emailAddress.isEmpty else {
            utility.notification.show(title: "", body: "emailIsEmpty".localized, .error, "error", 2.0)
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            utility.notification.show(title: "", body: "passwordIsEmpty".localized, .error, "error", 2.0)
            return
        }
        
        if emailAddress.isValidEmail == false {
            utility.notification.show(title: "", body: "emailValidation".localized, .error, "error", 2.0)
            return
        }
        
        if password.count < 8 {
            utility.notification.show(title: "", body: "passwordLimit".localized, .error, "error", 2.0)
            return
        }
        
        self.emailTextField.endEditing(true)
        self.passwordTextField.endEditing(true)
        self.delegate?.buttonsActionHandler(action: .login, email: emailAddress, password: password)
    }
    
    @objc func signupButtonPressed() {
        self.delegate?.buttonsActionHandler(action: .signup, email: nil, password: nil)
    }
    
    @objc func forgetPasswordButtonPressed() {
        self.delegate?.buttonsActionHandler(action: .forgetPassword, email: nil, password: nil)
    }
    
    @objc func hideAndShowPasswordButtonPressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            self.passwordTextField.isSecureTextEntry = false
        } else {
            self.passwordTextField.isSecureTextEntry = true
        }
    }
    
}

extension LoginView: UITextFieldDelegate {
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
        } else if textField.tag == 100 {
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
            return true
        } else if textField.tag == 101 {
            emailTextField.resignFirstResponder()
            return true
        }else {
            return false
        }
    }
}
