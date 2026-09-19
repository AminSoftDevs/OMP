//
//  UserInfoTableViewCell.swift
//  OMP_iOS
//
//  Created by AminSoft on 7/24/1400 AP.
//

import UIKit

class UserInfoTableViewCell: UITableViewCell {

// MARK: - PROPERTIES
    private lazy var containerView: UIView = {
    let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .cardsColor
        view.layer.cornerRadius = 16
        return view
    }()
    
     lazy var changeModeLabel: UILabel  = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configure(text: "", fontSize: 13, textColor: .textColor, textAlignment: .right, fontType: .regular)
        return label
    }()
    
     lazy var typeCellLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configure(text: "", fontSize: 13, textColor: .textColor, textAlignment: .right, fontType: .regular)
        return label
    }()
    
    private lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "arrow_down_icon")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
//    MARK: - INITILIZERS
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: - CREATE UI
    private func createUI() {
        addedContainerView()
        addingMainImageView()
        addedLeftLabel()
        addedRightLabel()
    }
    private func addedContainerView() {
        contentView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            containerView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    private func addedLeftLabel() {
        containerView.addSubview(changeModeLabel)
        NSLayoutConstraint.activate([
            changeModeLabel.centerYAnchor.constraint(equalTo: mainImageView.centerYAnchor),
            changeModeLabel.leadingAnchor.constraint(equalTo: mainImageView.trailingAnchor, constant: 10)
        ])
    }
    private func addingMainImageView() {
        containerView.addSubview(mainImageView)
        NSLayoutConstraint.activate([
            mainImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            mainImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            mainImageView.widthAnchor.constraint(equalToConstant: 12),
            mainImageView.heightAnchor.constraint(equalToConstant: 12)
        ])
    }
    private func addedRightLabel() {
        containerView.addSubview(typeCellLabel)
        NSLayoutConstraint.activate([
            typeCellLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            typeCellLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
        ])
    }
}
