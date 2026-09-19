//
//  VerifyDigitalCurrencyWithdrawViewController.swift
//  OMP_iOS
//
//  Created by AminSoft on 7/20/1400 AP.
//

import UIKit

class VerifyDigitalCurrencyWithdrawViewController: BaseViewController {
    // MARK: - PROPERTIES
    private lazy var mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .cardsColor
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 20
        return view
    }()
    
    private lazy var acceptLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configure(text: "", fontSize: 14, textColor: .textColor, textAlignment: .center, fontType: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var acceptTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.configure(placeholder: "Withdraw.acceptCode".localized, borderColor: .clear, fontSize: 14, fontType: .regular, keyboardType: .default, textAlignment: .center, radius: 12, backgroundColor: .backgroundColor, textColor: .textColor)
        textField.delegate = self
        return textField
    }()
    
    private lazy var googleCodeTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.configure(placeholder: "Withdraw.googleCode".localized, borderColor: .clear, fontSize: 14, fontType: .regular, keyboardType: .default, textAlignment: .center, radius: 12, backgroundColor: .backgroundColor, textColor: .textColor)
        textField.delegate = self
        textField.isHidden = true
        return textField
    }()
    
    private lazy var textFieldStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configure(fontSize: 14, title: "confirm".localized, fontType: .regular, titleColor: .backgroundColor, backgroundColor: .submitButtonColor, borderColor: .clear, cornerRadius: 12)
        button.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let viewModel: VerifyDigitalCurrencyWithdrawViewModel
    
    // MARK: - INITILIZER
    init(viewModel: VerifyDigitalCurrencyWithdrawViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - VIEWCONTROLLER LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor()
        hideNavigationBar(true)
        defaultNavigationBarView.delegate = self
        createUI()
        
        viewModel.delegate = self
        
        // update UI
        acceptLabel.text = viewModel.titleMessage
    }
    
    // MARK: - OBJC FUNC
    @objc private func confirmButtonTapped() {
        viewModel.verifyDigitalWithdraw { [weak self] state in
            guard let self = self else { return }
            if state {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    // MARK: - CREATE UI
    private func createUI() {
        addingDefaultNavigationBarView(title: "withdraw".localized + " \(viewModel.withdrawCurrencyName)", hasBackButton: true, leftSideButtonName: "history_icon", shouldHaveRadius: true)
        addingMainView()
        addingAcceptLabel()
        addingTextFieldStack()
        addingAcceptButton()
    }
    private func addingMainView() {
        view.addSubview(mainView)
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: defaultNavigationBarView.bottomAnchor, constant: 10),
            mainView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainView.widthAnchor.constraint(equalTo: view.widthAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    private func addingAcceptLabel() {
        view.addSubview(acceptLabel)
        NSLayoutConstraint.activate([
            acceptLabel.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            acceptLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            acceptLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9)
        ])
    }
    
    private func addingTextFieldStack() {
        view.addSubview(textFieldStack)
        NSLayoutConstraint.activate([
            textFieldStack.topAnchor.constraint(equalTo: acceptLabel.bottomAnchor, constant: 20),
            textFieldStack.centerXAnchor.constraint(equalTo: acceptLabel.centerXAnchor),
            textFieldStack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.45),
        ])
        
        acceptTextField.heightAnchor.constraint(equalToConstant: 48).isActive = true
        googleCodeTextField.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        textFieldStack.addArrangedSubview(acceptTextField)
        textFieldStack.addArrangedSubview(googleCodeTextField)
    }
      
    private func addingAcceptButton() {
        view.addSubview(confirmButton)
        NSLayoutConstraint.activate([
            confirmButton.topAnchor.constraint(equalTo: textFieldStack.bottomAnchor, constant: 20),
            confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.45),
            confirmButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
}
// MARK: - TEXTFIELD DELEGATE
extension VerifyDigitalCurrencyWithdrawViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == acceptTextField {
            acceptTextField.layer.borderColor = UIColor.submitButtonColor.cgColor
            acceptTextField.layer.borderWidth = 2.5
        } else {
            googleCodeTextField.layer.borderColor = UIColor.submitButtonColor.cgColor
            googleCodeTextField.layer.borderWidth = 2.5
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        acceptTextField.layer.borderColor = UIColor.clear.cgColor
        googleCodeTextField.layer.borderColor = UIColor.clear.cgColor
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text, !text.isEmpty else { return }
        
        if textField == acceptTextField {
            let newText = text.convertEngNumToPersianNum()
            textField.text = newText
            self.viewModel.verifyCode = text.persianToEng()
            print("verify code >>> \(text.persianToEng())")
            
        } else if textField == googleCodeTextField {
            let newText = text.convertEngNumToPersianNum()
            textField.text = newText
            self.viewModel.googleAuthCode = text.persianToEng().toInt
            print("google auth >>> \(text.persianToEng().toInt)")
        }
    }
}

// MARK: - make instance
extension VerifyDigitalCurrencyWithdrawViewController {
    static func makeInstance(withdrawItem: DigitalWithdrawService.Response, wallet: Wallet) -> VerifyDigitalCurrencyWithdrawViewController {
        .init(viewModel: VerifyDigitalCurrencyWithdrawViewModel(withdraw: withdrawItem, wallet: wallet))
    }
}

//MARK: - DefaultNavigationBarViewProtocol
extension VerifyDigitalCurrencyWithdrawViewController: DefaultNavigationBarViewProtocol {
    func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func leftSideButtonPressed() {
        //TODO: - Should Go Transactions History
    }
}

// MARK: View model protocol
extension VerifyDigitalCurrencyWithdrawViewController: VerifyDigitalCurrencyWithdrawViewModelProtocol {
    func shouldShowGoogleAuthField() {
        UIView.animate(withDuration: 0.3) {
            self.googleCodeTextField.isHidden = false
        }
    }
}
