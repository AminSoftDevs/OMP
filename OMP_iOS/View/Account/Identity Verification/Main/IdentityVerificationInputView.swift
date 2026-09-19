//
//  IdentityVerificationInputView.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 8/8/21.
//

import UIKit
import MHLoadingButton

enum IdentityVerificationInputType {
    case email
    case emailCode
    case mobile
    case mobileCode
    case identity
    case bankInfo
    case waiting
    case address
    case identityVerification
    case finalScreen
}

protocol IdentityVerificationInputViewDelegate: AnyObject {
    func submitButtonPressed(input: String, type: IdentityVerificationInputType)
    func userDecidedToEditMobileNumber()
    func requestToResendVerificationCode()
    func selectImageButtonPressed()
    func submitButtonOnIdentityInformationPressed(userInformation: UserIdentity)
    func addNewBankInfo(type: BankInformationType, number: String)
    func canLeaveCurrentState(type: IdentityVerificationInputType)
    func requestLandlinePhoneVerificationCode(with number: String)
    func selectedProvince(with id: Int)
    func addressToVerify(address: UserAddress)
    func checkLandlineVerificationCode(code: String)
    func finalIdentityVerificationRequest()
}

class IdentityVerificationInputView: UIView {
    
    var  provinceList: [Province] = [] {
        didSet {
            if addressPhoneView != nil {
                self.addressPhoneView!.provinceList = provinceList
            }
        }
    }
    
    var stateList: [City] = [] {
        didSet {
            if addressPhoneView != nil {
                self.addressPhoneView!.stateList = stateList
            }
        }
    }
    
    var cardList: [BankInfoAdapter] = [] {
        didSet {
            self.bankInformationView.cardList = cardList
        }
    }
    
    var landlineVerified: Bool = false {
        didSet {
            if addressPhoneView != nil {
                self.addressPhoneView!.landlineVerified = landlineVerified
            }
        }
    }
    
    var addressVerified: Bool = false {
        didSet {
            if addressPhoneView != nil {
                self.addressPhoneView!.addressVerified = addressVerified
            }
        }
    }
    
    var bankAccountList: [BankInfoAdapter] = [] {
        didSet {
            self.bankInformationView.bankAccountList = bankAccountList
        }
    }
    
    var selectedImage: Data? {
        didSet {
            if type == .identity {
                identityInformationView.identityCardImage = selectedImage
            } else if type == .identityVerification {
                selfIdentityVerificationView?.selectedImage = selectedImage
            }
        }
    }
    
    var showPendingScreen: Bool = false {
        didSet {
            self.selfIdentityVerificationView?.showPendingScreen = showPendingScreen
        }
    }
    
    var stopLoadingButton: Bool = false {
        didSet {
            self.submitButton.hideLoader()
        }
    }
    
