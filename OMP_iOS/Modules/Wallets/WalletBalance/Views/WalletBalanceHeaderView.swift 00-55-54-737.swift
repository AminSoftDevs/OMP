//
//  WalletBalanceHeaderView.swift
//  OMP_iOS
//
//  Created by AminSoft on 7/5/1400 AP.
//

import UIKit
import Kingfisher

class WalletBalanceHeaderView: UIView {

    //  MARK: - PROPERTIES
     lazy var currencyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
     lazy var inventoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configure(text: "WalletBalanceHeaderView.balance".localized, fontSize: 18, textColor: .textColor, textAlignment: .right, fontType: .regular)
        return label
    }()
    
     lazy var walletBalanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configure(text: "", fontSize: 16, textColor: .submitButtonColor, textAlignment: .left, fontType: .regular)
        return label
    }()
    //    MARK: - INITIALIZER
    private let viewModel: WalletBalanceViewModel
    
    init(viewModel: WalletBalanceViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        self.layer.cornerRadius = 16
        self.backgroundColor = .backgroundColor
        createUI()
        updateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()
        currencyImageView.layer.cornerRadius = currencyImageView.frame.height / 2
    }
    
    //    MARK: - CREATE UI
    private func createUI() {
        addingInventoryLabel()
        addingCurrencyImageView()
        addingWalletBalanceLabel()
    }
    
    private func addingInventoryLabel() {
        addSubview(inventoryLabel)
        NSLayoutConstraint.activate([
            inventoryLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            inventoryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
        ])
    }
    
    private func addingCurrencyImageView() {
        addSubview(currencyImageView)
        NSLayoutConstraint.activate([
            currencyImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            currencyImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            currencyImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.35),
            currencyImageView.widthAnchor.constraint(equalTo: currencyImageView.heightAnchor)
        ])
    }
    
    private func addingWalletBalanceLabel() {
        addSubview(walletBalanceLabel)
        NSLayoutConstraint.activate([
            walletBalanceLabel.centerYAnchor.constraint(equalTo: currencyImageView.centerYAnchor),
            walletBalanceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
        ])
    }
    
//    MARK: - UPDATE UI WITH VIEWMODEL
    private func updateUI() {
        self.currencyImageView.kf.setImage(with: viewModel.walletIcon)
        self.walletBalanceLabel.text = viewModel.totalPropertyCurrency
    }
}
