//
//  FinalScreenIdentityVerification.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 8/17/21.
//

import UIKit

protocol FinalScreenIdentityVerificationViewDelegate: AnyObject {
    func backToMainScreen()
}

class FinalScreenIdentityVerificationView: UIView {
    
    lazy var checkBoxImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "success_checkBox_icon")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var successLabel: UILabel = {
        var label = UILabel()
        label.configure(text: "FinalScreenIdentityVerificationView.success".localized, fontSize: 14, textColor: .init(hex: "55E0B3"), textAlignment: .center, fontType: .bold)
        return label
    }()
    
    lazy var continueButton: UIButton = {
       var button = UIButton()
        button.configure(fontSize: 12, title: "FinalScreenIdentityVerificationView.backButton" .localized, fontType: .regular, titleColor: .backgroundColor, backgroundColor: .submitButtonColor, borderColor: .clear, cornerRadius: 10)
        button.addTarget(self, action: #selector(continueButtonPressed), for: .touchUpInside)
        return button
    }()
    
    weak var delegate: FinalScreenIdentityVerificationViewDelegate?
    
    //MARK: - DEFAULT INIT
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .cardsColor
        self.layer.cornerRadius = 10
        self.addingSuccessfulCheckbox()
        self.addingContinueButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - CREATE UI
    fileprivate func addingSuccessfulCheckbox() {
        self.addSubview(checkBoxImageView)
        self.checkBoxImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: checkBoxImageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 100).isActive = true
        NSLayoutConstraint(item: checkBoxImageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: checkBoxImageView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0, constant: 40).isActive = true
        NSLayoutConstraint(item: checkBoxImageView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 40).isActive = true
        
        self.addSubview(successLabel)
        self.successLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: successLabel, attribute: .top, relatedBy: .equal, toItem: self.checkBoxImageView, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: successLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: successLabel, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: successLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 30).isActive = true
    }
    
    fileprivate func addingContinueButton() {
        self.addSubview(continueButton)
        self.continueButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: continueButton, attribute: .top, relatedBy: .equal, toItem: successLabel, attribute: .bottom, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: continueButton, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: continueButton, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: continueButton, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 50).isActive = true
    }
    
    //MARK: - OBJC FUNCTIONS
    @objc func continueButtonPressed() {
        self.delegate?.backToMainScreen()
    }
}