    lazy var submitButton: LoadingButton = {
       var button = LoadingButton()
        button.configure(fontSize: 12, title: "", fontType: .regular, titleColor: .backgroundColor, backgroundColor: .submitButtonColor, borderColor: .clear, cornerRadius: 10)
        button.addTarget(self, action: #selector(submitButtonPressed), for: .touchUpInside)
        button.indicator = BallPulseSyncIndicator(color: .gray)
        button.cornerRadius  = 10
        button.bgColor = .submitButtonColor
        button.indicator.color = .cardsColor
        return button
    }()
    
    var utility = BaseModule.sharedInstance
    var input: String?
    
    
    lazy var currentView = UIView()
    lazy var resendCodeButton = UIButton()
    lazy var secondsLabel = UILabel()
    lazy var minuteLabel = UILabel()
    lazy var timer: Timer? = Timer()
    
    lazy var emailView: UserInputView                         = UserInputView()
    lazy var mobileView: UserInputView                        = UserInputView()
    lazy var identityInformationView: IdentityInformationView = IdentityInformationView()
    lazy var bankInformationView: BankInformationView         = BankInformationView()
    lazy var addressPhoneView: AddressPhoneView? = nil
    lazy var selfIdentityVerificationView: SelfIdentityVerificationView? = nil
    lazy var finalScreenIdentityVerificationView: FinalScreenIdentityVerificationView? = nil
    
    let type: IdentityVerificationInputType
    let userInfo: UserInfo?
    
    //MARK: - INITIALIZER
    init(type: IdentityVerificationInputType, userInfo: UserInfo?) {
        self.type = type
        self.userInfo = userInfo
        super.init(frame: .zero)
        self.backgroundColor = .cardsColor
        self.layer.cornerRadius = 15
        self.createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var delegate: IdentityVerificationInputViewDelegate?
    
    //MARK: - CREATE UI
    fileprivate func createUI() {
        switch type {
        case .email:
            addingEmailView()
        case .emailCode:
            addingEmailVerificationCodeView()
        case .mobile:
            addingMobileFieldView()
        case .mobileCode:
            addingMobileVerificationView()
        case .identity:
            addingIdentityInformationView()
        case .waiting:
            addingWaitingForVerification()
        case .bankInfo:
            addingBankInfoTableView()
        case .address:
            addingAddressInfoView()
        case .identityVerification:
            addingIdentityVerification()
        case .finalScreen:
            addingFinalScreen()
        }
    }
    
    fileprivate func addingEmailView() {
        self.emailView.type = .email
        self.emailView.titleLabelString         = "IdentityVerificationInputView.enterYourEmail".localized
        self.emailView.inputTextFieldText       = UserDefaults.standard.userEmail
        self.input                              = UserDefaults.standard.userEmail
        self.emailView.inputTextFieldIsEditable = false
        self.currentView                        = emailView
        self.emailView.delegate                 = self
        self.addSubview(emailView)
        self.emailView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: emailView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: emailView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: emailView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -15).isActive = true
        NSLayoutConstraint(item: emailView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 90).isActive = true
        
        self.addingSubmitButton(leftPadding: 15, rightPadding: -15)
        self.submitButton.setTitle("IdentityVerificationInputView.sendCode".localized, for: .normal)
        self.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    fileprivate func addingEmailVerificationCodeView() {
        let titleLabel: UILabel = UILabel()
        titleLabel.configure(text: "IdentityVerificationInputView.sendVerificationCodeTitle".localized, fontSize: 14, textColor: .textColor, textAlignment: .right, fontType: .regular)
        self.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: titleLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -30).isActive = true
        
        let verificationCodeFields: VerificationCodeView = VerificationCodeView()
        verificationCodeFields.delegate = self
        self.addSubview(verificationCodeFields)
        verificationCodeFields.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: verificationCodeFields, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: verificationCodeFields, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 30).isActive = true
        NSLayoutConstraint(item: verificationCodeFields, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -30).isActive = true
        NSLayoutConstraint(item: verificationCodeFields, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 50).isActive = true
        
        self.currentView = verificationCodeFields
        self.addingSubmitButton(leftPadding: 30, rightPadding: -30)
        self.submitButton.setTitle("IdentityVerificationInputView.continue".localized, for: .normal)
        
        self.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    fileprivate func addingMobileFieldView() {
        self.mobileView.type = .mobile
        self.mobileView.titleLabelString            = "IdentityVerificationInputView.enterMobileNumber".localized
        self.currentView                            = mobileView
        self.mobileView.delegate                    = self
        self.addSubview(mobileView)
        self.mobileView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: mobileView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: mobileView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: mobileView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -15).isActive = true
        NSLayoutConstraint(item: mobileView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 90).isActive = true
        
        self.addingSubmitButton(leftPadding: 15, rightPadding: -15)
        self.submitButton.setTitle("IdentityVerificationInputView.sendCode".localized, for: .normal)
        self.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    fileprivate func addingMobileVerificationView() {
        let titleLabel: UILabel = UILabel()
        titleLabel.configure(text: "IdentityVerificationInputView.sendMobileVerificationCode".localized, fontSize: 14, textColor: .textColor, textAlignment: .right, fontType: .regular)
        self.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: titleLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -30).isActive = true
        
        let verificationCodeFields: VerificationCodeView = VerificationCodeView()
        verificationCodeFields.delegate = self
        self.addSubview(verificationCodeFields)
        verificationCodeFields.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: verificationCodeFields, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: verificationCodeFields, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 30).isActive = true
        NSLayoutConstraint(item: verificationCodeFields, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -30).isActive = true
        NSLayoutConstraint(item: verificationCodeFields, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 50).isActive = true
        
