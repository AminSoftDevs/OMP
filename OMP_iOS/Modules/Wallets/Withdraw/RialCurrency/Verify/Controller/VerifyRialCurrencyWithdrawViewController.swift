//
//  VerifyRialCurrencyWithdrawViewController.swift
//  OMP_iOS
//
//  Created by AminSoft on 7/13/1400 AP.
//

import UIKit

class VerifyRialCurrencyWithdrawViewController: BaseViewController {
    
    //    MARK: - PROPERTIES
    var googleAuth: Bool = false
    
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
        label.configure(text: "", fontSize: 14, textColor: .textColor, textAlignment: .center, fontType: .regular) // "Withdraw.acceptText".localized
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
        //        textField.addTarget(self, action: #selector(acceptTextFieldTapped), for: .editingChanged)
        textField.delegate = self
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
    
    //    MARK: - INITILIZER
    private let viewModel: VerifyRialCurrencyWithdrawViewModel
    
    init(viewModel: VerifyRialCurrencyWithdrawViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor()
        hideNavigationBar(true)
        defaultNavigationBarView.delegate = self
        createUI()
        
        // update UI
        acceptLabel.text = viewModel.titleMessage
    }
    
    //   MARK: - CREATE UI
    private func createUI() {
        addingDefaultNavigationBarView(title: "Withdraw.rialWithdraw".localized, hasBackButton: true, leftSideButtonName: "history_icon", shouldHaveRadius: true)
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
        if googleAuth == false {
            textFieldStack.addArrangedSubview(acceptTextField)
            textFieldStack.heightAnchor.constraint(equalToConstant: 48).isActive = true
        } else {
            textFieldStack.addArrangedSubview(acceptTextField)
            textFieldStack.addArrangedSubview(googleCodeTextField)
            textFieldStack.heightAnchor.constraint(equalToConstant: 116).isActive = true
        }
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
    
    //     MARK: - OBJC FUNC
    @objc private func confirmButtonTapped() {
        viewModel.verifyRialWithdraw { [weak self] status in
            guard let self = self else { return }
            
            if status {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}

// MARK: - make instance
extension VerifyRialCurrencyWithdrawViewController {
    static func makeInstance(withdrawItem:  RialWithdrawService.Response) -> VerifyRialCurrencyWithdrawViewController {
        .init(viewModel: VerifyRialCurrencyWithdrawViewModel(withdraw: withdrawItem))
    }
}

// MARK: - TextField Delegate
extension VerifyRialCurrencyWithdrawViewController: UITextFieldDelegate {
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
        if let text = textField.text {
            let newText = text.convertEngNumToPersianNum()
            textField.text = newText
            self.viewModel.verifyCode = text.persianToEng()
        }
    }
}

//MARK: - DefaultNavigationBarViewProtocol
extension VerifyRialCurrencyWithdrawViewController: DefaultNavigationBarViewProtocol {
    func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func leftSideButtonPressed() {
        //TODO: - Should Go Transactions History
    }
}

