//
//  DefaultNavigationBarView.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 9/30/21.
//

import UIKit

protocol DefaultNavigationBarViewProtocol: AnyObject {
    func backButtonPressed()
    func leftSideButtonPressed()
}

extension DefaultNavigationBarViewProtocol {
    func leftSideButtonPressed() {}
}

class DefaultNavigationBarView: UIView {
    
    private lazy var titleLabel: UILabel = {
       var label = UILabel()
        label.configure(text: "", fontSize: Constants.navFontSize , textColor: .textColor, textAlignment: .center, fontType: .regular)
        return label
    }()
    
    private lazy var backButton: UIButton = {
       var button = UIButton()
        button.setImage(UIImage(named: "back_arrow_icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .textColor
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 0.8
        button.layer.borderColor = UIColor.mediumGrayColor.cgColor
        button.imageView?.transform = dir == .leftToRight ? CGAffineTransform(scaleX: -1, y: 1) : CGAffineTransform(scaleX: 1, y: 1)
        button.tintColor = .mediumGrayColor
        return button
    }()
    
    private lazy var leftHandSideButton: UIButton = {
       var button = UIButton()
        button.addTarget(self, action: #selector(leftSideButtonPressed), for: .touchUpInside)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 0.8
        button.layer.borderColor = UIColor.mediumGrayColor.cgColor
        return button
    }()
    
    let dir = Localization.sharedInstance.getlanguageDirection()
    
    //MARK: - DELEGATE
    weak var delegate: DefaultNavigationBarViewProtocol?
    
    //MARK: - INITIALIZER
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, hasBackButton: Bool = true, leftSideButtonName: String? = nil, shouldHaveRadius: Bool = true) {
        navigationBarStyle(shouldHaveRadius: shouldHaveRadius)
        addingTitleLabel(title: title)
        addingBackButton(hasBackButton: hasBackButton)
        addingLeftHandSideButton(iconName: leftSideButtonName)
    }
    
    fileprivate func navigationBarStyle(shouldHaveRadius: Bool) {
        backgroundColor = .cardsColor
        if shouldHaveRadius {
            self.layer.cornerRadius = 15
            self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
    }
    
    fileprivate func addingBackButton(hasBackButton: Bool) {
        if hasBackButton == false {
            return
        }
        addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
            backButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            backButton.widthAnchor.constraint(equalToConstant: 35),
            backButton.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    fileprivate func addingTitleLabel(title: String) {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -1)
        ])
        titleLabel.text = title
    }
    
    fileprivate func addingLeftHandSideButton(iconName: String?) {
        if iconName == nil {
            return
        }
        addSubview(leftHandSideButton)
        leftHandSideButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leftHandSideButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
            leftHandSideButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            leftHandSideButton.widthAnchor.constraint(equalToConstant: 35),
            leftHandSideButton.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        leftHandSideButton.setImage(UIImage(named: iconName!)?.withRenderingMode(.alwaysTemplate), for: .normal)
        leftHandSideButton.tintColor = .textColor
    }
    //MARK: - OBJC FUNCTION
    @objc func backButtonPressed() {
        delegate?.backButtonPressed()
    }
    
    @objc func leftSideButtonPressed() {
        delegate?.leftSideButtonPressed()
    }
}
