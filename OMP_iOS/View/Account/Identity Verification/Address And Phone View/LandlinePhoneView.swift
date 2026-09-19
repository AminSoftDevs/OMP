//
//  LandlinePhoneView.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 8/15/21.
//

import UIKit
import MHLoadingButton

protocol LandlinePhoneViewDelegate: AnyObject {
    func requestLandlineVerificationCode(with number: String)
    func backToEditLandlineNumber()
    func checkLandlineVerificationCode(code: String)
}

class LandlinePhoneView: UIView {
    
    let utility = BaseModule.sharedInstance
    var landlineNumber: String?
    var verificationCode: String?
    var onVerification: Bool = false
    var isVerified: Bool
    
    private lazy var titleLabel: UILabel = UILabel()
    private lazy var editMobileNumberButton = UIButton()
    private lazy var verificationCodeFields: VerificationCodeView = VerificationCodeView()
    private lazy var phoneView: UserInputView = UserInputView()
    
    private var saveButton: LoadingButton = {
       var button = LoadingButton()
        button.configure(fontSize: 12, title: "confirm".localized, fontType: .regular, titleColor: .backgroundColor, backgroundColor: .rejectOrangeColor, borderColor: .clear, cornerRadius: 15)
        button.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        button.indicator = BallPulseSyncIndicator(color: .gray)
        button.cornerRadius  = 15
        button.bgColor = .rejectOrangeColor
        button.indicator.color = .cardsColor
        return button
    }()
    
    lazy var checkBoxImageView: UIImageView = {
       var imageView = UIImageView()
        imageView.image = UIImage(named: "success_checkBox_icon")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var successLabel: UILabel = {
        var label = UILabel()
        label.configure(text: "LandlinePhoneView.success".localized, fontSize: 14, textColor: .init(hex: "55E0B3"), textAlignment: .center, fontType: .bold)
        return label
    }()
    
    
    weak var delegate: LandlinePhoneViewDelegate?
    
    //MARK: - INITIALIZER
    
    init(verified: Bool) {
        self.isVerified = verified
        super.init(frame: .zero)
        self.backgroundColor = .cardsColor
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.createUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - CREATE UI
    fileprivate func createUI() {
        self.addingPhoneView()
        self.addingSaveButton()
        self.addingVerificationTitleLabel()
        self.addingVerificationCodeView()
        self.addingEditPhoneButton()
        
        if isVerified {
            self.addingVerifiedScreen()
            self.addingSuccessfulCheckbox()
        }
    }
    
    fileprivate func addingPhoneView() {
        self.addSubview(phoneView)
        self.phoneView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: phoneView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: phoneView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: phoneView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -15).isActive = true
        NSLayoutConstraint(item: phoneView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 90).isActive = true
        
        self.phoneView.type = .landlinePhone
        self.phoneView.delegate = self
    }
    
    fileprivate func addingSaveButton() {
        self.addSubview(saveButton)
        self.saveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: saveButton, attribute: .top, relatedBy: .equal, toItem: phoneView, attribute: .bottom, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: saveButton, attribute: .centerX, relatedBy: .equal, toItem: phoneView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: saveButton, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0, constant: 100).isActive = true
        NSLayoutConstraint(item: saveButton, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 50).isActive = true
    }
    
    fileprivate func addingVerificationTitleLabel() {
        self.addSubview(titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: titleLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -15).isActive = true
        
        self.titleLabel.configure(text: "LandlinePhoneView.verificationCodeTitle".localized, fontSize: 14, textColor: .textColor, textAlignment: .right, fontType: .regular)
        self.titleLabel.alpha = 0
    }
    
    fileprivate func addingVerificationCodeView() {
        self.addSubview(verificationCodeFields)
        self.verificationCodeFields.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: verificationCodeFields, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: verificationCodeFields, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 30).isActive = true
        NSLayoutConstraint(item: verificationCodeFields, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -30).isActive = true
        NSLayoutConstraint(item: verificationCodeFields, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 50).isActive = true
        
