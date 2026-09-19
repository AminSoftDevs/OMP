//
//  AnnouncementTableViewCell.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 8/20/21.
//

import UIKit

class AnnouncementTableViewCell: UITableViewCell {

    var announcement: Announcement? {
        didSet {
            self.updateUI()
        }
    }
    
    var announcementHasOpened: Bool = false {
        didSet {
            iconImageView.image = UIImage(named: "opened_message_icon")
        }
    }
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundColor
        view.layer.cornerRadius = 15
        return view
    }()
    
    private lazy var iconImageView: UIImageView = {
       var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
       var label = UILabel()
        label.configure(text: "", fontSize: 14, textColor: .textColor, textAlignment: .right, fontType: .regular)
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
       var label = UILabel()
        label.configure(text: "", fontSize: 14, textColor: .mediumGrayColor, textAlignment: .left, fontType: .regular)
        return label
    }()
    
    private lazy var messageLabel: UILabel = {
       var label = UILabel()
        label.configure(text: "", fontSize: 14, textColor: .textColor, textAlignment: .right, fontType: .regular)
        label.numberOfLines = 2
        label.setLineSpacing(lineSpacing: 5, lineHeightMultiple: 5)
        return label
    }()
    
    //MARK: - DEFAULT INITIALIZER
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        self.createUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - CREATE UI
    private func createUI() {
        addingContainerView()
        addingIconImageView()
        addingDateLabel()
        addingTitleLabel()
        addingMessageLabel()
    }
    
    private func addingContainerView() {
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }
    
    private func addingIconImageView() {
        addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            iconImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            iconImageView.heightAnchor.constraint(equalToConstant: 15),
            iconImageView.widthAnchor.constraint(equalToConstant: 15),
        ])
    }
    
    private func addingDateLabel() {
        addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
        ])
    }
    
    private func addingTitleLabel() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: iconImageView.leadingAnchor, constant: -5),
            titleLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 5)
        ])
    }
    
    private func addingMessageLabel() {
        addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            messageLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
        ])
    }
    
    //MARK: - UPDATE UI
    private func updateUI() {
        guard let item = announcement else { return }
        iconImageView.image = UIImage(named: item.iconName)
        titleLabel.text = item.title
        messageLabel.text = item.message
        dateLabel.text = item.createTime
    }
}
