//
//  ReferralNoticeViewController.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 11/28/21.
//

import UIKit

class ReferralNoticeViewController: UIViewController {
    
    private lazy var popupContainerView: UIView = {
        var view = UIView()
        view.backgroundColor = .cardsColor
        view.layer.cornerRadius = 15
        return view
    }()
    
    private lazy var popupIconImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "Info-Circle")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .submitButtonColor
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
       var label = UILabel()
        label.configure(text: "AccountViewController.userGuid".localized, fontSize: 12, textColor: .submitButtonColor, textAlignment: .center, fontType: .regular)
        return label
    }()
    
    private lazy var messageTextView: UITextView = {
        var textView = UITextView()
        textView.text = "ReferralNoticeViewController.mainMessage".localized
        textView.backgroundColor = .clear
        textView.textColor = .textColor
        textView.textAlignment = .justified
        textView.font = UIFont(type: .regular, fontSize: 14)
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    private lazy var dismissButton: UIButton = {
       var button = UIButton()
        button.configure(fontSize: 12, title: "ok".localized, fontType: .regular, titleColor: .backgroundColor, backgroundColor: .submitButtonColor, borderColor: .clear, cornerRadius: 10)
        button.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        return button
    }()
    
    //MARK: - VIEW CONTROLLER LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        createUI()
    }
    
    private func createUI() {
        addingContainerView()
        addingPopupIconImageView()
        addingTitleLabel()
        addingMessageTextView()
        addingDismissButton()
    }
    
    private func addingContainerView() {
        view.addSubview(popupContainerView)
        popupContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            popupContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            popupContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            popupContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -30),
        ])
    }
    
    private func addingPopupIconImageView() {
        popupContainerView.addSubview(popupIconImageView)
        popupIconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            popupIconImageView.topAnchor.constraint(equalTo: popupContainerView.topAnchor, constant: 20),
            popupIconImageView.centerXAnchor.constraint(equalTo: popupContainerView.centerXAnchor),
            popupIconImageView.widthAnchor.constraint(equalToConstant: 40),
            popupIconImageView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func addingTitleLabel() {
        popupContainerView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: popupIconImageView.bottomAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: popupIconImageView.centerXAnchor)
        ])
    }
    
    private func addingMessageTextView() {
        popupContainerView.addSubview(messageTextView)
        messageTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            messageTextView.leadingAnchor.constraint(equalTo: popupContainerView.leadingAnchor, constant: 10),
            messageTextView.widthAnchor.constraint(equalTo: popupContainerView.widthAnchor, constant: -20),
        ])
        
        let sizeThatFitsTextView = messageTextView.sizeThatFits(CGSize(width: view.frame.width - 30 - 20, height: CGFloat(MAXFLOAT)))
        popupContainerView.heightAnchor.constraint(equalToConstant: 185 + sizeThatFitsTextView.height).isActive = true
        messageTextView.heightAnchor.constraint(equalToConstant: sizeThatFitsTextView.height).isActive = true
    }
    
    private func addingDismissButton() {
        popupContainerView.addSubview(dismissButton)
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dismissButton.widthAnchor.constraint(equalTo: popupContainerView.widthAnchor, multiplier: 0.3),
            dismissButton.heightAnchor.constraint(equalToConstant: 48),
            dismissButton.centerXAnchor.constraint(equalTo: popupContainerView.centerXAnchor),
            dismissButton.topAnchor.constraint(equalTo: messageTextView.bottomAnchor, constant: 10)
        ])
    }
    //MARK: - OBJC FUNCTIONS
    @objc func dismissAction() {
        dismiss(animated: true, completion: nil)
    }
}
