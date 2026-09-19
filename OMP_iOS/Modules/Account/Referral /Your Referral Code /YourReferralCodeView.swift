//
//  YourReferralCodeView.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 11/25/21.
//

import UIKit

class YourReferralCodeView: UIView {
    
    private lazy var yourCodeTitleLabel: UILabel = {
       var label = UILabel()
        label.configure(text: "ReferralViewController.yourCodesTitleView".localized, fontSize: 13, textColor: .mediumGrayColor, textAlignment: .right, fontType: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var yourInvitationLinkTitleLabel: UILabel = {
       var label = UILabel()
        label.configure(text: "ReferralViewController.yourLinkTitleView".localized, fontSize: 13, textColor: .mediumGrayColor, textAlignment: .right, fontType: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var helperTextView: UITextView = {
        var textView = UITextView()
        textView.text = "ReferralViewController.noInvitationCode".localized
        textView.backgroundColor = .clear
        textView.textColor = .textColor
        textView.textAlignment = .justified
        textView.font = UIFont(type: .regular, fontSize: 14)
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    private lazy var yourInvitationCodeView: WalletAddressView = WalletAddressView()
    private lazy var yourInvitationLinkView: WalletAddressView = WalletAddressView()
    
    private lazy var yourCodesTitleView: ReferralTitleView = ReferralTitleView(title: "ReferralViewController.yourCodesTitleView".localized)
    //MARK: - DEFAULT INITIALIZER
    private let referred: Bool
    
    init(referred: Bool) {
        self.referred = referred
        super.init(frame: .zero)
        backgroundColor = .cardsColor
        layer.cornerRadius = 20
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - CREATE UI
    private func createUI() {
        addingUsersStatisticsTitleView()
        
        if referred {
            addingYourCodeTitleLabel()
            addingYourInvitationCodeView()
            addingYourLinkTitleLabel()
            addingYourInvitationLinkView()
            heightAnchor.constraint(equalToConstant: 290).isActive = true
        } else {
            addingHelperTextView()
            let sizeThatFitsTextView = helperTextView.sizeThatFits(CGSize(width: Constants.screenWidth - 40, height: CGFloat(MAXFLOAT)))
            heightAnchor.constraint(equalToConstant: sizeThatFitsTextView.height + 100).isActive = true
        }
    }
    
    private func addingUsersStatisticsTitleView() {
        addSubview(yourCodesTitleView)
        yourCodesTitleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            yourCodesTitleView.topAnchor.constraint(equalTo: topAnchor , constant: 15),
            yourCodesTitleView.leadingAnchor.constraint(equalTo: leadingAnchor , constant: 20),
            yourCodesTitleView.trailingAnchor.constraint(equalTo: trailingAnchor , constant: -20),
            yourCodesTitleView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func addingYourCodeTitleLabel() {
        addSubview(yourCodeTitleLabel)
        yourCodeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            yourCodeTitleLabel.topAnchor.constraint(equalTo: yourCodesTitleView.bottomAnchor , constant: 30),
            yourCodeTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor , constant: -15),
            yourCodeTitleLabel.widthAnchor.constraint(equalTo: widthAnchor , multiplier: 0.2),
        ])
    }
    
    private func addingYourInvitationCodeView() {
        addSubview(yourInvitationCodeView)
        yourInvitationCodeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            yourInvitationCodeView.topAnchor.constraint(equalTo: yourCodesTitleView.bottomAnchor , constant: 15),
            yourInvitationCodeView.leadingAnchor.constraint(equalTo: leadingAnchor , constant: 20),
            yourInvitationCodeView.trailingAnchor.constraint(equalTo: yourCodeTitleLabel.leadingAnchor , constant: -10),
            yourInvitationCodeView.heightAnchor.constraint(equalToConstant: 60)
        ])
        yourInvitationCodeView.changeIconColor(iconColor: .submitButtonColor, backgroundColor: .backgroundColor)
    }
    
    private func addingYourLinkTitleLabel() {
        addSubview(yourInvitationLinkTitleLabel)
        yourInvitationLinkTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            yourInvitationLinkTitleLabel.topAnchor.constraint(equalTo: yourInvitationCodeView.bottomAnchor , constant: 30),
            yourInvitationLinkTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor , constant: -15),
            yourInvitationLinkTitleLabel.widthAnchor.constraint(equalTo: widthAnchor , multiplier: 0.2)
        ])
    }
    
    private func addingYourInvitationLinkView() {
        addSubview(yourInvitationLinkView)
        yourInvitationLinkView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            yourInvitationLinkView.topAnchor.constraint(equalTo: yourInvitationCodeView.bottomAnchor , constant: 15),
            yourInvitationLinkView.leadingAnchor.constraint(equalTo: leadingAnchor , constant: 20),
            yourInvitationLinkView.trailingAnchor.constraint(equalTo: yourInvitationLinkTitleLabel.leadingAnchor , constant: -10),
            yourInvitationLinkView.heightAnchor.constraint(equalToConstant: 120)
        ])
        yourInvitationLinkView.changeIconColor(iconColor: .submitButtonColor, backgroundColor: .backgroundColor)
        yourInvitationLinkView.textAlignment = .left
    }
    
    private func addingHelperTextView() {
        addSubview(helperTextView)
        helperTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            helperTextView.topAnchor.constraint(equalTo: yourCodesTitleView.bottomAnchor , constant: 10),
            helperTextView.leadingAnchor.constraint(equalTo: leadingAnchor , constant: 20),
            helperTextView.trailingAnchor.constraint(equalTo: trailingAnchor , constant: -20),
            helperTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant:  -10)
        ])
    }
    
    //MARK: - UPDATE INFORMATION
    func updateInvitationCodeAndLink(code: String, link: String) {
        yourInvitationCodeView.inputText = code
        yourInvitationLinkView.inputText = link
    }
}
