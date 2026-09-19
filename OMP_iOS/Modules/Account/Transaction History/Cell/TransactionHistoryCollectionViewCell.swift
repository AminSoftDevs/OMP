//
//  TransactionHistoryCollectionViewCell.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 8/26/21.
//

import UIKit

class TransactionHistoryCollectionViewCell: UICollectionViewCell {
    
    var transaction: Transaction? {
        didSet {
            updateUI()
        }
    }
    
    private lazy var transactionTypeLabel: UILabel = {
      var label = UILabel()
        label.configure(text: "", fontSize: 14, textColor: .textColor, textAlignment: .right, fontType: .regular)
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
      var label = UILabel()
        label.configure(text: "", fontSize: 14, textColor: .mediumGrayColor, textAlignment: .right, fontType: .regular)
        return label
    }()
    
    private lazy var balanceLabel: UILabel = {
      var label = UILabel()
        label.configure(text: "", fontSize: 14, textColor: .textColor, textAlignment: .left, fontType: .regular)
        return label
    }()
    
    private lazy var amountLabel: UILabel = {
      var label = UILabel()
        label.configure(text: "", fontSize: 14, textColor: .textColor, textAlignment: .right, fontType: .regular)
        return label
    }()
    
    private lazy var iconImageView: UIImageView = {
       var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    //MARK: - DEFAULT INITIALIZER
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .backgroundColor
        layer.cornerRadius = 15
        clipsToBounds = true
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - CREATE UI
    private func createUI() {
        addingDateLabel()
        addingBalanceLabel()
        addingTransactionTypeLabel()
        addingAmountLabel()
        addingIcon()
    }
    
    private func addingDateLabel() {
        addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    
    private func addingBalanceLabel() {
        addSubview(balanceLabel)
        balanceLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            balanceLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            balanceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        ])
    }
    
    private func addingTransactionTypeLabel() {
        addSubview(transactionTypeLabel)
        transactionTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            transactionTypeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            transactionTypeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
    
    private func addingAmountLabel() {
        addSubview(amountLabel)
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            amountLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            amountLabel.centerYAnchor.constraint(equalTo: transactionTypeLabel.centerYAnchor, constant: 3)
        ])
    }
    
    private func addingIcon() {
        addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: amountLabel.trailingAnchor, constant: 8),
            iconImageView.centerYAnchor.constraint(equalTo: amountLabel.centerYAnchor, constant: -2),
            iconImageView.widthAnchor.constraint(equalToConstant: 10),
            iconImageView.heightAnchor.constraint(equalToConstant: 10),
        ])
    }
    
    //MARK: - UPDATE UI
    private func updateUI() {
        guard let item = transaction else { return }
        transactionTypeLabel.text = item.transactionType
        balanceLabel.text = item.transactionBalance
        dateLabel.text = item.createdTime
        amountLabel.text = item.transactionAmount
        amountLabel.textColor = item.color
        iconImageView.image = UIImage(named: item.iconName)?.withRenderingMode(.alwaysTemplate)
        iconImageView.tintColor = item.color
    }
}