        self.currentView = verificationCodeFields
        self.addingSubmitButton(leftPadding: 30, rightPadding: -30)
        self.submitButton.setTitle("IdentityVerificationInputView.continue".localized, for: .normal)
        
        let editMobileNumberButton = UIButton()
        editMobileNumberButton.configure(fontSize: 12, title: "IdentityVerificationInputView.editMobileNumber".localized, fontType: .regular, titleColor: .rejectOrangeColor, backgroundColor: .clear, borderColor: .clear)
        editMobileNumberButton.addTarget(self, action: #selector(editMobileNumberButtonPressed), for: .touchUpInside)
        
        self.addSubview(editMobileNumberButton)
        editMobileNumberButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: editMobileNumberButton, attribute: .top, relatedBy: .equal, toItem: submitButton, attribute: .bottom, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: editMobileNumberButton, attribute: .leading, relatedBy: .equal, toItem: verificationCodeFields, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: editMobileNumberButton, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0, constant: 120).isActive = true
        NSLayoutConstraint(item: editMobileNumberButton, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 30).isActive = true
        
        self.createTimerForVerification()
        self.heightAnchor.constraint(equalToConstant: 250).isActive = true
    }
    
    fileprivate func addingSubmitButton(leftPadding: CGFloat, rightPadding: CGFloat) {
        self.addSubview(submitButton)
        self.submitButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: submitButton, attribute: .top, relatedBy: .equal, toItem: currentView, attribute: .bottom, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: submitButton, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: leftPadding).isActive = true
        NSLayoutConstraint(item: submitButton, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: rightPadding).isActive = true
        NSLayoutConstraint(item: submitButton, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 50).isActive = true
    }
    
    fileprivate func createTimerForVerification() {
        resendCodeButton.configure(fontSize: 13, title: "IdentityVerificationInputView.resendCode".localized + " :", fontType: .regular, titleColor: .mediumGrayColor, backgroundColor: .clear, borderColor: .clear)
        resendCodeButton.addTarget(self, action: #selector(resendVerificationCodePressed), for: .touchUpInside)
        resendCodeButton.isEnabled = false
        
        self.addSubview(resendCodeButton)
        resendCodeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: resendCodeButton, attribute: .top, relatedBy: .equal, toItem: submitButton, attribute: .bottom, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: resendCodeButton, attribute: .trailing, relatedBy: .equal, toItem: submitButton, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: resendCodeButton, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 30).isActive = true
        
        secondsLabel.configure(text: "59", fontSize: 13, textColor: .mediumGrayColor, textAlignment: .left, fontType: .regular)
        secondsLabel.text = secondsLabel.text?.convertEngNumToPersianNum()
        
        minuteLabel.configure(text: "02 :", fontSize: 13, textColor: .mediumGrayColor, textAlignment: .center, fontType: .regular)
        minuteLabel.text = minuteLabel.text?.convertEngNumToPersianNum()
        
        self.addSubview(secondsLabel)
        secondsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: secondsLabel, attribute: .centerY, relatedBy: .equal, toItem: resendCodeButton, attribute: .centerY, multiplier: 1, constant: 2).isActive = true
        NSLayoutConstraint(item: secondsLabel, attribute: .trailing, relatedBy: .equal, toItem: resendCodeButton, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: secondsLabel, attribute: .width, relatedBy: .equal, toItem: secondsLabel, attribute: .width, multiplier: 0, constant: 30).isActive = true
        
        self.addSubview(minuteLabel)
        minuteLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: minuteLabel, attribute: .centerY, relatedBy: .equal, toItem: secondsLabel, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: minuteLabel, attribute: .trailing, relatedBy: .equal, toItem: secondsLabel, attribute: .leading, multiplier: 1, constant: -1).isActive = true
        NSLayoutConstraint(item: minuteLabel, attribute: .width, relatedBy: .equal, toItem: secondsLabel, attribute: .width, multiplier: 0, constant: 30).isActive = true
        
        self.createTimer()
    }
    
    fileprivate func createTimer() {
        var waitingTime: Int = 179
        self.secondsLabel.alpha = 1
        self.minuteLabel.alpha = 1
        self.resendCodeButton.isEnabled = false
        self.resendCodeButton.setTitleColor(.mediumGrayColor, for: .normal)
        self.resendCodeButton.setTitle("IdentityVerificationInputView.resendCode".localized, for: .normal)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
            if waitingTime >= 0 {
                let minuet = waitingTime / 60
                self.minuteLabel.text = "0\(minuet) :".convertEngNumToPersianNum()
                let second = waitingTime % 60
                if second >= 10 {
                    self.secondsLabel.text = "\(second)".convertEngNumToPersianNum()
                } else {
                    self.secondsLabel.text = "0\(second)".convertEngNumToPersianNum()
                }
                waitingTime -= 1
            } else {
                Timer.invalidate()
                self.resendCodeButton.isEnabled = true
                self.resendCodeButton.setTitleColor(.submitGreenColor, for: .normal)
                self.resendCodeButton.setTitle("IdentityVerificationInputView.resendCode".localized, for: .normal)
                self.secondsLabel.alpha = 0
                self.minuteLabel.alpha = 0
            }
        }
    }
    
    fileprivate func addingIdentityInformationView() {
        self.addSubview(identityInformationView)
        self.identityInformationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: identityInformationView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: identityInformationView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: identityInformationView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: identityInformationView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 0).isActive = true
        
        self.identityInformationView.delegate = self
    }
    
    fileprivate func addingWaitingForVerification() {
        let iconImageView = UIImageView()
        iconImageView.contentMode = .center
        iconImageView.image = UIImage(named: "wating_icon")
        
        self.addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: iconImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 0.7, constant: 0).isActive = true
        NSLayoutConstraint(item: iconImageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: iconImageView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0 , constant: 60).isActive = true
        NSLayoutConstraint(item: iconImageView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 60).isActive = true
        
        let messageLabel = UILabel()
        messageLabel.configure(text: "IdentityVerificationInputView.verificationWillTakeTime".localized, fontSize: 13, textColor: .submitGreenColor, textAlignment: .center, fontType: .bold)
        messageLabel.numberOfLines = 0
        self.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: messageLabel, attribute: .top, relatedBy: .equal, toItem: iconImageView, attribute: .bottom, multiplier: 1, constant: 30).isActive = true
        NSLayoutConstraint(item: messageLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: messageLabel, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1 , constant: -50).isActive = true
    }
    
    fileprivate func addingBankInfoTableView() {
        self.addSubview(bankInformationView)
        self.bankInformationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: bankInformationView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: bankInformationView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: bankInformationView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: bankInformationView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 0).isActive = true
        
        self.bankInformationView.delegate = self
        
        self.backgroundColor = .backgroundColor
    }
    
    fileprivate func addingAddressInfoView() {
        self.addressPhoneView = AddressPhoneView(userInfo: self.userInfo)
        self.addSubview(addressPhoneView!)
        self.addressPhoneView?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: addressPhoneView!, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: addressPhoneView!, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: addressPhoneView!, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: addressPhoneView!, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 0).isActive = true
        
        self.backgroundColor = .clear
        self.addressPhoneView?.delegate = self
    }
    
    fileprivate func addingIdentityVerification() {
        self.selfIdentityVerificationView = SelfIdentityVerificationView(userInfo: userInfo)
        self.selfIdentityVerificationView?.delegate = self
        self.addSubview(selfIdentityVerificationView!)
        selfIdentityVerificationView?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: selfIdentityVerificationView!, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: selfIdentityVerificationView!, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: selfIdentityVerificationView!, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: selfIdentityVerificationView!, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 0).isActive = true
        
        self.backgroundColor = .clear
    }
    
    fileprivate func addingFinalScreen() {
        self.finalScreenIdentityVerificationView = FinalScreenIdentityVerificationView()
        self.finalScreenIdentityVerificationView?.delegate = self
        self.addSubview(finalScreenIdentityVerificationView!)
        self.finalScreenIdentityVerificationView?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: finalScreenIdentityVerificationView!, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: finalScreenIdentityVerificationView!, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: finalScreenIdentityVerificationView!, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: finalScreenIdentityVerificationView!, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 0).isActive = true
        
        self.backgroundColor = .clear
    }
    
    //MARK: - FUNCTIONS
    fileprivate func validateUserInput(with input: String) -> Bool {
        if type == .email {
            guard !input.isEmpty else {
                utility.notification.show(title: "", body: "emailIsEmpty".localized, .error, "error", 2.0)
                return false
            }
            if input.isValidEmail == false {
                utility.notification.show(title: "", body: "emailValidation".localized, .error, "error", 2.0)
                return false
            }
        }
        return true
    }
    
    //MARK: - OBJC FUNCTIONS
    @objc func submitButtonPressed() {
        self.submitButton.showLoader(userInteraction: false)
        self.currentView.endEditing(true)
        guard let userInput = self.input else {
            self.submitButton.hideLoader()
            return
        }
        delegate?.submitButtonPressed(input: userInput, type: type)
    }
    
    @objc func editMobileNumberButtonPressed() {
        delegate?.userDecidedToEditMobileNumber()
    }
    
    @objc func resendVerificationCodePressed() {
        delegate?.requestToResendVerificationCode()
        self.timer = nil
        self.createTimer()
        
    }
}

