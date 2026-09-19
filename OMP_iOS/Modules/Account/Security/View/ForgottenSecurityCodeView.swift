//
//  ForgottenSecurityCodeView.swift
//  OMP_iOS
//
//  Created by AminSoft on 9/10/1400 AP.
//

import UIKit

protocol ForgottenSecurityCodeProtocol: AnyObject {
    func closeButtonAction()
    func confirmButtonAction()
}

class ForgottenSecurityCodeView: UIView {

    // MARK: - properties
    private lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configure(text: "SecurityViewController.confirmOpenedAppLock".localized, fontSize: 14, textColor: .textColor, textAlignment: .center, fontType: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var closeButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configure(fontSize: 0, title: "", fontType: .regular, titleColor: .clear, backgroundColor: .clear, borderColor: .clear)
        button.setImage(UIImage(named: "close_icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = UIColor.textColor
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var confirmButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configure(fontSize: 14, title: "confirm".localized, fontType: .regular, titleColor: .textColor, backgroundColor: .submitButtonColor, borderColor: .clear)
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // DELEGATE
    weak var delegate: ForgottenSecurityCodeProtocol?
    
    //MARK: - INITLIZER
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .cardsColor
        layer.cornerRadius = 15
        layer.masksToBounds = true
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - CREATE UI
    private func createUI() {
        addingCloseButton()
        addingTitleLabel()
        addingConfirmButton()
    }
    
    private func addingCloseButton() {
        addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            closeButton.widthAnchor.constraint(equalToConstant: 38),
            closeButton.heightAnchor.constraint(equalToConstant: 38)
        ])
    }
    
    private func addingTitleLabel() {
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.85)
        ])
    }
    
    private func addingConfirmButton() {
        addSubview(confirmButton)
        NSLayoutConstraint.activate([
            confirmButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            confirmButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            confirmButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4),
            confirmButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    //MARK: - OBJC FUNC
    @objc private func closeButtonTapped() {
        delegate?.closeButtonAction()
    }
    
    @objc private func confirmButtonTapped() {
        delegate?.confirmButtonAction()
    }
}
