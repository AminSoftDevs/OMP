//
//  OrdersTableViewHeaderView.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 11/4/21.
//

import UIKit

class OrdersTableViewHeaderView: UIView {
    
    private lazy var mainStackView: UIStackView = {
       var stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var titleImageView: UIImageView = {
       var imageView = UIImageView()
        imageView.image = UIImage(named: "line")
        return imageView
    }()
    
    private lazy var openOrdersTitleLabel: UILabel = {
       var label = UILabel()
        label.configure(text: "OrdersHistoryCollectionView.openOrders".localized, fontSize: 14, textColor: .mediumGrayColor, textAlignment: .center, fontType: .regular)
        return label
    }()
    
    private lazy var marketTitleLabel: UILabel = {
       var label = UILabel()
        label.configure(text: "OrdersHistoryCollectionView.marketName".localized, fontSize: 12, textColor: .textColor, textAlignment: .center, fontType: .regular)
        return label
    }()
    
    private lazy var totalPriceTitleLabel: UILabel = {
       var label = UILabel()
        label.configure(text: "OrdersHistoryCollectionView.totalPrice".localized, fontSize: 12, textColor: .textColor, textAlignment: .center, fontType: .regular)
        return label
    }()
    
    private lazy var statusTitleLabel: UILabel = {
       var label = UILabel()
        label.configure(text: "OrderStatus.completed".localized, fontSize: 12, textColor: .textColor, textAlignment: .center, fontType: .regular)
        return label
    }()
    
    private lazy var amountTitleLabel: UILabel = {
       var label = UILabel()
        label.configure(text: "OrdersHistoryCollectionView.amount".localized, fontSize: 12, textColor: .textColor, textAlignment: .center, fontType: .regular)
        return label
    }()
    
    //MARK: - INITIALIZER
    private let type: OrdersListType
    
    init(type: OrdersListType) {
        self.type = type
        super.init(frame: .zero)
        createUI()
        backgroundColor = .cardsColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - CREATE UI
    private func createUI() {
        addingHeaderStackView()
        addingStackViewSubViews()
    }
    
    private func addingHeaderStackView() {
        addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            mainStackView.topAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    private func addingStackViewSubViews() {
        mainStackView.addArrangedSubview(statusTitleLabel)
        mainStackView.addArrangedSubview(totalPriceTitleLabel)
        mainStackView.addArrangedSubview(amountTitleLabel)
        mainStackView.addArrangedSubview(marketTitleLabel)
        
        if type == .open {
            mainStackView.insertArrangedSubview(UIView(), at: 0)
        }
    }
}
