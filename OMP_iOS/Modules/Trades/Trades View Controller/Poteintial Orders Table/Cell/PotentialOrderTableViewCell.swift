//
//  NewPotentialOrderTableViewCell.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 11/10/21.
//

import UIKit

class PotentialOrderTableViewCell: UITableViewCell {
    
    var selectedMarket: Markets?
    
    var potentialOrder: PotentialOrders? {
        didSet {
            self.updateUI()
        }
    }
    
    var volumePercent: Double = 0 {
        didSet {
            let finalWidth = Constants.screenWidth * volumePercent
            UIView.animate(withDuration: 0.3) {
                self.highlightViewWidth.constant = finalWidth
                self.containerView.layoutIfNeeded()
            }
        }
    }
    
    private lazy var highlightBackgroundView: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 5
        return view
    }()
    
    private lazy var containerView: UIView = {
        var view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var mainStackView: UIStackView = {
       var stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        return stackView
    }()
    
    private lazy var unitPriceLabel: UILabel = {
      var label = UILabel()
        label.configure(text: "", fontSize: 13, textColor: .textColor, textAlignment: .natural, fontType: .regular)
        return label
    }()
    
    private lazy var amountLabel: UILabel = {
      var label = UILabel()
        label.configure(text: "", fontSize: 13, textColor: .textColor, textAlignment: .natural, fontType: .regular)
        return label
    }()
    
    var highlightViewWidth = NSLayoutConstraint()
    
    //MARK: - DEFAULT INITIALIZER
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        self.createUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - CREATE UI
    private func createUI() {
        addingContainerView()
        addingHighlightedBackgroundView()
        addingMaiStackView()
    }
    
    private func addingContainerView() {
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 1),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1),
        ])
    }
    
    private func addingHighlightedBackgroundView() {
        containerView.addSubview(highlightBackgroundView)
        highlightBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            highlightBackgroundView.topAnchor.constraint(equalTo: containerView.topAnchor),
            highlightBackgroundView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0),
            highlightBackgroundView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
        highlightViewWidth = highlightBackgroundView.widthAnchor.constraint(equalToConstant: 0)
        highlightViewWidth.isActive = true
    }
    
    private func addingMaiStackView() {
        containerView.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            mainStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            mainStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
        mainStackView.addArrangedSubview(amountLabel)
        mainStackView.addArrangedSubview(unitPriceLabel)
    }
    
    //MARK: - UPDATE UI
    private func updateUI() {
        guard let order = self.potentialOrder else { return }
        amountLabel.text = order.formattedAmount
        unitPriceLabel.text = order.formattedPrice(selectedMarket: selectedMarket)
        unitPriceLabel.textColor = order.color
        highlightBackgroundView.backgroundColor = order.highlightColor.withAlphaComponent(0.3)
    }
}
