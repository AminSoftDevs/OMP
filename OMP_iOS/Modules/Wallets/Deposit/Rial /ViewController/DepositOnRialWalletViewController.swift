//
//  DepositOnRialWalletViewController.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 10/2/21.
//

import UIKit
import DropDown

class DepositOnRialWalletViewController: BaseViewController {
    
    private lazy var dropDown: DropDown = {
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
    
    private lazy var mainScrollView: UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    private lazy var containerView: UIView = {
        var view = UIView()
        view.backgroundColor = .cardsColor
        view.layer.cornerRadius = 25
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    private lazy var alertIconImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.image  = UIImage(named: "alert_icon")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var cautionDescriptionLabel: UILabel = {
       var label = UILabel()
        label.configure(text: "DepositOnRialWalletViewController.cautionDescription".localized, fontSize: 14, textColor: .rejectOrangeColor, textAlignment: .right, fontType: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var creditCardTitleLabel: UILabel = {
       var label = UILabel()
        label.configure(text: "DepositOnRialWalletViewController.chooseCreditCard".localized, fontSize: 14, textColor: .textColor, textAlignment: .right, fontType: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var creditCardNumberLabel: PaddingLabel = {
       var label = PaddingLabel()
        label.configure(text: "", fontSize: 14, textColor: .textColor, textAlignment: .center, fontType: .regular)
        label.backgroundColor = .backgroundColor
        label.layer.cornerRadius = 15
        label.numberOfLines = 0
        label.clipsToBounds = true
        label.topInset = 10
        return label
    }()
    
    private lazy var showCreditCardsListButton: UIButton = {
       var button = UIButton()
        button.setImage(UIImage(named: "arrow_down_icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .textColor
        button.contentHorizontalAlignment = .leading
        button.imageEdgeInsets = .init(top: 0, left: 30, bottom: 0, right: -30)
        button.addTarget(self, action: #selector(showCreditCardsListButtonPressed), for: .touchUpInside)
        //button.titleEdgeInsets = .init(top: 10, left: 0, bottom: 0, right: 0)
        button.isEnabled = false
        return button
    }()
    
    private lazy var amountTitleLabel: UILabel = {
       var label = UILabel()
        label.configure(text: "DepositOnRialWalletViewController.valueInRial".localized, fontSize: 14, textColor: .textColor, textAlignment: .right, fontType: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var amountTextField: UITextField = {
       var textField = UITextField()
        textField.configure(placeholder: "", borderColor: .clear, fontSize: 14, fontType: .regular, keyboardType: .numberPad, textAlignment: .center, radius: 15, backgroundColor: .backgroundColor, textColor: .textColor)
        textField.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
        textField.delegate = self
        return textField
    }()
    
    private lazy var paymentButton: UIButton = {
       var button = UIButton()
        button.configure(fontSize: 14, title: "transferToBank".localized, fontType: .regular, titleColor: .backgroundColor, backgroundColor: .submitButtonColor, borderColor: .clear, cornerRadius: 15)
        button.addTarget(self, action: #selector(paymentButtonPressed), for: .touchUpInside)
        //button.titleEdgeInsets = .init(top: 10, left: 0, bottom: 0, right: 0)
        return button
    }()
    
    private lazy var advicesTextView: UITextView = {
        var textView = UITextView()
        textView.text = "DepositOnRialWalletViewController.advicesTextView".localized
        textView.isEditable  = false
        textView.font = UIFont(type: .regular, fontSize: 13)
        textView.textColor = .textColor
        textView.textAlignment = .right
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        return textView
    }()
    
    //MARK: - INITIALIZER
    private let viewModel: DepositOnRialWalletViewModel
    
    init(viewModel: DepositOnRialWalletViewModel) {
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
        
        //delegate
        defaultNavigationBarView.delegate = self
        viewModel.delegate = self
        //calling api
        viewModel.getCreditCardsListAPI()
        
        dropDownActionsHandler()
    }
    
    //MARK: - CREATE UI
    private func createUI() {
        addingDefaultNavigationBarView(title: viewModel.screenTitle, hasBackButton: true, leftSideButtonName: "history_icon", shouldHaveRadius: true)
        addingContainerView()
        addingMainScrollView()
        addingAlertIconImageView()
        addingCautionDescriptionLabel()
        addingCreditCardTitleLabel()
        addingCreditCardNumberLabel()
        addingShowCreditCardsListButton()
        addingAmountTitleLabel()
        addingAmountTextField()
        addingPaymentButton()
        addingWalletAddressTextView()
        
        let sizeThatFitsTextView = advicesTextView.sizeThatFits(CGSize(width: Constants.screenWidth - 30, height: CGFloat(MAXFLOAT)))
        mainScrollView.contentSize.height = sizeThatFitsTextView.height + 430
    }
    
    private func addingContainerView() {
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: defaultNavigationBarView.bottomAnchor, constant: 15),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func addingMainScrollView() {
        containerView.addSubview(mainScrollView)
        mainScrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainScrollView.topAnchor.constraint(equalTo: containerView.topAnchor),
            mainScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func addingAlertIconImageView() {
        mainScrollView.addSubview(alertIconImageView)
        alertIconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            alertIconImageView.topAnchor.constraint(equalTo: mainScrollView.topAnchor, constant: 25),
            alertIconImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            alertIconImageView.heightAnchor.constraint(equalToConstant: 20),
            alertIconImageView.widthAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    private func addingCautionDescriptionLabel() {
        mainScrollView.addSubview(cautionDescriptionLabel)
        cautionDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cautionDescriptionLabel.topAnchor.constraint(equalTo: mainScrollView.topAnchor, constant: 27),
            cautionDescriptionLabel.trailingAnchor.constraint(equalTo: alertIconImageView.leadingAnchor, constant: -10),
            cautionDescriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
        ])
    }
    
    private func addingCreditCardTitleLabel() {
        mainScrollView.addSubview(creditCardTitleLabel)
        creditCardTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            creditCardTitleLabel.topAnchor.constraint(equalTo: cautionDescriptionLabel.bottomAnchor, constant: 15),
            creditCardTitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
        ])
    }
    
    private func addingCreditCardNumberLabel() {
        mainScrollView.addSubview(creditCardNumberLabel)
        creditCardNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            creditCardNumberLabel.topAnchor.constraint(equalTo: creditCardTitleLabel.bottomAnchor, constant: 10),
            creditCardNumberLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            creditCardNumberLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            creditCardNumberLabel.heightAnchor.constraint(equalToConstant: 48),
        ])
    }
    
    private func addingShowCreditCardsListButton() {
        mainScrollView.addSubview(showCreditCardsListButton)
        showCreditCardsListButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            showCreditCardsListButton.trailingAnchor.constraint(equalTo: creditCardNumberLabel.trailingAnchor),
            showCreditCardsListButton.leadingAnchor.constraint(equalTo: creditCardNumberLabel.leadingAnchor),
            showCreditCardsListButton.centerYAnchor.constraint(equalTo: creditCardNumberLabel.centerYAnchor),
            showCreditCardsListButton.heightAnchor.constraint(equalTo: creditCardNumberLabel.heightAnchor),
        ])
    }
    
    private func addingAmountTitleLabel() {
        mainScrollView.addSubview(amountTitleLabel)
        amountTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            amountTitleLabel.topAnchor.constraint(equalTo: creditCardNumberLabel.bottomAnchor, constant: 20),
            amountTitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
        ])
    }
    
    private func addingAmountTextField() {
        mainScrollView.addSubview(amountTextField)
        amountTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            amountTextField.topAnchor.constraint(equalTo: amountTitleLabel.bottomAnchor, constant: 10),
            amountTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            amountTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            amountTextField.heightAnchor.constraint(equalToConstant: 48),
        ])
    }
    
    private func addingPaymentButton() {
        mainScrollView.addSubview(paymentButton)
        paymentButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            paymentButton.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 30),
            paymentButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            paymentButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            paymentButton.heightAnchor.constraint(equalToConstant: 48),
        ])
    }
    
    private func addingWalletAddressTextView() {
        mainScrollView.addSubview(advicesTextView)
        advicesTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            advicesTextView.topAnchor.constraint(equalTo: paymentButton.bottomAnchor, constant: 15),
            advicesTextView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            advicesTextView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
        ])
    }
    
    private func addingCreditCardsDropDown() {
        dropDown.dataSource = viewModel.creditCardsNumberOnly
        dropDown.anchorView = showCreditCardsListButton
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
            self?.creditCardNumberLabel.text = item
            self?.viewModel.selectedCreditCardIndex = index
            self?.creditCardNumberLabel.normalField()
            self?.showCreditCardsListButton.tintColor = .textColor
        }
    }
    
    private func dropDownActionsHandler() {
        dropDown.cancelAction = { [weak self] in
            self?.creditCardNumberLabel.normalField()
            self?.showCreditCardsListButton.tintColor = .textColor
        }

        dropDown.willShowAction = { [weak self] in
            self?.creditCardNumberLabel.highlightedField()
            self?.showCreditCardsListButton.tintColor = .submitButtonColor
        }
    }
    
    //MARK:  - OBJC FUNCTIONS
    @objc func textFieldValueChanged(_ sender: UITextField) {
        guard let text = sender.text else { return }
        sender.text = viewModel.changeValueFieldFormat(text: text)
    }
    
    @objc func paymentButtonPressed() {
        amountTextField.endEditing(true)
        viewModel.paymentButtonPressed()
    }
    
    @objc func showCreditCardsListButtonPressed() {
        dropDown.show()
    }
}

extension DepositOnRialWalletViewController {
    static func makeInstance(wallet: Wallet) -> DepositOnRialWalletViewController {
        .init(viewModel: DepositOnRialWalletViewModel(wallet: wallet))
    }
}

extension DepositOnRialWalletViewController: DefaultNavigationBarViewProtocol {
    func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    func leftSideButtonPressed() {
        let vc = viewModel.getDestinationViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension DepositOnRialWalletViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.highlightedField()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.normalField()
    }
}

extension DepositOnRialWalletViewController: DepositOnRialWalletViewModelProtocol {
    func transferToBank(with urlString: String) {
        guard let url = URL(string: urlString), !url.absoluteString.isEmpty else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func creditCardsListReceived() {
        creditCardNumberLabel.text = self.viewModel.creditCardsNumberOnly.first
        addingCreditCardsDropDown()
        showCreditCardsListButton.isEnabled = true
    }
}
