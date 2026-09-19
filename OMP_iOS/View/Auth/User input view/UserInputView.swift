//
//  UserInputView.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 8/1/21.
//

import UIKit

enum UserInputType {
    case email
    case password
    case confirmPassword
    case mobile
    case name
    case lastName
    case referralCode
    case nationalId
    case landlinePhone
    case postalCode
    case currentPassword
    case newPassword
    case repeatNewPassword
}

protocol UserInputViewDelegate: AnyObject {
    func userInput(input: String, type: UserInputType)
}

class UserInputView: UIView {
    
    var titleColor: UIColor {
        get {
            return _titleColor
        }
        set {
            self._titleColor = newValue
        }
    }
    
    fileprivate var _titleColor: UIColor = .textColor {
        didSet {
            self.titleLabel.textColor = _titleColor
        }
    }
    
    var titleLabelString: String {
        get {
           return _titleLabelString
        }
        set {
            self._titleLabelString = newValue
        }
    }
    
    fileprivate var _titleLabelString: String = "" {
        didSet {
            self.titleLabel.text = _titleLabelString
        }
    }
    
    var inputTextFieldText: String {
        get {
           return _inputTextFieldText
        }
        set {
            self._inputTextFieldText = newValue
        }
    }
    
    fileprivate var _inputTextFieldText: String = "" {
        didSet {
            self.inputTextField.text = _inputTextFieldText
        }
    }
    
    var inputTextFieldIsEditable: Bool {
        get {
           return _inputTextFieldIsEditable
        }
        set {
            self._inputTextFieldIsEditable = newValue
        }
    }
    
