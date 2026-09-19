//
//  OrdersHistoryTableViewCell.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 10/31/21.
//

import UIKit

class OrdersTableViewCell: UITableViewCell {
    
    var cellType: OrdersListType = .history {
        didSet {
           createUI()
        }
    }
    
    var order: Orders? {
        didSet {
            updateUI()
        }
    }
    
    private lazy var containerView: UIView = {
        var view = UIView()
        view.backgroundColor = .backgroundColor
        view.layer.cornerRadius = 15
        return view
    }()
    
    private var mainStackView: UIStackView = {
       var stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 5
        return stackView
    }()
    
    private lazy var nameLabel: UILabel = {
      var label = UILabel()
        label.configure(text: "", fontSize: 12, textColor: .textColor, textAlignment: .center, fontType: .regular)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var statusLabel: UILabel = {
      var label = UILabel()
        label.configure(text: "", fontSize: 12, textColor: .textColor, textAlignment: .center, fontType: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var totalPriceLabel: UILabel = {
      var label = UILabel()
        label.configure(text: "", fontSize: 14, textColor: .textColor, textAlignment: .center, fontType: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var amountLabel: UILabel = {
      var label = UILabel()
        label.configure(text: "", fontSize: 14, textColor: .textColor, textAlignment: .center, fontType: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var cancelButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configure(fontSize: 12, title: "OrdersHistoryCollectionViewCell.cancel".localized, fontType: .regular, titleColor: .backgroundColor, backgroundColor: .rejectOrangeColor, borderColor: .clear, cornerRadius: 15)
        button.addTarget(self, action: #selector(cancelOrderButton), for: .touchUpInside)
        button.setTitleColor(.textColor, for: .disabled)
        return button
    }()
    
    private lazy var openOrderSelectionButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(openOrderSelectionButtonPressed), for: .touchUpInside)
        return button
    }()
    
    weak var delegate: OrdersTableViewProtocol?
    
    //MARK: - DEFAULT INITIALIZER
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        createUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - CREATE UI
    private func createUI() {
        addingContainerView()
        addingMainStackView()
        addingItemsToStackView()
        addingOpenOrderSelectionButton()
    }
    
    private func addingContainerView() {
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }
    
    private func addingMainStackView() {
        containerView.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cancelButton.heightAnchor.constraint(equalToConstant: 45),
            mainStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            mainStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            mainStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            mainStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
        ])
    }
    
    private func addingItemsToStackView() {
        if cellType == .open {
            mainStackView.addArrangedSubview(cancelButton)
        }
        mainStackView.addArrangedSubview(statusLabel)
        mainStackView.addArrangedSubview(totalPriceLabel)
        mainStackView.addArrangedSubview(amountLabel)
        mainStackView.addArrangedSubview(nameLabel)
    }
    
    private func addingOpenOrderSelectionButton() {
        containerView.addSubview(openOrderSelectionButton)
        openOrderSelectionButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            openOrderSelectionButton.topAnchor.constraint(equalTo: containerView.topAnchor),
            openOrderSelectionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            openOrderSelectionButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.7),
            openOrderSelectionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    //MARK: - OBJC FUNCTIONS
    @objc func cancelOrderButton() {
        guard let item = order else { return }
        delegate?.cancelPendingOrder(order: item)
    }
    
    @objc func openOrderSelectionButtonPressed() {
        guard let item = order else { return }
        delegate?.moveToMarketBySelectingOpenOrder(order: item)
    }
    
    //MARK: - UPDATE UI
    private func updateUI() {
        guard let item = order else { return }
        nameLabel.text = item.market.name
        statusLabel.text = item.status.stringFromType()
        totalPriceLabel.text = item.totalPrice
        amountLabel.text = item.formattedAmount
        
        statusLabel.textColor = item.orderColor
        totalPriceLabel.textColor = item.orderColor
        amountLabel.textColor = item.orderColor
    }
}
