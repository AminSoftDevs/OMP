//
//  WalletsCollectionViewCell.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 9/26/21.
//

import UIKit
import Kingfisher

class WalletsCollectionViewCell: UICollectionViewCell {
    
    var wallet: Wallet? {
        didSet {
            self.updateUI()
        }
    }
    
    lazy var iconImageView: UIImageView = {
       var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .mediumGrayColor
        return imageView
    }()
    
    lazy var idStackView: UIStackView = {
       var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .trailing
        stackView.distribution = .fillEqually
        stackView.spacing = 15
        return stackView
    }()
    
    lazy var currencyIDLabel: UILabel = {
      var label = UILabel()
        label.configure(text: "", fontSize: 14, textColor: .textColor, textAlignment: .center, fontType: .regular)
        return label
    }()
    
    lazy var balanceLabel: UILabel = {
      var label = UILabel()
        label.configure(text: "", fontSize: 14, textColor: .textColor, textAlignment: .center, fontType: .regular)
        return label
    }()
    
    lazy var balanceInTomanLabel: UILabel = {
      var label = UILabel()
        label.configure(text: "", fontSize: 14, textColor: .textColor, textAlignment: .center, fontType: .regular)
        return label
    }()
    
    //MARK: - DEFAULT INITIALIZER
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .backgroundColor
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        self.createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.iconImageView.layer.cornerRadius = self.iconImageView.frame.height / 2
    }
    
    //MARK: - CREATE UI
    fileprivate func createUI() {
        self.addingIconImageView()
        self.addingIdStackView()
        self.addingBalanceInTomanLabel()
    }
    
    fileprivate func addingIconImageView() {
        self.addSubview(iconImageView)
        self.iconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0),
            iconImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            iconImageView.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.6),
            iconImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.6)
        ])
    }
    
    fileprivate func addingIdStackView() {
        self.addSubview(idStackView)
        self.idStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            idStackView.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor, constant: 5),
            idStackView.trailingAnchor.constraint(equalTo: iconImageView.leadingAnchor, constant: -20),
        ])
        
        self.idStackView.addArrangedSubview(currencyIDLabel)
        self.idStackView.addArrangedSubview(balanceLabel)
    }
    
    fileprivate func addingBalanceInTomanLabel() {
        self.addSubview(balanceInTomanLabel)
        self.balanceInTomanLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            balanceInTomanLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            balanceInTomanLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor, constant: 0),
            
        ])
    }
    //MARK: - UPDATE UI
    fileprivate func updateUI() {
        guard let wallet = self.wallet else { return }
        self.currencyIDLabel.text = wallet.formattedID
        self.balanceLabel.text = wallet.balance.convertEngNumToPersianNum()
        self.balanceInTomanLabel.text = wallet.calculateRialWorth()
        self.iconImageView.kf.setImage(with: wallet.currency.iconPath.stringToURL)
    }
}
