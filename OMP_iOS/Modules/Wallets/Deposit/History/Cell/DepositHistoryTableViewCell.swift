//
//  DepositHistoryTableViewCell.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 10/11/21.
//

import UIKit

class DepositHistoryTableViewCell: UITableViewCell {
    
    var depositItem: DepositHistory? {
        didSet {
            updateUI()
        }
    }
    
    private lazy var containerView: UIView = {
        var view = UIView()
        view.backgroundColor = .backgroundColor
        view.layer.cornerRadius = 15
        return view
    }()
    
    private lazy var statusLabel: UILabel = {
        var label = UILabel()
        label.configure(text: "", fontSize: 13, textColor: .textColor, textAlignment: .right, fontType: .regular)
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        var label = UILabel()
        label.configure(text: "", fontSize: 13, textColor: .mediumGrayColor, textAlignment: .left, fontType: .regular)
        return label
    }()
    
    private lazy var trackingCodeLabel: UILabel = {
        var label = UILabel()
        label.configure(text: "", fontSize: 13, textColor: .mediumGrayColor, textAlignment: .right, fontType: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var amountLabel: UILabel = {
        var label = UILabel()
        label.configure(text: "", fontSize: 13, textColor: .textColor, textAlignment: .left, fontType: .regular)
        label.numberOfLines = 0
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
        addingContainerView()
        addingStatusLabel()
        addingDateLabel()
        addingTrackingCodeLabel()
        addingAmountLabel()
    }
    
    private func addingContainerView() {
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    private func addingStatusLabel() {
        containerView.addSubview(statusLabel)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statusLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
        ])
    }
    
    private func addingDateLabel() {
        containerView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            dateLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
        ])
    }
    
    private func addingTrackingCodeLabel() {
        containerView.addSubview(trackingCodeLabel)
        trackingCodeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            trackingCodeLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 20),
            trackingCodeLabel.trailingAnchor.constraint(equalTo: statusLabel.trailingAnchor),
            trackingCodeLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.6),
            trackingCodeLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
        ])
    }
    
    private func addingAmountLabel() {
        containerView.addSubview(amountLabel)
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            amountLabel.topAnchor.constraint(equalTo: trackingCodeLabel.topAnchor),
            amountLabel.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor),
            amountLabel.trailingAnchor.constraint(equalTo: trackingCodeLabel.leadingAnchor, constant: -10)
        ])
    }
    
    //MARK: - UPDATE UI
    private func updateUI() {
        guard let item = depositItem else { return }
        statusLabel.text = item.status.stringFromType()
        statusLabel.textColor = item.statusColor
        dateLabel.text = item.creationDate
        trackingCodeLabel.text = item.trackingCode
        amountLabel.text = item.formattedAmount
    }
}
