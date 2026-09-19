//
//  CreditCardNumberView.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 8/14/21.
//

import UIKit


class CreditCardNumberView: UIView {
    
    var bankInfoViewModel: BankInfoAdapter! {
        didSet {
            self.updateUI()
        }
    }
    
    private var textFieldsArray: [UITextField] = []
    private lazy var title‌Button: UIButton = {
       var button = UIButton()
        button.configure(fontSize: 12, title: "CreditCardNumberView.title".localized, fontType: .bold, titleColor: .textColor, backgroundColor: .clear, borderColor: .clear, cornerRadius: 0)
        button.isUserInteractionEnabled = false
        button.setImage(UIImage(named: "accepted_icon"), for: .selected)
        button.setTitleColor(.submitGreenColor, for: .selected)
        button.imageEdgeInsets = .init(top: -3, left: -5, bottom: 3, right: 5)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private lazy var mainStackView: UIStackView = {
       var stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    
    weak var delegate: BankInfoDelegate?
    
    //MARK: - INITIALIZER
    private let type: BankInformationType
    
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
        createTextFieldsArray()
        addingTextFieldsStack()
        addingTextFieldsToStackView()
    }
    
    private func addingTitleLabel() {
        addSubview(title‌Button)
        title‌Button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            title‌Button.topAnchor.constraint(equalTo: topAnchor),
            title‌Button.trailingAnchor.constraint(equalTo: trailingAnchor),
            title‌Button.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    private func addingTextFieldsStack() {
        addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: title‌Button.bottomAnchor, constant: 5),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func createTextFieldsArray() {
        for item in 0...3 {
            let textField = TextFieldWithPadding()
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.configure(placeholder: "", borderColor: .clear, fontSize: 13, fontType: .regular, keyboardType: .numberPad, textAlignment: .center, radius: 10, backgroundColor: .backgroundColor, textColor:  .textColor)
            textField.delegate = self
            textField.tag = item
            textField.contentVerticalAlignment = .center
            textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
            textField.textPadding = .init(top: 3, left: 0, bottom: 0, right: 0)
            textField.keyboardDistanceFromTextField = 30
            textFieldsArray.append(textField)
        }
        textFieldsArray[0].isEnabled = true
        textFieldsArray[0].backgroundColor = .backgroundColor
    }
    
    private func addingTextFieldsToStackView() {
        for item in textFieldsArray {
            mainStackView.addArrangedSubview(item)
        }
    }
    
    func clearTextFields() {
        for items in textFieldsArray {
            items.text = ""
            items.isEnabled = false
        }
        textFieldsArray[0].isEnabled = true
    }
    
    private func disableAllTextFields() {
        for items in textFieldsArray {
            items.isEnabled = false
        }
    }
    
    private func enableAllTextFields() {
        for items in textFieldsArray {
            items.isEnabled = true
        }
    }
    
    //MARK: - UPDATE UI
    private func updateUI() {
        self.title‌Button.isSelected = !bankInfoViewModel.editable
        if !bankInfoViewModel.editable {
            disableAllTextFields()
            let splitCardNumber = bankInfoViewModel.mainInfo.split(by: 4)
            for i in 0...3 {
                textFieldsArray[i].text = splitCardNumber[i].convertEngNumToPersianNum()
                textFieldsArray[i].backgroundColor = bankInfoViewModel.color.withAlphaComponent(0.2)
                textFieldsArray[i].layer.borderWidth = 1
                textFieldsArray[i].layer.borderColor = bankInfoViewModel.color.cgColor
                textFieldsArray[i].textColor = bankInfoViewModel.color
            }
        }
    }
    //MARK: - Objc Function
    @objc func textFieldDidChange(textField: UITextField) {
        
        let text = textField.text ?? ""
        textField.text = textField.text?.convertEngNumToPersianNum()
        if text.count > 3 {
            if textField.tag < textFieldsArray.count - 1 {
                if textFieldsArray[textField.tag + 1].text?.isEmpty == false  {
                    textField.endEditing(true)
                    return
                }
                textFieldsArray[textField.tag + 1].isEnabled = true
                textFieldsArray[textField.tag + 1].becomeFirstResponder()
            } else {
                textField.endEditing(true)
                enableAllTextFields()
            }
        } else if text.count == 0 {
        }
    }
    
    @objc func mainViewTapped() {
        if let index = textFieldsArray.firstIndex(where: { $0.isEnabled == true }) {
            textFieldsArray[index].becomeFirstResponder()
        }
    }
}

extension CreditCardNumberView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text != nil && textField.text!.count  > 0 {
            textField.text = ""
        }
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.submitButtonColor.cgColor
        let newPosition = textField.endOfDocument
        textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 0
        var code = ""
        for item in textFieldsArray {
            code += item.text ?? "-"
        }
        delegate?.infoFieldNumber(type: type, number: code.persianToEng())
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentCharacterCount = textField.text?.count ?? 0
        if range.length + range.location > currentCharacterCount {
            return false
        }
        let newLength = currentCharacterCount + string.count - range.length
        return newLength <= 4
    }
}
