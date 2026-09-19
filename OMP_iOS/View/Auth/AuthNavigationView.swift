//
//  AuthNavigationView.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 7/31/21.
//

import UIKit

protocol AuthNavigationDelegate: AnyObject {
    func backButtonPressed()
}

class AuthNavigationView: UIView {
    
    var navigationTitle: String {
        get {
           return _titleLabelString
        }
        set {
            self._titleLabelString = newValue
        }
    }
    
    fileprivate var _titleLabelString: String = "" {
        didSet {
            self.titleLabel.text = _titleLabelString
        }
    }
    
    private lazy var titleLabel: UILabel = {
       var label = UILabel()
        label.configure(text: "", fontSize: 17, textColor: .textColor, textAlignment: .center, fontType: .regular)
        return label
    }()
    
    private lazy var backButton: UIButton = {
       var button = UIButton()
        button.setImage(UIImage(named: "back_arrow_icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .textColor
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.mediumGrayColor.cgColor
        button.imageView?.transform = dir == .leftToRight ? CGAffineTransform(scaleX: -1, y: 1) : CGAffineTransform(scaleX: 1, y: 1)
        return button
    }()
    
    let dir = Localization.sharedInstance.getlanguageDirection()
    
    //MARK: - DEFAULT INIT
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .cardsColor
        self.createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var delegate: AuthNavigationDelegate?
    
    //MARK: - CREATE UI
    fileprivate func createUI() {
        self.addingBackButton()
        self.addingTitleLabel()
    }
    
    fileprivate func addingBackButton() {
        self.addSubview(backButton)
        self.backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: backButton, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: backButton, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: backButton, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0, constant: 35).isActive = true
        NSLayoutConstraint(item: backButton, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 35).isActive = true
    }
    
    fileprivate func addingTitleLabel() {
        self.addSubview(titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: self.backButton, attribute: .centerY, multiplier: 1, constant: 4).isActive = true
    }
    
    //MARK: - OBJC FUNCTIONS
    @objc func backButtonPressed() {
        self.delegate?.backButtonPressed()
    }
}
