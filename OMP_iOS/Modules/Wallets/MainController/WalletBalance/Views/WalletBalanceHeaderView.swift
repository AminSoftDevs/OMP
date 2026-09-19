//
//  WalletBalanceHeaderView.swift
//  OMP_iOS
//
//  Created by AminSoft on 7/5/1400 AP.
//

import UIKit

class WalletBalanceHeaderView: UIView {

    //  MARK: - PROPERTIES
    private lazy var currencyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .red
        return imageView
    }()
    
    private lazy var inventoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configure(text: "موجودی", fontSize: 18, textColor: .white, textAlignment: .right, fontType: .regular)
        return label
    }()
    
    private lazy var walletBallanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configure(text: "", fontSize: 14, textColor: .white, textAlignment: .left, fontType: .regular)
        return label
    }()
    //    MARK: - INITILIZER
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .backgroundColor
        creteUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 16
        setCornerRadiusToCurrencyImageView()
    }
    
    private func setCornerRadiusToCurrencyImageView() {
        currencyImageView.layer.masksToBounds = false
        currencyImageView.layer.cornerRadius = currencyImageView.bounds.height / 2
    }
    
    //    MARK: - CREATE UI
    private func creteUI() {
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
            currencyImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.45),
            currencyImageView.widthAnchor.constraint(equalTo: currencyImageView.heightAnchor)
        ])
    }
    
    private func addingWalletBalanceLabel() {
        addSubview(walletBallanceLabel)
        NSLayoutConstraint.activate([
            walletBallanceLabel.centerYAnchor.constraint(equalTo: currencyImageView.centerYAnchor),
            walletBallanceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
        ])
    }
}
