//
//  ReferralTableViewCell.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 11/24/21.
//

import UIKit

class ReferralTableViewCell: UITableViewCell {

    var referral: ReferralElement? {
        didSet {
            updateUI()
        }
    }
    
    private lazy var containerView: UIView = {
        var view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var receivedProfitLabel: UILabel = {
       var label = UILabel()
        label.configure(text: "", fontSize: 13, textColor: .submitButtonColor, textAlignment: .center, fontType: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var friendsShareLabel: UILabel = {
       var label = UILabel()
        label.configure(text: "", fontSize: 13, textColor: .submitButtonColor, textAlignment: .center, fontType: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var yourShareLabel: UILabel = {
       var label = UILabel()
        label.configure(text: "".localized, fontSize: 13, textColor: .submitButtonColor, textAlignment: .center, fontType: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var invitationLinkButton: UIButton = {
       var button = UIButton()
        button.setImage(UIImage(named: "copy_icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .submitButtonColor
        button.addTarget(self, action: #selector(invitationLinkButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var invitationCodeLabel: UILabel = {
       var label = UILabel()
        label.configure(text: "", fontSize: 13, textColor: .submitButtonColor, textAlignment: .center, fontType: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    //MARK: - DEFAULT INITIALIZER
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        createUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - CREATE UI
    private func createUI() {
        addingContainerView()
        addingInvitationCodeLabel()
        addingInvitationLinkButton()
        addingYourShareLabel()
        addingFriendsShareLabel()
        addingReceivedProfitLabel()
    }
    
    private func addingContainerView() {
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 1),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1),
        ])
    }
    
    private func addingInvitationCodeLabel() {
        containerView.addSubview(invitationCodeLabel)
        invitationCodeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            invitationCodeLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            invitationCodeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            invitationCodeLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.28)
        ])
    }
    
    private func addingInvitationLinkButton() {
        containerView.addSubview(invitationLinkButton)
        invitationLinkButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            invitationLinkButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            invitationLinkButton.trailingAnchor.constraint(equalTo: invitationCodeLabel.leadingAnchor, constant: -10),
            invitationLinkButton.widthAnchor.constraint(equalToConstant: 27),
            invitationLinkButton.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    private func addingYourShareLabel() {
        containerView.addSubview(yourShareLabel)
        yourShareLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            yourShareLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            yourShareLabel.trailingAnchor.constraint(equalTo: invitationLinkButton.leadingAnchor, constant: -20),
            yourShareLabel.widthAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    private func addingFriendsShareLabel() {
        containerView.addSubview(friendsShareLabel)
        friendsShareLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            friendsShareLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            friendsShareLabel.trailingAnchor.constraint(equalTo: yourShareLabel.leadingAnchor, constant: -20),
            friendsShareLabel.widthAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    private func addingReceivedProfitLabel() {
        containerView.addSubview(receivedProfitLabel)
        receivedProfitLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            receivedProfitLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            receivedProfitLabel.trailingAnchor.constraint(equalTo: friendsShareLabel.leadingAnchor, constant: -15),
            receivedProfitLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
        ])
    }
    
    //MARK: - OBJC FUNCTIONS
    @objc func invitationLinkButtonPressed() {
        guard let item = referral else { return }
        Popup.showSuccess(title: "savedToClipboard", body: item.getInvitationLink)
        UIPasteboard.general.string = item.getInvitationLink
    }
    
    //MARK: - UPDATE UI
    private func updateUI() {
        guard let item = referral else { return }
        invitationCodeLabel.text = item.id
        yourShareLabel.text = item.yourShare
        friendsShareLabel.text = item.othersShare
        receivedProfitLabel.text = item.profit
    }
}
