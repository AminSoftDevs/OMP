//
//  SignupView.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 8/1/21.
//

import UIKit
import MHLoadingButton

protocol SignupViewDelegate: AnyObject {
    func signupInformation(email: String, password: String, referralCode: String)
    func loginButtonPressed()
}

extension SignupViewDelegate {
    func signupInformation(email: String, password: String, referralCode: String){}
    func loginButtonPressed(){}
}

class SignupView: UIView {
    
    var stopSubmitButtonAnimating: Bool = false {
        didSet {
            if stopSubmitButtonAnimating  {
                self.signupButton.hideLoader()
            }
        }
    }
    
    var utility = BaseModule.sharedInstance
    var estimatedViewHeight: CGFloat = 680
    
    var email: String?
    var password: String?
    var confirmPassword: String?
    var referralCode: String = ""
    
    let currentTheme = UserDefaults.standard.selectedTheme
    
    private lazy var logoImageView: UIImageView = {
      let imageView = UIImageView()
        imageView.image = currentTheme == (.light) ? UIImage(named: "logo_white") : UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var acceptLicensesCheckBoxButton: UIButton = {
       var button = UIButton()
        button.imageView?.contentMode = .scaleAspectFill
        button.setImage(UIImage(named: "success_checkBox_icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.setImage(UIImage(named: "success_checkBox_icon")?.withRenderingMode(.alwaysTemplate), for: .selected)
        button.tintColor  = .clear
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.addTarget(self, action: #selector(acceptLicensesCheckBoxButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var signupButton: LoadingButton = {
       var button = LoadingButton()
        button.configure(fontSize: 14, title: "", fontType: .regular, titleColor: .cardsColor, backgroundColor: .submitButtonColor, borderColor: .clear, cornerRadius: 10)
        button.setTitle("SignupView.signupButton".localized, for: .normal)
        button.addTarget(self, action: #selector(signupButtonPressed), for: .touchUpInside)
        button.indicator = BallPulseSyncIndicator(color: .gray)
        button.cornerRadius  = 10
        button.bgColor = .submitButtonColor
        button.indicator.color = .cardsColor
        return button
    }()
    
    lazy var loginButton: UIButton = {
       var button = UIButton()
        button.configure(fontSize: 15, title: "", fontType: .regular, titleColor: .rejectOrangeColor, backgroundColor: .clear, borderColor: .clear, cornerRadius: 0)
        button.setTitle("ورود".localized, for: .normal)
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var acceptLicensesLabel: UILabel = {
        var label = UILabel()
        label.configure(text: "SignupView.licenseAgreementText".localized, fontSize: 12, textColor: .textColor, textAlignment: .right, fontType: .regular)
        label.setText("SignupView.licenseAgreementText".localized, withColorPart: "SignupView.rules".localized, color: .submitButtonColor)
        return label
    }()
    
    private lazy var showTermsAndConditionButton: UIButton = {
        var button = UIButton()
        button.addTarget(self, action: #selector(showTermsAndConditionPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var emailAddressView: UserInputView = UserInputView()
    private lazy var passwordView: UserInputView = UserInputView()
    private lazy var confirmPasswordView: UserInputView = UserInputView()
    private lazy var referralCodeView: UserInputView = UserInputView()
    
    weak var delegate: SignupViewDelegate?
    
    //MARK: - DEFAULT INITIALIZER
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .cardsColor
        self.createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - CREATE UI
    fileprivate func createUI() {
        self.addingLogoImageView()
        self.addingEmailAddressView()
        self.addingPasswordView()
        self.addingConfirmPasswordView()
        self.addingReferralCodeView()
        self.addingAcceptLicenseSection()
        self.addingSignupButton()
        self.addingLoginButton()
    }
    
    fileprivate func addingLogoImageView() {
        self.addSubview(logoImageView)
        self.logoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: logoImageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: logoImageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: logoImageView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: -80).isActive = true
        NSLayoutConstraint(item: logoImageView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 60).isActive = true
    }
    
    fileprivate func addingEmailAddressView() {
        self.addSubview(emailAddressView)
        self.emailAddressView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: emailAddressView, attribute: .top, relatedBy: .equal, toItem: self.logoImageView, attribute: .bottom, multiplier: 1, constant: 30).isActive = true
        NSLayoutConstraint(item: emailAddressView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: emailAddressView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: emailAddressView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 90).isActive = true
        
        self.emailAddressView.type = .email
        self.emailAddressView.delegate = self
    }
    
    fileprivate func addingPasswordView() {
        self.addSubview(passwordView)
        self.passwordView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: passwordView, attribute: .top, relatedBy: .equal, toItem: self.emailAddressView, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: passwordView, attribute: .leading, relatedBy: .equal, toItem: self.emailAddressView, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: passwordView, attribute: .trailing, relatedBy: .equal, toItem: self.emailAddressView, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: passwordView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 90).isActive = true
        
        self.passwordView.type = .password
        self.passwordView.delegate = self
    }
    
    fileprivate func addingConfirmPasswordView() {
        self.addSubview(confirmPasswordView)
        self.confirmPasswordView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: confirmPasswordView, attribute: .top, relatedBy: .equal, toItem: self.passwordView, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: confirmPasswordView, attribute: .leading, relatedBy: .equal, toItem: self.emailAddressView, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: confirmPasswordView, attribute: .trailing, relatedBy: .equal, toItem: self.emailAddressView, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: confirmPasswordView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 90).isActive = true
        
        self.confirmPasswordView.type = .confirmPassword
        self.confirmPasswordView.delegate = self
    }
    
    fileprivate func addingReferralCodeView() {
        self.addSubview(referralCodeView)
        self.referralCodeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: referralCodeView, attribute: .top, relatedBy: .equal, toItem: self.confirmPasswordView, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: referralCodeView, attribute: .leading, relatedBy: .equal, toItem: self.emailAddressView, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: referralCodeView, attribute: .trailing, relatedBy: .equal, toItem: self.emailAddressView, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: referralCodeView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 90).isActive = true
        
        self.referralCodeView.type = .referralCode
        self.referralCodeView.delegate = self
    }
    
    fileprivate func addingAcceptLicenseSection() {
        self.addSubview(acceptLicensesCheckBoxButton)
        self.acceptLicensesCheckBoxButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: acceptLicensesCheckBoxButton, attribute: .top, relatedBy: .equal, toItem: self.referralCodeView, attribute: .bottom, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: acceptLicensesCheckBoxButton, attribute: .trailing, relatedBy: .equal, toItem: self.emailAddressView, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: acceptLicensesCheckBoxButton, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0, constant: 20).isActive = true
        NSLayoutConstraint(item: acceptLicensesCheckBoxButton, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 20).isActive = true
        
        self.addSubview(acceptLicensesLabel)
        self.acceptLicensesLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: acceptLicensesLabel, attribute: .centerY, relatedBy: .equal, toItem: self.acceptLicensesCheckBoxButton, attribute: .centerY, multiplier: 1, constant: 2).isActive = true
        NSLayoutConstraint(item: acceptLicensesLabel, attribute: .trailing, relatedBy: .equal, toItem: self.acceptLicensesCheckBoxButton, attribute: .leading, multiplier: 1, constant: -8).isActive = true
        
        self.addSubview(showTermsAndConditionButton)
        self.showTermsAndConditionButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: showTermsAndConditionButton, attribute: .centerY, relatedBy: .equal, toItem: self.acceptLicensesCheckBoxButton, attribute: .centerY, multiplier: 1, constant: 2).isActive = true
        NSLayoutConstraint(item: showTermsAndConditionButton, attribute: .trailing, relatedBy: .equal, toItem: self.acceptLicensesCheckBoxButton, attribute: .leading, multiplier: 1, constant: -2).isActive = true
        NSLayoutConstraint(item: showTermsAndConditionButton, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0, constant: 90).isActive = true
    }
    
