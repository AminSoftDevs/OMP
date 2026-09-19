//
//  AccountNavigationBar.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 8/4/21.
//

import UIKit

protocol AccountNavigationBarDelegate: AnyObject {
    func notificationButtonPressed()
    func loginButtonPressed()
}

class AccountNavigationBarView: UIView {
    
    var userLoggedIn: Bool
    
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
    
    var userEmail: String {
        get {
           return _userEmail
        }
        set {
            self._userEmail = newValue
        }
    }
    
    fileprivate var _userEmail: String = "" {
        didSet {
            self.emailLabel.text = _userEmail
        }
    }
    
    var notificationCount: Int {
        get {
           return _notificationCount
        }
        set {
            self._notificationCount = newValue
        }
    }
    
    fileprivate var _notificationCount: Int = 0 {
        didSet {
            if _notificationCount  == 0 {
                self.badgeLabel.isHidden = true
            } else {
                self.badgeLabel.isHidden = false
            }
            self.badgeLabel.text = String(_notificationCount)
        }
    }
    
    private lazy var titleLabel: UILabel = {
       var label = UILabel()
        label.configure(text: "", fontSize: 18, textColor: .textColor, textAlignment: .center, fontType: .regular)
        return label
    }()
    
    private lazy var containerView: UIView = {
       var view  = UIView()
        view.backgroundColor = .backgroundColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var emailLabel: UILabel = {
       var label = UILabel()
        label.configure(text: "", fontSize: 13, textColor: .textColor, textAlignment: .left, fontType: .bold)
        return label
    }()
    
    private lazy var notificationsButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(named: "alarm_icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .textColor
        button.addTarget(self, action: #selector(notificationButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var badgeLabel: UILabel = {
        var label = UILabel()
        label.configure(text: "", fontSize: 12, textColor: .backgroundColor, textAlignment: .center, fontType: .regular)
        label.backgroundColor = .submitGreenColor
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.backgroundColor.cgColor
        return label
    }()
    
    private lazy var loginButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(named: "account_icon_selected")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .submitGreenColor
        button.titleEdgeInsets = .init(top: 0, left: -20, bottom: 0, right: 20)
        button.imageEdgeInsets = .init(top: 5, left: 5, bottom: 5, right: 5)
        button.semanticContentAttribute = .forceRightToLeft
        button.configure(fontSize: 14, title: "AccountNavigationBarView.loginOrSignup".localized, fontType: .regular, titleColor: .submitGreenColor, backgroundColor: .clear, borderColor: .clear, cornerRadius: 0)
        button.contentHorizontalAlignment = .right
        button.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        return button
    }()
    
    //MARK: - DEFAULT INIT
    init(userLoggedIn: Bool) {
        self.userLoggedIn = userLoggedIn
        super.init(frame: .zero)
        self.backgroundColor = .cardsColor
        self.layer.cornerRadius = 10
        self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        self.createUI()
        self.updateUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    weak var delegate: AccountNavigationBarDelegate?
    
    //MARK: - CREATE UI
    private func createUI() {
        addingTitleLabel()
        addingContainerView()
        
        if userLoggedIn {
            addingNotificationButton()
            addingEmailLabel()
            //self.addingBadgeLabel()
        } else {
            addingLoginButton()
        }
    }
    
    private func addingTitleLabel() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    private func addingContainerView() {
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints  = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            containerView.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    private func addingNotificationButton() {
        containerView.addSubview(notificationsButton)
        notificationsButton.translatesAutoresizingMaskIntoConstraints  = false
        NSLayoutConstraint.activate([
            notificationsButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            notificationsButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            notificationsButton.widthAnchor.constraint(equalToConstant: 30),
            notificationsButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func addingEmailLabel() {
        containerView.addSubview(emailLabel)
        emailLabel.translatesAutoresizingMaskIntoConstraints  = false
        NSLayoutConstraint.activate([
            emailLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            emailLabel.leadingAnchor.constraint(equalTo: notificationsButton.trailingAnchor, constant: 30),
            emailLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
        ])
    }
    
    private func addingBadgeLabel() {
        containerView.addSubview(badgeLabel)
        badgeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            badgeLabel.centerYAnchor.constraint(equalTo: notificationsButton.centerYAnchor, constant: -10),
            badgeLabel.leadingAnchor.constraint(equalTo: notificationsButton.trailingAnchor, constant: -12),
            badgeLabel.heightAnchor.constraint(equalToConstant: 20),
            badgeLabel.widthAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func addingLoginButton() {
        containerView.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loginButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            loginButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            loginButton.heightAnchor.constraint(equalTo: containerView.heightAnchor),
            loginButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
        ])
    }
    
    //MARK: - OBJC FUNCTIONS
    @objc func notificationButtonPressed() {
        delegate?.notificationButtonPressed()
    }
    
    @objc func loginButtonPressed() {
        delegate?.loginButtonPressed()
    }
    
    //MARK: - UPDATE UI
    private func updateUI() {
        if userLoggedIn {
            containerView.backgroundColor = .backgroundColor
            containerView.layer.borderWidth = 0
        } else  {
            containerView.backgroundColor = .submitGreenColor.withAlphaComponent(0.1)
            containerView.layer.borderWidth = 1
            containerView.layer.borderColor = UIColor.submitGreenColor.cgColor
        }
    }
}
