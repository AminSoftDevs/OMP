//
//  AccountNumberView.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 8/14/21.
//

import UIKit


class AccountNumberView: UIView {
    
    var bankInfoViewModel: BankInfoAdapter! {
        didSet {
            self.updateUI()
        }
    }
    
    private lazy var title‌Button: UIButton = {
        var button = UIButton()
        button.configure(fontSize: 12, title: "AccountNumberView.title".localized, fontType: .bold, titleColor: .textColor, backgroundColor: .clear, borderColor: .clear, cornerRadius: 0)
        button.isUserInteractionEnabled = false
        button.setImage(UIImage(named: "accepted_icon"), for: .selected)
        button.setTitleColor(.submitGreenColor, for: .selected)
        button.imageEdgeInsets = .init(top: -3, left: -5, bottom: 3, right: 5)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private lazy var accountNumberTextField: TextFieldWithPadding = {
        var textField = TextFieldWithPadding()
        textField.configure(placeholder: "", borderColor: .clear, fontSize: 14, fontType: .regular, keyboardType: .numberPad, textAlignment: .left, radius: 10, backgroundColor: .backgroundColor, textColor: .textColor)
        textField.textPadding = .init(top: 4, left: 30, bottom: 0, right: 0)
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    private lazy var currencyLabel: UILabel = {
       var label = UILabel()
        label.configure(text: "IR", fontSize: 14, textColor: .textColor, textAlignment: .left, fontType: .regular)
        return label
    }()
    
    weak var delegate: BankInfoDelegate?
    private let type: BankInformationType
    
    //MARK: - Default Init
    init(type: BankInformationType) {
        self.type = type
        super.init(frame: .zero)
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - INITIALIZE UI
    private func createUI() {
        addingTitleLabel()
        addingBankAccountTextField()
        addingCurrencyLabel()
    }
    
    private func addingTitleLabel() {
        addSubview(title‌Button)
        title‌Button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            title‌Button.topAnchor.constraint(equalTo: topAnchor),
            title‌Button.trailingAnchor.constraint(equalTo: trailingAnchor),
            title‌Button.heightAnchor.constraint(equalToConstant: 25),
        ])
    }
    
    private func addingBankAccountTextField() {
        addSubview(accountNumberTextField)
        accountNumberTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            accountNumberTextField.topAnchor.constraint(equalTo: title‌Button.bottomAnchor, constant: 5),
            accountNumberTextField.trailingAnchor.constraint(equalTo: trailingAnchor),
            accountNumberTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
            accountNumberTextField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
        ])
    }
    
    private func addingCurrencyLabel() {
        addSubview(currencyLabel)
        currencyLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            currencyLabel.centerYAnchor.constraint(equalTo: accountNumberTextField.centerYAnchor, constant: 2),
            currencyLabel.leadingAnchor.constraint(equalTo: accountNumberTextField.leadingAnchor, constant: 20),
            currencyLabel.widthAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    //MARK: - UPDATE UI
    private func updateUI() {
        title‌Button.isSelected = !bankInfoViewModel.editable
        if !bankInfoViewModel.editable {
            accountNumberTextField.isEnabled = false
            accountNumberTextField.text = bankInfoViewModel.mainInfo.convertEngNumToPersianNum()
            accountNumberTextField.backgroundColor = bankInfoViewModel.color.withAlphaComponent(0.2)
            accountNumberTextField.layer.borderWidth = 1
            accountNumberTextField.layer.borderColor = bankInfoViewModel.color.cgColor
            accountNumberTextField.textColor = bankInfoViewModel.color
            currencyLabel.textColor = bankInfoViewModel.color
        }
    }
    
    func clearTextField() {
        self.accountNumberTextField.text = ""
    }
    
    //MARK: - Objc Function
    @objc func textFieldDidChange(textField: UITextField) {
        guard let text = textField.text else { return }
        if text.count > 23 {
            accountNumberTextField.resignFirstResponder()
        }
        accountNumberTextField.text = text.keepNumbers()
    }
}

extension AccountNumberView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.submitButtonColor.cgColor
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 0
        guard let text = textField.text , !text.isEmpty else { return }
        delegate?.infoFieldNumber(type: type, number: text.persianToEng())
    }
}
