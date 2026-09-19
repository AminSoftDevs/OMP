//
//  VerificationCodeView.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 9/5/20.
//  Copyright © 2020 soroush amini araste. All rights reserved.
//

import UIKit

class VerificationCodeView: UIView {
    
    
    var newCodeRequested: Bool = false {
        didSet {
            clearTextFields()
        }
    }
    var textFieldsArray: [UITextField] = []
    var codeFieldsStackView: UIStackView = {
       var stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        return stackView
    }()
    
    
    var delegate: VerificationViewDelegate?
    
    //MARK: - Default Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - INITIALIZE UI
    fileprivate func createUI() {
        createTextFieldsArray()
        addingTextFieldsStack()
        addingTextFieldsToStackView()
    }
    
    fileprivate func addingTextFieldsStack() {
        addSubview(codeFieldsStackView)
        codeFieldsStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: codeFieldsStackView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: codeFieldsStackView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: codeFieldsStackView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: codeFieldsStackView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    }
    fileprivate func createTextFieldsArray() {
        for item in 0...4 {
            let textField = UITextField()
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.configure(placeholder: "", borderColor: .clear, fontSize: 25, fontType: .bold, keyboardType: .numberPad, textAlignment: .center, radius: 10, backgroundColor: .backgroundColor, textColor:  .textColor)
            textField.delegate = self
            textField.tag = item
            //textField.isEnabled = false
            textField.contentVerticalAlignment = .center
            textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
            textFieldsArray.append(textField)
        }
        textFieldsArray[0].isEnabled = true
        textFieldsArray[0].backgroundColor = .backgroundColor
    }
    
    fileprivate func addingTextFieldsToStackView() {
        for item in textFieldsArray {
            codeFieldsStackView.addArrangedSubview(item)
        }
    }
    
    fileprivate func clearTextFields() {
        for items in textFieldsArray {
            items.text = ""
            items.isEnabled = false
        }
        textFieldsArray[0].isEnabled = true
        textFieldsArray.first?.becomeFirstResponder()
    }
    
    fileprivate func disableAllTextFields() {
        for items in textFieldsArray {
            items.isEnabled = false
        }
    }
    
    fileprivate func enableAllTextFields() {
        for items in textFieldsArray {
            items.isEnabled = true
        }
    }
    //MARK: - Objc Function
    @objc func textFieldDidChange(textField: UITextField) {
        
        //Dark - bcbcbc
        //Light - dfdede
        let text = textField.text ?? ""
        if text.count > 0 {
            if textField.tag < textFieldsArray.count - 1 {
                //textField.isEnabled = false
                if textFieldsArray[textField.tag + 1].text?.isEmpty == false  {
                    textField.endEditing(true)
                    return
                }
                textFieldsArray[textField.tag + 1].isEnabled = true
                textFieldsArray[textField.tag + 1].becomeFirstResponder()
            } else {
                textField.endEditing(true)
                enableAllTextFields()
                //delegate?.verificationFieldEndEditing(text: textField.text)
            }
        } else if text.count < 1 {
            if textField.tag > 0 {
                if textFieldsArray[textField.tag - 1].text == "" {
                    print("I'M HERE")
                } else {
                    if textField.tag == 0 {
                        disableAllTextFields()
                        textFieldsArray.first?.isEnabled = true
                    }
                    
                    textFieldsArray[textField.tag - 1].isEnabled = true
                    textFieldsArray[textField.tag - 1].becomeFirstResponder()
                }
            }
        }
    }
    
    @objc func mainViewTapped() {
        if let index = textFieldsArray.firstIndex(where: { $0.isEnabled == true }) {
            textFieldsArray[index].becomeFirstResponder()
        }
    }
}

extension VerificationCodeView: UITextFieldDelegate {
    
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
        delegate?.verificationFieldEndEditing(text: code)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentCharacterCount = textField.text?.count ?? 0
        if range.length + range.location > currentCharacterCount {
            return false
        }
        let newLength = currentCharacterCount + string.count - range.length
        return newLength <= 1
    }
}
