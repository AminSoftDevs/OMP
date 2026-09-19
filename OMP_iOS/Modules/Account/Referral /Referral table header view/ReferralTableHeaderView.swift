//
//  ReferralTableHeaderView.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 11/27/21.
//

import UIKit

class ReferralTableHeaderView: UIView {
    
    private lazy var receivedProfitLabel: UILabel = {
       var label = UILabel()
        label.configure(text: "ReferralTableHeaderView.profit".localized, fontSize: 13, textColor: .submitButtonColor, textAlignment: .center, fontType: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var friendsShareLabel: UILabel = {
       var label = UILabel()
        label.configure(text: "ReferralTableHeaderView.friend".localized, fontSize: 13, textColor: .submitButtonColor, textAlignment: .center, fontType: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var yourShareLabel: UILabel = {
       var label = UILabel()
        label.configure(text: "ReferralTableHeaderView.you".localized, fontSize: 13, textColor: .submitButtonColor, textAlignment: .center, fontType: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var invitationLinkLabel: UILabel = {
       var label = UILabel()
        label.configure(text: "ReferralTableHeaderView.link".localized, fontSize: 13, textColor: .submitButtonColor, textAlignment: .center, fontType: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var invitationCodeLabel: UILabel = {
       var label = UILabel()
        label.configure(text: "ReferralTableHeaderView.code".localized, fontSize: 13, textColor: .submitButtonColor, textAlignment: .center, fontType: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    //MARK: - INITIALIZER
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - CREATE UI
    private func createUI() {
        addingInvitationCodeLabel()
        addingInvitationLinkButton()
        addingYourShareLabel()
        addingFriendsShareLabel()
        addingReceivedProfitLabel()
    }
    
    private func addingInvitationCodeLabel() {
        addSubview(invitationCodeLabel)
        invitationCodeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            invitationCodeLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            invitationCodeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            invitationCodeLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.26)
        ])
    }
    
    private func addingInvitationLinkButton() {
        addSubview(invitationLinkLabel)
        invitationLinkLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            invitationLinkLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            invitationLinkLabel.trailingAnchor.constraint(equalTo: invitationCodeLabel.leadingAnchor, constant: -12),
            invitationLinkLabel.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func addingYourShareLabel() {
        addSubview(yourShareLabel)
        yourShareLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            yourShareLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            yourShareLabel.trailingAnchor.constraint(equalTo: invitationLinkLabel.leadingAnchor, constant: -14),
            yourShareLabel.widthAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    private func addingFriendsShareLabel() {
        addSubview(friendsShareLabel)
        friendsShareLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            friendsShareLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            friendsShareLabel.trailingAnchor.constraint(equalTo: yourShareLabel.leadingAnchor, constant: -14),
            friendsShareLabel.widthAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    private func addingReceivedProfitLabel() {
        addSubview(receivedProfitLabel)
        receivedProfitLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            receivedProfitLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            receivedProfitLabel.trailingAnchor.constraint(equalTo: friendsShareLabel.leadingAnchor, constant: -16),
            receivedProfitLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
        ])
    }
}
