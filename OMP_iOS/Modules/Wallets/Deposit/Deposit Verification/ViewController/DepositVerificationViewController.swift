//
//  DepositVerificationViewController.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 10/4/21.
//

import UIKit

class DepositVerificationViewController: BaseViewController {
    
    private lazy var containerView: UIView = {
        var view = UIView()
        view.backgroundColor = .cardsColor
        view.layer.cornerRadius = 20
        return view
    }()
    
    private lazy var iconImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: viewModel.iconName)
        return imageView
    }()
    
    private lazy var mainStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.configure(text: viewModel.title, fontSize: 16, textColor: .textColor, textAlignment: .center, fontType: .regular)
        return label
    }()
    
    private lazy var messageLabel: UILabel = {
        var label = UILabel()
        label.configure(text: "", fontSize: 14, textColor: .textColor, textAlignment: .center, fontType: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var backToMainScreenButton: UIButton = {
        var button = UIButton()
        button.configure(fontSize: 14, title: "DepositVerificationViewController.backToMainScreen".localized, fontType: .regular, titleColor: .textColor, backgroundColor: .submitButtonColor, borderColor: .clear, cornerRadius: 15)
        button.addTarget(self, action: #selector(backToMainScreenPressed), for: .touchUpInside)
        button.titleEdgeInsets = .init(top: 10, left: 0, bottom: 0, right: 0)
        return button
    }()
    
    //MARK: - INITIALIZER
    private let viewModel: DepositVerificationViewModel
    
    init(viewModel: DepositVerificationViewModel) {
        self.viewModel  = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - VIEW CONTROLLER LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBar(true)
        setBackgroundColor()
        changeStatusBarColor(color: .clear)
        createUI()
        
        //view model
        viewModel.delegate = self
        viewModel.rialDepositVerifyAPI()
    }
    
    //MARK: - CREATE UI
    private func createUI() {
        addingContainerView()
        addingIconImageView()
        addingMainStackView()
        addingBackToMainScreenButton()
    }
    
    private func addingContainerView() {
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2)
        ])
    }
    
    private func addingIconImageView() {
        containerView.addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            iconImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 25),
            iconImageView.widthAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.25),
            iconImageView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.25)
        ])
    }
    
    private func addingMainStackView() {
        containerView.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 10),
            mainStackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            mainStackView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(messageLabel)
    }
    
    private func addingBackToMainScreenButton() {
        view.addSubview(backToMainScreenButton)
        backToMainScreenButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backToMainScreenButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            backToMainScreenButton.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 25),
            backToMainScreenButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: -30),
            backToMainScreenButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    //MARK: - OBJC FUNCTIONS
    @objc func backToMainScreenPressed() {
        let vc = MainTabBarController()
        vc.selectedIndex = 3
        UIApplication.changeRootViewController(vc)
    }
}

//MARK: - MAKE INSTANCE METHOD
extension DepositVerificationViewController {
    static func makeInstance(status: PaymentStatus, token: String) -> DepositVerificationViewController {
        .init(viewModel: DepositVerificationViewModel(status: status, token: token))
    }
}

//MARK: - DEPOSIT VERIFICATION PROTOCOL
extension DepositVerificationViewController: DepositVerificationProtocol {
    func messageReceived(message: String) {
        messageLabel.text = message
    }
}