    fileprivate var _inputTextFieldIsEditable: Bool = true {
        didSet {
            self.inputTextField.isEnabled = _inputTextFieldIsEditable
        }
    }
    
    
    private lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.configure(text: "", fontSize: 14, textColor: .textColor, textAlignment: .right, fontType: .regular)
        return label
    }()
    
    private lazy var inputTextField: TextFieldWithPadding = {
        let textField = TextFieldWithPadding()
        textField.configure(placeholder: "", borderColor: .clear , fontSize: 14, fontType: .regular, keyboardType: .emailAddress, textAlignment: .right, radius: 10, backgroundColor: .backgroundColor, textColor: .textColor)
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
        textField.textPadding = .init(top: 5, left: 0, bottom: 0, right: 0)
        return textField
    }()
    
    lazy var showPasswordButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "hide_password_icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.setImage(UIImage(named: "show_password_icon")?.withRenderingMode(.alwaysTemplate), for: .selected)
        button.tintColor = .textColor
        button.addTarget(self, action: #selector(hideAndShowPasswordButtonPressed), for: .touchUpInside)
        return button
    }()
    
    var type: UserInputType? {
        didSet {
            self.updateUI()
        }
    }
    
    weak var delegate: UserInputViewDelegate?
    
    //MARK: - DEFAULT INITIALIZER
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createUI()
        self.inputTextField.keyboardDistanceFromTextField = 60
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - CREATE UI
    fileprivate func createUI() {
        self.addingTitleLabel()
        self.addingInputTextField()
        self.addingShowPasswordButton()
    }
    
    fileprivate func addingTitleLabel() {
        self.addSubview(titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: titleLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
    }
    
    fileprivate func addingInputTextField() {
        self.addSubview(inputTextField)
        self.inputTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: inputTextField, attribute: .top, relatedBy: .equal, toItem: self.titleLabel, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: inputTextField, attribute: .trailing, relatedBy: .equal, toItem: self.titleLabel, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: inputTextField, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: inputTextField, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 50).isActive = true
    }
    
    fileprivate func addingShowPasswordButton() {
        self.addSubview(showPasswordButton)
        self.showPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: showPasswordButton, attribute: .centerY, relatedBy: .equal, toItem: self.inputTextField, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: showPasswordButton, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0, constant: 35).isActive = true
        NSLayoutConstraint(item: showPasswordButton, attribute: .leading, relatedBy: .equal, toItem: self.inputTextField, attribute: .leading, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: showPasswordButton, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 35).isActive = true
    }
    
    //MARK: - FUNCTIONS
    
    //MARK: - OBJC FUNCTIONS
    @objc func hideAndShowPasswordButtonPressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            self.inputTextField.isSecureTextEntry = false
        } else {
            self.inputTextField.isSecureTextEntry = true
        }
    }
    
    @objc func textFieldValueChanged(_ sender: UITextField) {
        if type == .mobile {
            self.inputTextField.text = sender.text?.convertEngNumToPersianNum()
            if sender.text?.count == 11 {
                sender.resignFirstResponder()
            }
        } else if type == .nationalId {
            self.inputTextField.text = sender.text?.convertEngNumToPersianNum()
            if sender.text?.count == 10 {
                sender.resignFirstResponder()
            }
        } else if type == .landlinePhone {
            self.inputTextField.text = sender.text?.convertEngNumToPersianNum()
        } else if type == .postalCode {
            if sender.text?.count == 10 {
                sender.resignFirstResponder()
            }
            self.inputTextField.text = sender.text?.convertEngNumToPersianNum()
        }
        
    }
    
    //MARK: - UPDATE UI
    fileprivate func updateUI() {
        switch type {
        case .email:
            self.inputTextField.keyboardType = .emailAddress
            self.titleLabel.text = "UserInputView.email".localized
            self.showPasswordButton.isHidden = true
            self.inputTextField.textAlignment = .left
            self.inputTextField.textPadding = .init(top: 6, left: 10, bottom: 0, right: 0)
        case .password:
            self.inputTextField.keyboardType = .default
            self.inputTextField.isSecureTextEntry = true
            self.inputTextField.textAlignment = .left
            self.inputTextField.textPadding = .init(top: 6, left: 40, bottom: 0, right: 0)
            self.titleLabel.text = "UserInputView.password".localized
            self.showPasswordButton.isHidden = false
        case .confirmPassword:
            self.inputTextField.keyboardType = .default
            self.inputTextField.isSecureTextEntry = true
            self.titleLabel.text = "UserInputView.repeatPassword".localized
            self.inputTextField.textAlignment = .left
            self.inputTextField.textPadding = .init(top: 6, left: 40, bottom: 0, right: 0)
            self.showPasswordButton.isHidden = false
        case .referralCode:
            self.inputTextField.keyboardType = .numberPad
            self.titleLabel.text = "UserInputView.referralCode".localized
            self.inputTextField.textPadding = .init(top: 6, left: 5, bottom: 0, right: 0)
            self.inputTextField.textAlignment = .left
            self.showPasswordButton.isHidden = true
        case .mobile:
            self.inputTextField.keyboardType = .phonePad
            self.inputTextField.textAlignment = .center
            self.inputTextField.font = UIFont(type: .regular, fontSize: 14)
            self.titleLabel.text = "UserInputView.mobile".localized
            self.showPasswordButton.isHidden = true
        case .name:
            self.inputTextField.keyboardType = .default
            self.titleLabel.text = "UserInputView.name".localized
            self.showPasswordButton.isHidden = true
        case .lastName:
            self.inputTextField.keyboardType = .default
            self.titleLabel.text = "UserInputView.lastName".localized
            self.showPasswordButton.isHidden = true
        case .nationalId:
            self.inputTextField.keyboardType = .numberPad
            self.titleLabel.text = "UserInputView.nationalID".localized
            self.showPasswordButton.isHidden = true
            self.inputTextField.textAlignment = .left
            self.inputTextField.textPadding = .init(top: 6, left: 10, bottom: 0, right: 0)
        case .landlinePhone:
            self.inputTextField.keyboardType = .phonePad
            self.titleLabel.text = "UserInputView.landline".localized
            self.showPasswordButton.isHidden = true
            self.inputTextField.textAlignment = .left
            self.inputTextField.textPadding = .init(top: 3, left: 10, bottom: 0, right: 0)
        case .postalCode:
            self.inputTextField.keyboardType = .numberPad
            self.titleLabel.text = "UserInputView.postalCode".localized
            self.showPasswordButton.isHidden = true
            self.inputTextField.textAlignment = .left
            self.inputTextField.textPadding = .init(top: 3, left: 10, bottom: 0, right: 0)
        case .currentPassword:
            self.inputTextField.keyboardType = .default
            self.inputTextField.isSecureTextEntry = true
            self.titleLabel.text = "UserInputView.currentPassword".localized
            self.showPasswordButton.isHidden = false
        case .newPassword:
            self.inputTextField.keyboardType = .default
            self.inputTextField.isSecureTextEntry = true
            self.titleLabel.text = "UserInputView.newPassword".localized
            self.showPasswordButton.isHidden = false
        case .repeatNewPassword:
            self.inputTextField.keyboardType = .default
            self.inputTextField.isSecureTextEntry = true
            self.titleLabel.text = "UserInputView.repeatNewPassword".localized
            self.showPasswordButton.isHidden = false
        default:
            print("all case covered")
        }
    }
}

extension UserInputView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.submitButtonColor.cgColor
        textField.backgroundColor = .cardsColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 0
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.backgroundColor = .backgroundColor
        delegate?.userInput(input: textField.text ?? "", type: type ?? .email)
    }
}
