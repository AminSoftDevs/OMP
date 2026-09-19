//
//  IdentityVerificationNoticeView.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 8/7/21.
//

import UIKit

protocol IdentityVerificationNoticeViewDelegate: AnyObject {
    func closeButtonPressed()
    func actionButtonPressed()
}

extension IdentityVerificationNoticeViewDelegate {
    func closeButtonPressed() {}
}

class IdentityVerificationNoticeView: UIView  {
    
    private lazy var closeButton: UIButton = {
        var button = UIButton()
        let image = UIImage(named: "close_icon")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var contentLabel: UILabel = {
       var label = UILabel()
        let text = "IdentityVerificationNoticeView.centralBankOrder".localized
        label.configure(text: text, fontSize: 13, textColor: .textColor, textAlignment: .center, fontType: .bold)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.setText(text, withColorPart: "IdentityVerificationNoticeView.identityVerification".localized, color: .submitGreenColor)
        return label
    }()
    
    private lazy var userActionButton: UIButton = {
       var button = UIButton()
        button.configure(fontSize: 12, title: "IdentityVerificationNoticeView.identityVerification".localized, fontType: .regular, titleColor: .backgroundColor, backgroundColor: .submitButtonColor, borderColor: .clear, cornerRadius: 10)
        button.addTarget(self, action: #selector(identityVerificationButtonPressed), for: .touchUpInside)
        return button
    }()
    
    weak var delegate: IdentityVerificationNoticeViewDelegate?
    
    //MARK: - DEFAULT INITIALIZER
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 15
        backgroundColor = .cardsColor
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - CREATE UI
    private func createUI() {
        addingCloseButton()
        addingContentLabel()
        addingUserActionButton()
    }
    
    private func addingCloseButton() {
        addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            closeButton.widthAnchor.constraint(equalToConstant: 25),
            closeButton.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    private func addingContentLabel() {
        addSubview(contentLabel)
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 20),
            contentLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -40),
        ])
    }
    
    private func addingUserActionButton() {
        addSubview(userActionButton)
        userActionButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userActionButton.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 25),
            userActionButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            userActionButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            userActionButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    //MARK: - OBJC FUNCTIONS
    @objc func closeButtonPressed() {
        delegate?.closeButtonPressed()
    }
    
    @objc func identityVerificationButtonPressed() {
        delegate?.actionButtonPressed()
    }
}
