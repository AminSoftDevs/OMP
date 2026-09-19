//
//  UITextField.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 7/28/21.
//

import Foundation
import UIKit

extension UITextField {
    
    func configure(placeholder:String, borderColor: UIColor, fontSize:CGFloat, fontType: FontString = .regular, keyboardType: UIKeyboardType = .default, textAlignment:NSTextAlignment = .right, radius:CGFloat = 5, backgroundColor: UIColor = .textColor, textColor: UIColor = .black) {
        self.textColor = textColor
        let placeholderString = NSAttributedString.init(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.textFieldPlaceholderColor])
        self.attributedPlaceholder = placeholderString
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = radius
        self.layer.borderWidth = 0.5
        self.layer.borderColor = borderColor.cgColor
        self.font = UIFont.init(type: fontType, fontSize: fontSize)
        self.keyboardType = keyboardType
        self.textAlignment = textAlignment
        if self.textAlignment != .center{
            self.addPadding(.both(10))
        }
    }
    
    enum PaddingSide {
        case left(CGFloat)
        case right(CGFloat)
        case both(CGFloat)
    }
    
    func addPadding(_ padding: PaddingSide) {
        self.rightViewMode = .always
        self.layer.masksToBounds = true
        
        switch padding {
        case .left(let spacing):
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            self.leftView = paddingView
            self.rightViewMode = .always
        case .right(let spacing):
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            self.rightView = paddingView
            self.rightViewMode = .always
        case .both(let spacing):
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            // left
            self.leftView = paddingView
            self.leftViewMode = .always
            // right
            self.rightView = paddingView
            self.rightViewMode = .always
        }
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "تایید", style: .done, target: self, action: #selector(self.doneButtonAction))
        done.setTitleTextAttributes(
            [
                NSAttributedString.Key.font : UIFont(name: FontString.bold.rawValue, size: 14)!,
                NSAttributedString.Key.foregroundColor : UIColor.init(hex: "405aaf"),
            ], for: .normal)
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
    
    
}

class TextFieldWithPadding: UITextField {
    var textPadding = UIEdgeInsets(
        top: 0,
        left: 0,
        bottom: 0,
        right: 0
    )
    
    var leftViewPadding = UIEdgeInsets(
        top: 0,
        left: 0,
        bottom: 0,
        right: 0
    )

    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.leftViewRect(forBounds: bounds)
        return rect.inset(by: leftViewPadding)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
}
