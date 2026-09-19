//
//  CustomSearchBarView.swift
//  OMP_iOS
//
//  Created by AminSoft on 7/4/1400 AP.
//

import UIKit

protocol SendingValueFromTextFieldDelegate: AnyObject {
    func sendingTextFromTextField(_ text: String)
}

class CustomSearchBarView: UIView {
    
    //MARK: - PROPERTIES
    lazy var iconSearchBar: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "searchIcon")?.withRenderingMode(.alwaysTemplate)
        imageView.backgroundColor = .clear
        imageView.tintColor = .textFiledBorderColor
        return imageView
    }()
    
    lazy var textFieldSearchBar: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.configure(placeholder: "\("search".localized)...", borderColor: .clear, fontSize: 14, fontType: .regular, keyboardType: .default, textAlignment: .right, radius: 0, backgroundColor: .clear, textColor: .textFieldPlaceholderColor)
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return textField
    }()
//    Delegate
    weak var delegate: SendingValueFromTextFieldDelegate?
    //    MARK: - INITIALIZERS
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
//    MARK: - OBJC FUNC
    @objc private func textFieldDidChange() {
        if let unwrappedText = textFieldSearchBar.text {
            self.delegate?.sendingTextFromTextField(unwrappedText)
        } else {
            return
        }
    }
    
//    MARK: - CREATE UI
    private func createUI() {
        self.layer.cornerRadius = 15
        self.layer.borderWidth = 1.5
        self.layer.borderColor = UIColor.textFiledBorderColor.cgColor
        
        addingIconSearchBar()
        addingTextFieldSearchBar()
    }
    
    private func addingIconSearchBar() {
        self.addSubview(iconSearchBar)
        NSLayoutConstraint.activate([
            iconSearchBar.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconSearchBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            iconSearchBar.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.1),
            iconSearchBar.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7)
        ])
    }
    
    private func addingTextFieldSearchBar() {
        self.addSubview(textFieldSearchBar)
        NSLayoutConstraint.activate([
            textFieldSearchBar.centerYAnchor.constraint(equalTo: centerYAnchor),
            textFieldSearchBar.trailingAnchor.constraint(equalTo: iconSearchBar.leadingAnchor, constant: -5),
            textFieldSearchBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            textFieldSearchBar.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.9)
        ])
    }
}

// MARK: - UITEXTFIELD DELEGATE
extension CustomSearchBarView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.becomeFirstResponder()
        if let unwrappedText = textFieldSearchBar.text {
            delegate?.sendingTextFromTextField(unwrappedText)
            return true
        } else {
            return false
        }
    }
}
