//
//  NewWalletAddressView.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 1/27/22.
//

import UIKit
import PanModal
import DropDown

class NewWalletAddressViewController: UIViewController {
    
    var resetFields: Bool = false {
        didSet {
            addressTextField.text = ""
            nameTextField.text = ""
        }
    }
    var addNewWalletAddressWasSuccessful: (() -> Void)?
    var editedWalletAddressWasSuccessful: (() -> Void)?
    
    var panModalShortFormHeight: CGFloat = 390
    
    //MARK: - UI ELEMENTS
    private lazy var dropDown: DropDown = {
        let dropDown = DropDown()
        dropDown.backgroundColor = .cardsColor
        dropDown.textFont = UIFont(type: .regular, fontSize: 14)
        dropDown.textColor = .textColor
        dropDown.selectionBackgroundColor = .backgroundColor
        dropDown.selectedTextColor = .textColor
        dropDown.cornerRadius = 15
        dropDown.cellHeight = 30
        dropDown.cellNib = UINib(nibName: "DropDownCustomTableViewCell", bundle: nil)
        return dropDown
    }()
    
    private lazy var nameTitleLabel: UILabel = {
        let label = UILabel()
        label.configure(text: "NewWalletAddressView.nameTitle".localized, fontSize: 14, textColor: .textColor, textAlignment: .right, fontType: .regular)
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.configure(placeholder: "NewWalletAddressView.namePlaceholder".localized, borderColor: .clear, fontSize: 13, fontType: .regular, keyboardType: .default, textAlignment: .right, radius: 15, backgroundColor: .backgroundColor, textColor: .textColor)
        textField.text = viewModel.getName
        return textField
    }()
    
    private lazy var addressTitleLabel: UILabel = {
        let label = UILabel()
        label.configure(text: "NewWalletAddressView.addressTitle".localized, fontSize: 14, textColor: .textColor, textAlignment: .right, fontType: .regular)
        return label
    }()
    
    private lazy var addressTextField: UITextField = {
        let textField = UITextField()
        textField.configure(placeholder: "", borderColor: .clear, fontSize: 13, fontType: .regular, keyboardType: .default, textAlignment: .left, radius: 15, backgroundColor: .backgroundColor, textColor: .textColor)
        textField.text = viewModel.getAddress
        return textField
    }()
    
    private lazy var currencyTokenTitleLabel: UILabel = {
        let label = UILabel()
        label.configure(text: "NewWalletAddressView.tokenTitle".localized, fontSize: 14, textColor: .textColor, textAlignment: .right, fontType: .regular)
        return label
    }()
    
