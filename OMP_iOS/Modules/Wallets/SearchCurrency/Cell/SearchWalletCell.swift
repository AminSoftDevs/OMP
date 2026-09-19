//
//  SearchWalletCell.swift
//  OMP_iOS
//
//  Created by AminSoft on 7/3/1400 AP.
//

import UIKit
import Kingfisher

class SearchWalletCell: UITableViewCell {
    
//        MARK: - PROPERTIES
    private lazy var containerView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .backgroundColor
        return view
    }()
    
    private lazy var currencyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var currencyIDLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configure(text: "", fontSize: 14, textColor: .textColor, textAlignment: .left, fontType: .regular)
        return label
    }()
    private lazy var currencyNameLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configure(text: "", fontSize: 14, textColor: .textColor, textAlignment: .right, fontType: .regular)
        return label
    }()
    
    private lazy var stackLabel: UIStackView = {
       let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 4
        stack.alignment = .fill
        return stack
    }()
    //    MARK: - INITIALIZERS
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        selectionStyle = .none
        createUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.cornerRadius = 20
        self.setCircularImageView()
    }
    
    func configureCell(with model: Wallet) {
        self.currencyIDLabel.text = model.formattedID
        self.currencyNameLabel.text = "(\(model.currency.name))"
        self.currencyImageView.kf.setImage(with: model.currency.iconPath.stringToURL)
    }
    
    func setCircularImageView() {
        currencyImageView.layer.masksToBounds = true
        self.currencyImageView.layer.cornerRadius = self.currencyImageView.frame.size.width / 2.0
        currencyImageView.layoutIfNeeded()
    }
    //    MARK: - CREATE UI
    private func createUI() {
        addingContainerView()
        addingCurrencyImageView()
        addingStackLabel()
    }
    
    private func addingContainerView() {
        contentView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            containerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            containerView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.95),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
    }
    
    private func addingCurrencyImageView() {
        contentView.addSubview(currencyImageView)
        NSLayoutConstraint.activate([
            currencyImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            currencyImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            currencyImageView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.7),
            currencyImageView.widthAnchor.constraint(equalTo: currencyImageView.heightAnchor),
        ])
    }
    
    private func addingStackLabel() {
        stackLabel.addArrangedSubview(currencyNameLabel)
        stackLabel.addArrangedSubview(currencyIDLabel)
        containerView.addSubview(stackLabel)
        NSLayoutConstraint.activate([
            stackLabel.centerYAnchor.constraint(equalTo: currencyImageView.centerYAnchor),
            stackLabel.trailingAnchor.constraint(equalTo: currencyImageView.leadingAnchor, constant: -5)
        ])
    }
}