    fileprivate func addingSignupButton() {
        self.addSubview(signupButton)
        self.signupButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: signupButton, attribute: .top, relatedBy: .equal, toItem: self.acceptLicensesCheckBoxButton, attribute: .bottom, multiplier: 1, constant: 30).isActive = true
        NSLayoutConstraint(item: signupButton, attribute: .trailing, relatedBy: .equal, toItem: self.emailAddressView, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: signupButton, attribute: .leading, relatedBy: .equal, toItem: self.emailAddressView, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: signupButton, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 50).isActive = true
    }
    
    fileprivate func addingLoginButton() {
        self.addSubview(loginButton)
        self.loginButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: loginButton, attribute: .top, relatedBy: .equal, toItem: self.signupButton, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: loginButton, attribute: .centerX, relatedBy: .equal, toItem: self.signupButton, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    }
    
    //MARK: - FUNCTIONS
    fileprivate func validateUserInputs() -> Bool {
        guard let emailAddress = self.email, !emailAddress.isEmpty else {
            utility.notification.show(title: "", body: "emailIsEmpty".localized, .error, "error", 2.0)
            return false
        }
        
        guard let password = self.password, !password.isEmpty else {
            utility.notification.show(title: "", body: "passwordIsEmpty".localized, .error, "error", 2.0)
            return false
        }
        
        guard let confirmPassword = self.confirmPassword, !confirmPassword.isEmpty else {
            utility.notification.show(title: "", body: "repeatPasswordIsEmpty".localized, .error, "error", 2.0)
            return false
        }
        
        if emailAddress.isValidEmail == false {
            utility.notification.show(title: "", body: "emailValidation".localized, .error, "error", 2.0)
            return false
        }
        
        if password.count < 8 {
            utility.notification.show(title: "", body: "passwordLimit".localized, .error, "error", 2.0)
            return false
        }
        
        if password != confirmPassword {
            utility.notification.show(title: "", body: "passwordConfirmationError".localized, .error, "error", 2.0)
            return false
        }
        
        return true
    }
    //MARK: - OBJC FUNCTIONS
    @objc func signupButtonPressed(_ sender: LoadingButton) {
        self.endEditing(true)
        if !acceptLicensesCheckBoxButton.isSelected {
            acceptLicensesLabel.shakeView()
            acceptLicensesCheckBoxButton.shakeView()
            signupButton.shakeView()
            signupButton.hideLoader()
            return
        }
        sender.showLoader(userInteraction: false)
        sender.autoHideLoader()
        if validateUserInputs() {
            //force unwrapped because this items validated
            delegate?.signupInformation(email: self.email!, password: self.password!, referralCode: self.referralCode)
        } else {
            signupButton.hideLoader()
        }
    }
    
    @objc func acceptLicensesCheckBoxButtonPressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            sender.tintColor = .submitButtonColor
            sender.layer.borderWidth = 0
        } else {
            sender.tintColor = .clear
            sender.layer.borderWidth = 1
        }
    }
    
    @objc func loginButtonTapped() {
        self.delegate?.loginButtonPressed()
    }
    
    @objc func showTermsAndConditionPressed() {
        let url = URL(string: "https://www.ompfinex.com/pages/policies")!
        UIApplication.shared.open(url)
    }
}

extension SignupView: UserInputViewDelegate {
    func userInput(input: String, type: UserInputType) {
        switch type {
        case .email:
            self.email = input
        case .password:
            self.password = input
        case .confirmPassword:
            self.confirmPassword = input
        case .referralCode:
            self.referralCode = input
        default:
            print("not in this screen")
        }
    }
}

extension UILabel {
    func setText(_ text: String, withColorPart colorTextPart: String, color: UIColor) {
        attributedText = nil
        let result =  NSMutableAttributedString(string: text)
        result.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: NSString(string: text.lowercased()).range(of: colorTextPart.lowercased()))
        attributedText = result
    }
}