extension IdentityVerificationInputView: UserInputViewDelegate {
    func userInput(input: String, type: UserInputType) {
        self.input = input.persianToEng()
    }
}

extension IdentityVerificationInputView: VerificationViewDelegate {
    func verificationFieldEndEditing(text: String?) {
        self.input = text
    }
}

extension IdentityVerificationInputView: IdentityInformationViewDelegate {
    func submitButtonPressedWithIdentityInformation(with information: UserIdentity) {
        delegate?.submitButtonOnIdentityInformationPressed(userInformation: information)
    }
    
    func selectImageButtonPressed() {
        delegate?.selectImageButtonPressed()
    }
}

//BANK INFO
extension IdentityVerificationInputView: BankInfoDelegate {
    func newCreditOrBankAccount(type: BankInformationType, with number: String) {
        delegate?.addNewBankInfo(type: type, number: number)
    }
    
    func continueButtonPressed() {
        delegate?.canLeaveCurrentState(type: .bankInfo)
    }
}
//Address Info
extension IdentityVerificationInputView: AddressPhoneViewDelegate {
    func checkLandlineVerificationCode(code: String) {
        self.delegate?.checkLandlineVerificationCode(code: code)
    }
    
    func addressToVerify(address: UserAddress) {
        self.delegate?.addressToVerify(address: address)
    }
    
    func selectedProvince(with id: Int) {
        self.delegate?.selectedProvince(with: id)
    }
    
    func imagePickerButtonPressed() {
        self.delegate?.selectImageButtonPressed()
    }
    
    func requestForLandLineVerificationCode(with number: String) {
        self.delegate?.requestLandlinePhoneVerificationCode(with: number)
    }
    
    func addressViewContinueButtonPressed() {
        self.delegate?.canLeaveCurrentState(type: .address)
    }
}

//Identity with self picture
extension IdentityVerificationInputView: SelfIdentityVerificationViewDelegate {
    func requestToVerifyUser() {
        self.delegate?.finalIdentityVerificationRequest()
    }
    
    func identityImagePickerButtonPressed() {
        self.delegate?.selectImageButtonPressed()
    }
}

extension IdentityVerificationInputView: FinalScreenIdentityVerificationViewDelegate {
    func backToMainScreen() {
        self.delegate?.canLeaveCurrentState(type: .finalScreen)
    }
}
