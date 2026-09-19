//
//  WithdrawRialViewController.swift
//  OMP_iOS
//
//  Created by AminSoft on 7/10/1400 AP.
//

import UIKit
import DropDown

class WithdrawRialViewController: BaseViewController {
    
    // MARK: - PROPERTIES
    private lazy var mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .cardsColor
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 20
        return view
    }()
    
    private lazy var balanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configure(text: "Withdraw.balance".localized, fontSize: 16, textColor: .textColor, textAlignment: .center, fontType: .regular)
        return label
    }()
    
    private lazy var valueBalanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configure(text: "", fontSize: 14, textColor: .textFieldPlaceholderColor, textAlignment: .center, fontType: .regular)
        return label
    }()
    
    private lazy var destinatioAccountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configure(text: "Withdraw.destinationAccount".localized, fontSize: 14, textColor: .textColor, textAlignment: .right, fontType: .regular)
        return label
    }()
    
    private lazy var destinationAccountButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configure(fontSize: 12, title: "", fontType: .regular, titleColor: .textColor, backgroundColor: .backgroundColor, borderColor: .clear, cornerRadius: 12)
        button.addTarget(self, action: #selector(destinationButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var arrowInButton: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "arrow_down_icon")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .textColor
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var warningImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "warning")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var withdrawLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configure(text: "Withdraw.valueWirhdraw".localized, fontSize: 14, textColor: .textColor, textAlignment: .right, fontType: .regular)
        return label
    }()
    
    private lazy var withdrawTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.configure(placeholder: "", borderColor: .clear, fontSize: 14, fontType: .regular, keyboardType: .numberPad, textAlignment: .right, radius: 12, backgroundColor: .backgroundColor, textColor: .textColor)
        textField.delegate = self
        return textField
    }()
    
    private lazy var wageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configure(text: "Withdraw.wage".localized + " :  ", fontSize: 14, textColor: .textFieldPlaceholderColor, textAlignment: .right, fontType: .regular)
        return label
    }()
    
    private lazy var amountReceivedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configure(text: "Withdraw.amountReceived".localized + " :  ", fontSize: 14, textColor: .textFieldPlaceholderColor, textAlignment: .right, fontType: .regular)
        return label
    }()
    
    private lazy var labelStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var withdrawButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configure(fontSize: 14, title: "Withdraw.accept".localized, fontType: .regular, titleColor: .backgroundColor, backgroundColor: .submitButtonColor, borderColor: .clear, cornerRadius: 14)
        button.addTarget(self, action: #selector(withdrawButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var warningLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configure(text: "Withdraw.warning".localized, fontSize: 12, textColor: .rejectOrangeColor, textAlignment: .center, fontType: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var ibanDropDown: DropDown = {
        let dropDown = DropDown()
        dropDown.backgroundColor = .backgroundColor
        dropDown.textFont = UIFont(type: .regular, fontSize: 14)
        dropDown.textColor = .textColor
        dropDown.selectionBackgroundColor = .backgroundColor
        dropDown.selectedTextColor = .textColor
        dropDown.cornerRadius = 15
        dropDown.cellHeight = 60
        dropDown.cellNib = UINib(nibName: "DropDownCustomTableViewCell", bundle: nil)
        return dropDown
    }()
    
    private let viewModel: WithdrawRialViewModel
    //    MARK: - INITILIZER
    init(viewModel: WithdrawRialViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //   MARK: - VIEWCONTROLLER LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor()
        hideNavigationBar(true)
        defaultNavigationBarView.delegate = self
        createUI()
        // update UI
        valueBalanceLabel.text = viewModel.totalBalance
        
        viewModel.delegate = self
        // Fetch data
        viewModel.getIbansList()
    }
    
    //    MARK: - CREATE UI
    private func createUI() {
        addingDefaultNavigationBarView(title: "Withdraw.rialWithdraw".localized, hasBackButton: true, leftSideButtonName: "history_icon", shouldHaveRadius: true)
        addingMainView()
        addingBalanceLabel()
        addingValueBalanceLabel()
        addingDestinatioAccountLabel()
        addingDestinationAccountButton()
        addingArrowInButton()
        addingWithdrawLabel()
        addingWithdrawTextField()
        addingStackLabel()
        addingWithdrawButton()
        addingWarningImageView()
        addingWarningLabel()
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
    private func addingBalanceLabel() {
        view.addSubview(balanceLabel)
        NSLayoutConstraint.activate([
            balanceLabel.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 25),
            balanceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    private func addingValueBalanceLabel() {
        view.addSubview(valueBalanceLabel)
        NSLayoutConstraint.activate([
            valueBalanceLabel.topAnchor.constraint(equalTo: balanceLabel.bottomAnchor, constant: 12),
            valueBalanceLabel.centerXAnchor.constraint(equalTo: balanceLabel.centerXAnchor),
        ])
    }
    private func addingDestinatioAccountLabel() {
        view.addSubview(destinatioAccountLabel)
        NSLayoutConstraint.activate([
            destinatioAccountLabel.topAnchor.constraint(equalTo: valueBalanceLabel.bottomAnchor, constant: 10),
            destinatioAccountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    private func addingDestinationAccountButton() {
        view.addSubview(destinationAccountButton)
        NSLayoutConstraint.activate([
            destinationAccountButton.topAnchor.constraint(equalTo: destinatioAccountLabel.bottomAnchor, constant: 2),
            destinationAccountButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            destinationAccountButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            destinationAccountButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    private func addingArrowInButton() {
        destinationAccountButton.addSubview(arrowInButton)
        NSLayoutConstraint.activate([
            arrowInButton.leadingAnchor.constraint(equalTo: destinationAccountButton.leadingAnchor, constant: 15),
            arrowInButton.centerYAnchor.constraint(equalTo: destinationAccountButton.centerYAnchor),
            arrowInButton.heightAnchor.constraint(equalTo: destinationAccountButton.heightAnchor, multiplier: 0.3),
            arrowInButton.widthAnchor.constraint(equalToConstant: 12)
        ])
    }
    private func addingWithdrawLabel() {
        view.addSubview(withdrawLabel)
        NSLayoutConstraint.activate([
            withdrawLabel.topAnchor.constraint(equalTo: destinationAccountButton.bottomAnchor, constant: 25),
            withdrawLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    private func addingWithdrawTextField() {
        view.addSubview(withdrawTextField)
        NSLayoutConstraint.activate([
            withdrawTextField.topAnchor.constraint(equalTo: withdrawLabel.bottomAnchor, constant: 2),
            withdrawTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            withdrawTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            withdrawTextField.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    private func addingStackLabel() {
        labelStack.addArrangedSubview(wageLabel)
        labelStack.addArrangedSubview(amountReceivedLabel)
        view.addSubview(labelStack)
        NSLayoutConstraint.activate([
            labelStack.topAnchor.constraint(equalTo: withdrawTextField.bottomAnchor, constant: 16),
            labelStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    private func addingWithdrawButton() {
        view.addSubview(withdrawButton)
        NSLayoutConstraint.activate([
            withdrawButton.topAnchor.constraint(equalTo: labelStack.bottomAnchor, constant: 25),
            withdrawButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            withdrawButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            withdrawButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    private func addingWarningImageView() {
        view.addSubview(warningImageView)
        NSLayoutConstraint.activate([
            warningImageView.topAnchor.constraint(equalTo: withdrawButton.bottomAnchor, constant: 20),
            warningImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            warningImageView.heightAnchor.constraint(equalToConstant: 16),
            warningImageView.widthAnchor.constraint(equalTo: warningImageView.heightAnchor)
        ])
    }
    private func addingWarningLabel() {
        view.addSubview(warningLabel)
        NSLayoutConstraint.activate([
            warningLabel.firstBaselineAnchor.constraint(equalTo: warningImageView.bottomAnchor, constant: 0),
            warningLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            warningLabel.trailingAnchor.constraint(equalTo: warningImageView.leadingAnchor, constant: -4)
        ])
    }
    //    MARK: - OBJC FUNC & Import DropDown DataSource
    @objc private func destinationButtonTapped() {
        self.destinationAccountButton.layer.borderColor = UIColor.submitButtonColor.cgColor
        self.destinationAccountButton.layer.borderWidth = 2.5
        self.arrowInButton.tintColor = .submitButtonColor
        ibanDropDown.bottomOffset = CGPoint(x: 0, y:(destinationAccountButton.frame.size.height))
        ibanDropDown.direction = .bottom
        ibanDropDown.show()
        ibanDropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self = self else { return }
            self.destinationAccountButton.setTitle(item, for: .normal)
            self.destinationAccountButton.layer.borderColor = UIColor.clear.cgColor
            self.arrowInButton.tintColor = .textColor
            self.viewModel.dropDownItemDidSelect(at: index)
        }
        ibanDropDown.cancelAction = { [unowned self] in
            self.destinationAccountButton.layer.borderColor = UIColor.clear.cgColor
            self.arrowInButton.tintColor = .textColor
        }
    }
    
    @objc private func withdrawButtonTapped() {
        viewModel.performWithdrawRequest() { [weak self] status in
            guard let self = self else { return }
            if let withdraw = self.viewModel.withdrawItem, status {
                let vc = VerifyRialCurrencyWithdrawViewController.makeInstance(withdrawItem: withdraw)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
//MARK: -  MakeInstance
extension WithdrawRialViewController {
    static func makeInstance(wallet: Wallet) -> WithdrawRialViewController {
        .init(viewModel: WithdrawRialViewModel(wallet: wallet))
    }
}
//MARK: - TextFieldDelegate
extension WithdrawRialViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        withdrawTextField.layer.borderColor = UIColor.submitButtonColor.cgColor
        withdrawTextField.layer.borderWidth = 2.5
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        withdrawTextField.layer.borderColor = UIColor.clear.cgColor
        withdrawTextField.layer.borderWidth = 0
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        textField.isUserInteractionEnabled = false
        if let text = textField.text {
            let newText = text.persianToEng().removeComma
            let formattedText = newText.toDouble.formattedWithSeparator.convertEngNumToPersianNum()
            textField.text = formattedText
            viewModel.withdrawalAmount = newText.toInt
            viewModel.rialWithdrawFeeCalculatorAPI()
        }
    }
}

//MARK: - SendingIbanListProtocol
extension WithdrawRialViewController: SendingIbanListProtocol {
    func calculationFinished() {
        withdrawTextField.isUserInteractionEnabled = true
        wageLabel.text = "Withdraw.wage".localized + " : \(viewModel.withdrawFee) ".addCurrency()
        amountReceivedLabel.text = "Withdraw.amountReceived".localized + " : \(viewModel.totalWithdrawAmount) ".addCurrency()
    }
    
    func updateIbanList(ibanList: [String]) {
        ibanDropDown.dataSource = ibanList
        ibanDropDown.anchorView = destinationAccountButton
        ibanDropDown.customCellConfiguration = { [weak self] (index, title, cell: DropDownCell) in
            
            guard let cell = cell as? DropDownCustomTableViewCell else { return }
            
            guard let self = self else { return }
            cell.optionLabel.textAlignment = .center
            cell.optionLabel.text = ibanList[index]
            self.destinationAccountButton.setTitle(ibanList[index], for: .normal)
            cell.customSeparator()
        }
    }
}

//MARK: - DefaultNavigationBarViewProtocol
extension WithdrawRialViewController: DefaultNavigationBarViewProtocol {
    func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func leftSideButtonPressed() {
        let vc = HistoryWithdrawDigitalCurrencyViewController.makeInstance(wallet: viewModel.wallet)
        navigationController?.pushViewController(vc, animated: true)
    }
}
