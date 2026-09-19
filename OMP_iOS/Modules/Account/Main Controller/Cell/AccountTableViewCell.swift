//
//  AccountTableViewCell.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 8/5/21.
//

import UIKit

class AccountTableViewCell: UITableViewCell {

    var userAccountItem: AccountTableOptions? {
        didSet {
            updateUI()
        }
    }
    
    private lazy var iconImageView: UIImageView = {
       var imageView = UIImageView()
        imageView.contentMode = .center
        imageView.layer.cornerRadius = 10
        imageView.layer.borderWidth = 1
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
       var label = UILabel()
        label.configure(text: "", fontSize: 12, textColor: .textColor, textAlignment: .right, fontType: .bold)
        return label
    }()
    
    
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
        addingIconImageView()
        addingTitleLabel()
    }
    
    private func addingIconImageView() {
        addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            iconImageView.heightAnchor.constraint(equalToConstant: 35),
            iconImageView.widthAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    private func addingTitleLabel() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: iconImageView.leadingAnchor, constant: -20),
        ])
    }

    //MARK: - UPDATE UI
    private func updateUI() {
        guard let item = userAccountItem else { return }
        iconImageView.image = UIImage(named: item.iconName)?.withRenderingMode(.alwaysTemplate)
        iconImageView.tintColor = item.color
        iconImageView.layer.borderColor = item.color.cgColor
        titleLabel.text = item.title
        titleLabel.textColor = item.color
    }
}
