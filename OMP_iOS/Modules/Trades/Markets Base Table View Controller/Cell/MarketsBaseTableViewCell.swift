//
//  MarketsBaseTableViewCell.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 11/6/21.
//

import UIKit

class MarketsBaseTableViewCell: UITableViewCell {
    
    var market: Markets? {
        didSet {
            self.updateUI()
        }
    }
    
    private lazy var containerView: UIView = {
        var view = UIView()
        view.backgroundColor = .backgroundColor
        view.layer.cornerRadius = 15
        return view
    }()
    
    private var mainStackView: UIStackView = {
       var stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 5
        return stackView
    }()
    
    private lazy var currencySymbolsLabel: UILabel = {
        var label = UILabel()
        label.configure(text: "", fontSize: 13, textColor: .textColor, textAlignment: .center, fontType: .regular)
        return label
    }()

    private lazy var lastValueLabel: UILabel = {
        var label = UILabel()
        label.configure(text: "", fontSize: 14, textColor: .textColor, textAlignment: .center, fontType: .regular)
        return label
    }()
    
    private lazy var changePercentLabel: UILabel = {
        var label = UILabel()
        label.configure(text: "", fontSize: 15, textColor: .textColor, textAlignment: .center, fontType: .regular)
        return label
    }()
    
    weak var delegate: MarketDelegate?
        
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
        addingMainStackView()
        addingItemsToMainStackView()
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
    
    private func addingMainStackView() {
        containerView.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 17),
            mainStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            mainStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            mainStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15),
        ])
    }
    
    private func addingItemsToMainStackView() {
        mainStackView.addArrangedSubview(changePercentLabel)
        mainStackView.addArrangedSubview(lastValueLabel)
        mainStackView.addArrangedSubview(currencySymbolsLabel)
    }
    //MARK: - UPDATE UI
    private func updateUI() {
        guard let item = market else { return }
        changePercentLabel.text = item.formattedPercent
        lastValueLabel.text = item.formattedLastPrice
        currencySymbolsLabel.text = item.formattedSymbol
        changePercentLabel.textColor = item.color
    }
}