        self.verificationCodeFields.delegate = self
        self.verificationCodeFields.alpha = 0
    }
    
    fileprivate func addingEditPhoneButton() {
        self.addSubview(editMobileNumberButton)
        self.editMobileNumberButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: editMobileNumberButton, attribute: .top, relatedBy: .equal, toItem: saveButton, attribute: .bottom, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: editMobileNumberButton, attribute: .centerX, relatedBy: .equal, toItem: saveButton, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: editMobileNumberButton, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 30).isActive = true
        
        self.editMobileNumberButton.configure(fontSize: 14, title: "LandlinePhoneView.editNumber".localized, fontType: .regular, titleColor: .submitGreenColor, backgroundColor: .clear, borderColor: .clear)
        self.editMobileNumberButton.alpha = 0
        self.editMobileNumberButton.addTarget(self, action: #selector(editMobileNumberButtonPressed), for: .touchUpInside)
    }
    
    fileprivate func addingVerifiedScreen() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0.8
        self.addSubview(blurEffectView)
        self.saveButton.alpha = 0.6
    }
    
    fileprivate func addingSuccessfulCheckbox() {
        self.addSubview(checkBoxImageView)
        self.checkBoxImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: checkBoxImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: -30).isActive = true
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
    fileprivate func changeScreenToGetVerificationCode() {
        UIView.animate(withDuration: 0.4) {
            self.phoneView.alpha = 0
            self.saveButton.alpha = 0
        } completion: { _ in
            UIView.animate(withDuration: 0.4) {
                self.titleLabel.alpha = 1
                self.verificationCodeFields.alpha = 1
                self.saveButton.alpha = 1
                self.editMobileNumberButton.alpha = 1
                self.saveButton.hideLoader()
                self.onVerification = true
            }
        }
    }
    
    fileprivate func changeScreenToDefault() {
        UIView.animate(withDuration: 0.4) {
            self.titleLabel.alpha = 0
            self.verificationCodeFields.alpha = 0
            self.saveButton.alpha = 0
            self.editMobileNumberButton.alpha = 0
        } completion: { _ in
            UIView.animate(withDuration: 0.4) {
                self.phoneView.alpha = 1
                self.saveButton.alpha = 1
            }
            self.onVerification = false
        }
    }
    
    func showPendingMode() {
        self.saveButton.hideLoader()
        self.addingVerifiedScreen()
        self.addingSuccessfulCheckbox()
    }
    
    func stopLoader() {
        self.saveButton.hideLoader()
    }
    //MARK: - OBJC FUNCTIONS
    @objc func saveButtonPressed() {
        self.endEditing(true)
        self.saveButton.showLoader(userInteraction: false)
        if onVerification == false {
            guard let number = self.landlineNumber else {
                utility.notification.show(title: "", body: "LandlinePhoneView.landlineFieldCan'tBeEmpty".localized, .error, "error", 2.0)
                self.saveButton.hideLoader()
                return
            }
            self.changeScreenToGetVerificationCode()
            self.delegate?.requestLandlineVerificationCode(with: number)
        } else {
            guard let verificationCode = self.verificationCode else {
                utility.notification.show(title: "", body: "LandlinePhoneView.verificationCodeCan'tBeEmpty".localized, .error, "error", 2.0)
                self.saveButton.hideLoader()
                return
            }
            self.delegate?.checkLandlineVerificationCode(code: verificationCode)
        }
        
    }
    
    @objc func editMobileNumberButtonPressed() {
        self.delegate?.backToEditLandlineNumber()
        self.changeScreenToDefault()
    }
}

extension LandlinePhoneView: UserInputViewDelegate {
    func userInput(input: String, type: UserInputType) {
        if type == .landlinePhone {
            let englishNumber = input.persianToEng()
            if !englishNumber.starts(with: "0") {
                self.landlineNumber = "0" + englishNumber
            } else {
                self.landlineNumber = englishNumber
            }
        }
    }
}

extension LandlinePhoneView: VerificationViewDelegate {
    func verificationFieldEndEditing(text: String?) {
        self.verificationCode = text
    }
}
