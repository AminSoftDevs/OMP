//
//  WalletAddressBriefTableViewCell.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 1/28/22.
//

import UIKit

class WalletAddressBriefTableViewCell: UITableViewCell {
    
    var walletAddress: WalletAddress? {
        didSet {
            updateUI()
        }
    }
    //MARK: - UI ELEMENTS
    private lazy var containerView: UIView = {
        var view = UIView()
        view.backgroundColor = .cardsColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var nameStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 5
        return stackView
    }()
    
    private lazy var addressLabel: UILabel = {
        var label = UILabel()
        label.configure(text: "", fontSize: 13, textColor: .textColor, textAlignment: .left, fontType: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var currencyTokenLabel: UILabel = {
        var label = UILabel()
        label.configure(text: "", fontSize: 13, textColor: .textColor, textAlignment: .left, fontType: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    //MARK: - DEFAULT INITIALIZER
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        createUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - CREATE UI
    private func createUI() {
        addingContainerView()
        addingNameStackView()
    }
    
    private func addingContainerView() {
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }
    
    private func addingNameStackView() {
        containerView.addSubview(nameStackView)
        nameStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            nameStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            nameStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            nameStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
        ])
        nameStackView.addArrangedSubview(addressLabel)
        nameStackView.addArrangedSubview(currencyTokenLabel)
    }
    
    //MARK: - UPDATE UI
    private func updateUI() {
        guard let wallet = self.walletAddress else { return }
        addressLabel.text = wallet.wallet
        currencyTokenLabel.text = wallet.currencyToken
    }
}