    private lazy var currencyTokensButton: UIButton = {
       var button = UIButton()
        button.configure(fontSize: 13, title: viewModel.tokensButtonTitle, fontType: .regular, titleColor: .textColor, backgroundColor: .backgroundColor, borderColor: .clear, cornerRadius: 15)
        button.addTarget(self, action: #selector(currencyTokensButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var submitButton: UIButton = {
       var button = UIButton()
        button.configure(fontSize: 13, title: viewModel.title, fontType: .regular, titleColor: .backgroundColor, backgroundColor: .submitButtonColor, borderColor: .clear, cornerRadius: 15)
        button.addTarget(self, action: #selector(submitButtonPressed), for: .touchUpInside)
        button.set(image: UIImage(named: "arrow_down_icon")?.withRenderingMode(.alwaysTemplate), title: viewModel.title, titlePosition: .right, additionalSpacing: 30, state: .normal )
        return button
    }()
    
    //MARK: - INITIALIZER
    private let viewModel: NewWalletAddressViewModel
    
    init(viewModel: NewWalletAddressViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - VIEW CONTROLLER LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cardsColor
        view.layer.cornerRadius = 15
        createUI()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handle(keyboardShowNotification:)),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handle(keyboardHideNotification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
        viewModel.editWalletAddressWas = { [weak self] successful in
            guard let self = self else { return }
            if successful {
                self.editedWalletAddressWasSuccessful?()
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        viewModel.addWalletAddressWas = { [weak self] successful in
            guard let self = self else { return }
            if successful {
                self.addNewWalletAddressWasSuccessful?()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - CREATE UI
    private func createUI() {
        addingNameSection()
        addingAddressSection()
        addingCurrencyTokenTitleLabel()
        addingCurrencyTokensButton()
        addingSubmitButton()
        addingCreditCardsDropDown()
    }
    
    private func addingNameSection() {
        view.addSubview(nameTitleLabel)
        nameTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameTitleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            nameTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
        ])
        
        view.addSubview(nameTextField)
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: nameTitleLabel.bottomAnchor, constant: 8),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            nameTextField.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func addingAddressSection() {
        view.addSubview(addressTitleLabel)
        addressTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addressTitleLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 10),
            addressTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
        ])
        
        view.addSubview(addressTextField)
        addressTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addressTextField.topAnchor.constraint(equalTo: addressTitleLabel.bottomAnchor, constant: 8),
            addressTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            addressTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            addressTextField.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func addingCurrencyTokenTitleLabel() {
        view.addSubview(currencyTokenTitleLabel)
        currencyTokenTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            currencyTokenTitleLabel.topAnchor.constraint(equalTo: addressTextField.bottomAnchor, constant: 10),
            currencyTokenTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
        ])
    }
    
    private func addingCurrencyTokensButton() {
        view.addSubview(currencyTokensButton)
        currencyTokensButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            currencyTokensButton.topAnchor.constraint(equalTo: currencyTokenTitleLabel.bottomAnchor, constant: 10),
            currencyTokensButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currencyTokensButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24),
            currencyTokensButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func addingSubmitButton() {
        view.addSubview(submitButton)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            submitButton.topAnchor.constraint(equalTo: currencyTokensButton.bottomAnchor, constant: 20),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            submitButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func addingCreditCardsDropDown() {
        dropDown.dataSource = viewModel.tokenList
        dropDown.anchorView = currencyTokensButton
        dropDown.reloadAllComponents()
        
        dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? DropDownCustomTableViewCell else { return }
            
            cell.optionLabel.textAlignment = .center
            cell.optionLabel.text = item
            cell.customSeparator()
        }
        
        dropDown.direction = .bottom
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        
        dropDown.selectionAction = { [weak self] (index, item) in
            self?.currencyTokensButton.setTitle(item, for: .normal)
            self?.viewModel.selectedCurrencyToken = item
        }
    }
    
    //MARK: - OBJC FUNCTIONS
    @objc func submitButtonPressed() {
        guard let name = nameTextField.text, let address = addressTextField.text else { return }
        if viewModel.getType == .new {
            guard let token = viewModel.selectedCurrencyToken else { return }
            viewModel.addNewWallet(name: name, address: address, token: token)
        } else {
            guard let walletAddress = viewModel.getWallet else { return }
            let newWalletAddress = WalletAddress(id: walletAddress.id, currencyToken: walletAddress.currencyToken, wallet: address, createdAt: walletAddress.createdAt, name: name)
            viewModel.editWalletAddress(walletAddress: newWalletAddress)
        }
    }
    
    @objc func currencyTokensButtonPressed() {
        dropDown.show()
    }
    
    @objc private func handle(keyboardShowNotification notification: Notification) {
        if let userInfo = notification.userInfo,
           let keyboardRectangle = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            panModalShortFormHeight += keyboardRectangle.height
            panModalSetNeedsLayoutUpdate()
            panModalTransition(to: .shortForm)
        }
    }
    
    @objc private func handle(keyboardHideNotification notification: Notification) {
        panModalShortFormHeight = 390
        panModalSetNeedsLayoutUpdate()
        panModalTransition(to: .shortForm)
    }
}

//MARK: - MAKE INSTANCE METHOD
extension NewWalletAddressViewController {
    static func makeInstance(wallet: WalletAddress?, tokens: [String], singleAddress: String?, type: WalletAddressMode) -> NewWalletAddressViewController {
        .init(viewModel: .init(wallet: wallet, tokens: tokens, singleAddress: singleAddress, type: type))
    }
}

//MARK: - PAN MODAL PROTOCOL
extension NewWalletAddressViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return nil
    }
    
    var shortFormHeight: PanModalHeight {
        return .contentHeight(panModalShortFormHeight)
    }
    
    var showDragIndicator: Bool {
        return false
    }
}
