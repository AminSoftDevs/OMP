//
//  OrderInputView.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 11/10/21.
//

import UIKit


class OrderInputView: UIView {
    
    private lazy var inputTextField: UITextField = {
        var textField = UITextField()
        textField.configure(placeholder: viewModel.getPlaceholder(), borderColor: .clear, fontSize: 11, fontType: .regular, keyboardType: .decimalPad, textAlignment: .center, radius: 0, backgroundColor: .clear, textColor: .textColor)
        textField.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
        return textField
    }()
    
    private lazy var plusButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(named: "plus"), for: .normal)
        button.addTarget(self, action: #selector(plusButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var minusButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(named: "minus"), for: .normal)
        button.addTarget(self, action: #selector(minusButtonPressed), for: .touchUpInside)
        return button
    }()
    
    weak var delegate: NewPotentialOrdersViewDelegate?
    
    //MARK: - INITIALIZER
    let viewModel: OrdersInputViewViewModel
    
    init(viewModel: OrdersInputViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        backgroundColor = .clear
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.textColor.cgColor
        createUI()
        viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        plusButton.layer.cornerRadius = plusButton.frame.width / 2
        minusButton.layer.cornerRadius = minusButton.frame.width / 2
    }
    
    //MARK:  - CREATE UI
    private func createUI() {
        addingPlusButton()
        addingMinusButton()
        addingInputTextField()
    }
    
    private func addingPlusButton() {
        addSubview(plusButton)
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            plusButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            plusButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            plusButton.widthAnchor.constraint(equalToConstant: 20),
            plusButton.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func addingMinusButton() {
        addSubview(minusButton)
        minusButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            minusButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            minusButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            minusButton.widthAnchor.constraint(equalToConstant: 20),
            minusButton.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func addingInputTextField()  {
        addSubview(inputTextField)
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            inputTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 2),
            inputTextField.heightAnchor.constraint(equalTo: self.heightAnchor),
            inputTextField.leadingAnchor.constraint(equalTo: plusButton.trailingAnchor, constant: 2),
            inputTextField.trailingAnchor.constraint(equalTo: minusButton.leadingAnchor, constant: -2),
        ])
    }
    
    private func pulseAnimation(_ sender: UIButton) {
        UIView.animate(withDuration: 0.15) {
            sender.backgroundColor = .textColor.withAlphaComponent(0.5)
        } completion: { _ in
            sender.backgroundColor = .clear
        }
    }
    
    //MARK: - Data Will Receive From Parent Here
    func selectedMarketHandler(market: Markets) {
        viewModel.selectedMarket = market
        inputTextField.placeholder = viewModel.getPlaceholder()
        inputTextField.text = viewModel.getPlaceholder()
    }
    
    func fieldValueUpdated(value: String) {
        viewModel.value = value
    }
    
    //MARK: - OBJC FUNCTIONS
    @objc func plusButtonPressed(_ sender: UIButton) {
        pulseAnimation(sender)
        viewModel.handlePlusButtonAction()
    }
    
    @objc func minusButtonPressed(_ sender: UIButton) {
        pulseAnimation(sender)
        viewModel.handleMinusButtonAction()
    }
    
    @objc func textFieldValueChanged(_ sender: UITextField) {
        if let text = sender.text {
            viewModel.changedByTyping = true
            inputTextField.text = viewModel.handleChangedByTyping(text: text)
            delegate?.inputFieldCurrentValue(value: viewModel.value, type: viewModel.getViewType)
            viewModel.changedByTyping = false
        }
    }
}

//MARK: - NewPotentialOrdersViewDelegate
extension OrderInputView: NewPotentialOrdersViewDelegate {
    func inputFieldCurrentValue(value: String, type: OrderInputType) {
        delegate?.inputFieldCurrentValue(value: value, type: type)
    }
    
    func inputsTextFieldShouldUpdate() {
        inputTextField.text = viewModel.textFieldValueHandler
    }
}

//MARK: - MAKE INSTANCE METHOD
extension OrderInputView {
    static func makeInstance(type: OrderInputType) -> OrderInputView {
        .init(viewModel: OrdersInputViewViewModel(inputType: type))
    }
}
