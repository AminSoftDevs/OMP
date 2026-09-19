//
//  EditPasswordViewController.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 8/23/21.
//

import UIKit
import MHLoadingButton

class ChangePasswordViewController: BaseViewController {
    
    private lazy var containerView: UIView = {
       var view = UIView()
        view.backgroundColor = .cardsColor
        view.layer.cornerRadius = 15
        return view
    }()
    
    private lazy var mainStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 0
        return stackView
    }()
    
    private lazy var changePasswordButton: LoadingButton = {
       var button = LoadingButton()
        button.configure(fontSize: 12, title: viewModel.changePasswordButtonTitle, fontType: .regular, titleColor: .backgroundColor, backgroundColor: .submitButtonColor, borderColor: .clear, cornerRadius: 10)
        button.indicator = BallPulseSyncIndicator(color: .gray)
        button.cornerRadius  = 15
        button.bgColor = .submitButtonColor
        button.indicator.color = .backgroundColor
        button.addTarget(self, action: #selector(changePasswordButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var currentPasswordView: UserInputView = {
        let inputView = UserInputView()
        inputView.delegate = self
        inputView.type = .currentPassword
        return inputView
    }()
    
    private lazy var newPasswordView: UserInputView = {
        let inputView = UserInputView()
        inputView.delegate = self
        inputView.type = .newPassword
        return inputView
    }()
    
    private lazy var repeatNewPasswordView: UserInputView = {
        let inputView = UserInputView()
        inputView.delegate = self
        inputView.type = .repeatNewPassword
        return inputView
    }()
    
    //MARK: - INITIALIZER
    private let viewModel: ChangePasswordControllerViewModel
    
    init(viewModel: ChangePasswordControllerViewModel) {
        self.viewModel = viewModel
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
        createUI()
        
        viewModel.hideSubmitButtonLoader = { [weak self] in
            self?.changePasswordButton.hideLoader()
        }
    }
    
    //MARK: - CREATE UI
    private func createUI() {
        addingDefaultNavBar()
        addingContainerView()
        addingMainStackView()
        addingChangePasswordButton()
    }
    
    private func addingDefaultNavBar() {
        addingDefaultNavigationBarView(title: viewModel.navigationTitle, hasBackButton: true, shouldHaveRadius: true)
        defaultNavigationBarView.delegate = self
    }
        
    private func addingContainerView() {
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: defaultNavigationBarView.bottomAnchor, constant: 15),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 440)
        ])
    }
    
    private func addingMainStackView() {
        containerView.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            mainStackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            mainStackView.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: -40),
            mainStackView.heightAnchor.constraint(equalToConstant: 330)
        ])
        
        mainStackView.addArrangedSubview(currentPasswordView)
        mainStackView.addArrangedSubview(newPasswordView)
        mainStackView.addArrangedSubview(repeatNewPasswordView)
        
    }
    
    private func addingChangePasswordButton() {
        containerView.addSubview(changePasswordButton)
        changePasswordButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            changePasswordButton.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 15),
            changePasswordButton.centerXAnchor.constraint(equalTo: mainStackView.centerXAnchor),
            changePasswordButton.widthAnchor.constraint(equalTo: mainStackView.widthAnchor),
            changePasswordButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    //MARK: - OBJC FUNCTIONS
    @objc func changePasswordButtonPressed() {
        view.endEditing(true)
        changePasswordButton.showLoader(userInteraction: false)
        viewModel.checkToChangePassword()
    }
}

//MARK: - NAVIGATION BAR DELEGATE
extension ChangePasswordViewController: DefaultNavigationBarViewProtocol {
    func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
}

extension ChangePasswordViewController: UserInputViewDelegate {
    func userInput(input: String, type: UserInputType) {
        viewModel.handleUserInputs(input: input, type: type)
    }
}

//MARK: - MAKE INSTANCE
extension ChangePasswordViewController {
    static func makeInstance() -> ChangePasswordViewController {
        .init(viewModel: ChangePasswordControllerViewModel())
    }
}
