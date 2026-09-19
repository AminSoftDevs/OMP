//
//  WalletAddressView.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 10/1/21.
//

import UIKit

class WalletAddressView: UIView {
    
    var textAlignment: NSTextAlignment = .center {
        didSet {
            mainTextView.textAlignment = textAlignment
        }
    }
    var inputText: String = "" {
        didSet {
            self.mainTextView.text = inputText.convertEngNumToPersianNum()
        }
    }
    
    private lazy var mainTextView: UITextView = {
        var textView = UITextView()
        textView.text = ""
        textView.layer.borderWidth = 2.5
        textView.layer.borderColor = UIColor.textFiledBorderColor.cgColor
        textView.layer.cornerRadius = 15
        textView.isEditable  = false
        textView.font = UIFont(type: .regular, fontSize: 13)
        textView.textContainerInset = .init(top: 20, left: 15, bottom: 15, right: 15)
        textView.textColor = .textColor
        textView.autocorrectionType = .no
        textView.autocapitalizationType = .none
        textView.textAlignment = .center
        textView.backgroundColor = .clear
        textView.textContainer.lineBreakMode = .byTruncatingTail
        textView.isScrollEnabled = false
        textView.sizeToFit()
        return textView
    }()
    
    private lazy var copyToClipboardButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(named: "copy_icon"), for: .normal)
        button.tintColor = .submitGreenColor
        button.layer.cornerRadius = 15
        button.backgroundColor = .submitGreenColor.withAlphaComponent(0.15)
        button.addTarget(self, action: #selector(copyToClipboardButtonPressed), for: .touchUpInside)
        return button
    }()
    
    //MARK: - DEFAULT INITIALIZER
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - CREATE UI
    fileprivate func createUI() {
        self.addingWalletAddressTextView()
        self.addingCopyToClipboardButton()
    }
    
    fileprivate func addingWalletAddressTextView() {
        self.addSubview(mainTextView)
        self.mainTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainTextView.topAnchor.constraint(equalTo: topAnchor),
            mainTextView.widthAnchor.constraint(equalTo: widthAnchor, constant: -70),
            mainTextView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainTextView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    fileprivate func addingCopyToClipboardButton() {
        self.addSubview(copyToClipboardButton)
        self.copyToClipboardButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            copyToClipboardButton.centerYAnchor.constraint(equalTo: mainTextView.centerYAnchor),
            copyToClipboardButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            copyToClipboardButton.widthAnchor.constraint(equalToConstant: 60),
            copyToClipboardButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    func changeIconColor(iconColor: UIColor = .submitGreenColor, backgroundColor: UIColor = .submitGreenColor) {
        copyToClipboardButton.tintColor = iconColor
        copyToClipboardButton.backgroundColor = backgroundColor.withAlphaComponent(0.15)
    }
    
    //MARK: - OBJC FUNCTIONS
    @objc func copyToClipboardButtonPressed() {
        Popup.showSuccess(title: "savedToClipboard", body: inputText)
        UIPasteboard.general.string = inputText
    }
}
