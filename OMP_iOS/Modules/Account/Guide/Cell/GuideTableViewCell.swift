//
//  GuideTableViewCell.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 11/8/21.
//

import UIKit

class GuideTableViewCell: UITableViewCell {
    
    var guidOption: Guide? {
        didSet {
            updateUI()
        }
    }
    // MARK: - PROPERTIES
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .cardsColor
        view.layer.cornerRadius = 16
        return view
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel  = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configure(text: "", fontSize: 11, textColor: .textColor, textAlignment: .right, fontType: .bold)
        return label
    }()
    
    //MARK: - INITIALIZERS
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        layer.cornerRadius = 20
        selectionStyle = .none
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    MARK: - CREATE UI
    private func createUI() {
        addedContainerView()
        addingIconImageView()
        addingTitleLabel()
    }
    
    private func addedContainerView() {
        contentView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            containerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            containerView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    private func addingIconImageView() {
        containerView.addSubview(iconImageView)
        NSLayoutConstraint.activate([
            iconImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 40),
            iconImageView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func addingTitleLabel() {
        containerView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor, constant: 3),
            titleLabel.trailingAnchor.constraint(equalTo: iconImageView.leadingAnchor, constant: -15)
        ])
    }
    
    //MARK: - UPDATE UI
    private func updateUI() {
        guard let option = guidOption else { return }
        titleLabel.text = option.title
        iconImageView.image = UIImage(named: option.iconName)
    }
}
