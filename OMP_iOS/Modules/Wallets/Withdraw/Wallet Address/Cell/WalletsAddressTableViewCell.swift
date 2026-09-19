//
//  WalletsAddressTableViewCell.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 1/25/22.
//

import Foundation
import UIKit

class WalletsAddressTableViewCell: UITableViewCell {
    
    var walletAddress: WalletAddress? {
        didSet {
            updateUI()
        }
    }
    
    var deletedItem: ((WalletAddress) -> Void)?
    var editItem: ((WalletAddress) -> Void)?
    
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
    
    private lazy var nameLabel: UILabel = {
        var label = UILabel()
        label.configure(text: "", fontSize: 13, textColor: .textColor, textAlignment: .right, fontType: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var addressLabel: UILabel = {
        var label = UILabel()
        label.configure(text: "", fontSize: 13, textColor: .textColor, textAlignment: .right, fontType: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        return stackView
    }()
    
    private lazy var deleteButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(named: "trash_icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.tintColor = .submitButtonColor
        button.imageView?.contentMode = .center
        button.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var editButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(named: "edit_icon2")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.tintColor = .submitButtonColor
        button.imageView?.contentMode = .center
        button.addTarget(self, action: #selector(editButtonPressed), for: .touchUpInside)
        return button
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
        addingButtonsStackView()
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
    
    private func addingButtonsStackView() {
        containerView.addSubview(buttonsStackView)
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonsStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            buttonsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 40),
            buttonsStackView.widthAnchor.constraint(equalToConstant: 110),
        ])
        
        buttonsStackView.addArrangedSubview(deleteButton)
        buttonsStackView.addArrangedSubview(editButton)
    }
    
    private func addingNameStackView() {
        containerView.addSubview(nameStackView)
        nameStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            nameStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            nameStackView.leadingAnchor.constraint(equalTo: buttonsStackView.trailingAnchor, constant: 8),
            nameStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
        ])
        nameStackView.addArrangedSubview(nameLabel)
        nameStackView.addArrangedSubview(addressLabel)
    }
    
    
    //MARK: - OBJC FUNCTIONS
    @objc func deleteButtonPressed() {
        guard let wallet = self.walletAddress else { return }
        deletedItem?(wallet)
    }
    
    @objc func editButtonPressed() {
        guard let wallet = self.walletAddress else { return }
        editItem?(wallet)
    }
    
    //MARK: - UPDATE UI
    private func updateUI() {
        guard let wallet = self.walletAddress else { return }
        nameLabel.text = wallet.name
        addressLabel.text = wallet.wallet
    }
}
