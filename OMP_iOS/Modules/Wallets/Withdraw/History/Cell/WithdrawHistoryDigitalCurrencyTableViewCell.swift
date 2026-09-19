//
//  WithdrawHistoryDigitalCurrencyTableViewCell.swift
//  OMP_iOS
//
//  Created by AminSoft on 7/20/1400 AP.
//

import UIKit

class WithdrawHistoryDigitalCurrencyTableViewCell: UITableViewCell {

//    MARK: - PROPERTIES
    var withdrawItem: WithdrawHistory? {
        didSet {
            updateUI()
        }
    }
    private lazy var containerView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .backgroundColor
        view.layer.cornerRadius = 15
        return view
    }()

    private lazy var statusLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configure(text: "", fontSize: 13, textColor: .textColor, textAlignment: .right, fontType: .regular)
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configure(text: "", fontSize: 13, textColor: .mediumGrayColor, textAlignment: .left, fontType: .regular)
        return label
    }()
    
    private lazy var walletCodeLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configure(text: "", fontSize: 13, textColor: .mediumGrayColor, textAlignment: .left, fontType: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var amountLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configure(text: "", fontSize: 13, textColor: .textColor, textAlignment: .left, fontType: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var transferFeeLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configure(text: "", fontSize: 13, textColor: .textColor, textAlignment: .right, fontType: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var messageLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configure(text: "", fontSize: 12, textColor: .textColor, textAlignment: .right, fontType: .regular)
        label.numberOfLines = 0
        return label
    }()
//    MARK: - INITILIZER
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

//    MARK: - CREATE UI
    private func createUI() {
        addingContainerView()
        addingStatusLabel()
        addingDateLabel()
        addingAmountLabel()
        addingTransferFeeLabel()
        
        addingWalletCodeLabel()
        
        addingMessageLabel()
    }
    
    private func addingContainerView() {
        contentView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func addingStatusLabel() {
        containerView.addSubview(statusLabel)
        NSLayoutConstraint.activate([
            statusLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            statusLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
        ])
    }
    
    private func addingDateLabel() {
        containerView.addSubview(dateLabel)
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            dateLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
        ])
    }
    
    private func addingTransferFeeLabel() {
        containerView.addSubview(transferFeeLabel)
        NSLayoutConstraint.activate([
            transferFeeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            transferFeeLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 10)
        ])
        
    }
    private func addingWalletCodeLabel() {
        containerView.addSubview(walletCodeLabel)
        NSLayoutConstraint.activate([
            walletCodeLabel.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 10),
            walletCodeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            walletCodeLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.8),
        ])
    }
    
    private func addingAmountLabel() {
        containerView.addSubview(amountLabel)
        NSLayoutConstraint.activate([
            amountLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            amountLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20)
        ])
    }
    private func addingMessageLabel() {
        containerView.addSubview(messageLabel)
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: walletCodeLabel.bottomAnchor, constant: 10),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            messageLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
        ])
    }
    
//    MARK: - UPDATE UI
    private func updateUI() {
        guard let item = withdrawItem else { return }
        statusLabel.text = item.status.stringFromType()
        statusLabel.textColor = item.statusColor
        dateLabel.text = item.creationDate
        walletCodeLabel.text = item.wallet
        amountLabel.text = item.formattedAmount
        messageLabel.text = item.message
        transferFeeLabel.text = "Withdraw.wage".localized + " : " + "\(item.fee.isInteger ? String(Int(item.fee.changeToToman)).convertEngNumToPersianNum() : item.fee.changeToToman.toString.convertEngNumToPersianNum())"
    }
}

