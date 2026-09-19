//
//  MarketTableViewCell.swift
//  OMP_iOS
//
//  Created by AminSoft on 8/16/1400 AP.
//

import UIKit
import MHLoadingButton


class MarketTableViewCell: UITableViewCell {
    
    //MARK: - PROPERTIES
    var market: Market? {
        didSet {
            self.updateUI()
        }
    }
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .backgroundColor
        view.layer.cornerRadius = 15
        return view
    }()
    private lazy var currencySymbolsLabel: UILabel = {
        var label = UILabel()
        label.configure(text: "", fontSize: 15, textColor: .textColor, textAlignment: .center, fontType: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var lastVolumeLabel: UILabel = {
        var label = UILabel()
        label.configure(text: "", fontSize: 14, textColor: .mediumGrayColor, textAlignment: .center, fontType: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var lastValueLabel: UILabel = {
        var label = UILabel()
        label.configure(text: "", fontSize: 14, textColor: .textColor, textAlignment: .left, fontType: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var changePercentLabel: UILabel = {
        var label = UILabel()
        label.configure(text: "", fontSize: 16, textColor: .textColor, textAlignment: .left, fontType: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var likeButton: LoadingButton = {
        var button = LoadingButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(likeButtonPressed), for: .touchUpInside)
        button.indicator = BallPulseSyncIndicator(color: .rejectOrangeColor)
        button.indicator.color = .rejectOrangeColor
        button.bgColor = .clear
        button.autoHideLoader()
        return button
    }()
    
    private lazy var labelStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.alignment = .fill
        stack.axis = .vertical
        stack.spacing = 5
        return stack
    }()
    
    weak var delegate: MarketViewModelProtocol?
    
    //MARK: - INITILIZERS
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .cardsColor
        selectionStyle = .none
        createUI()
        likeButton.hideLoader()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        market = nil
    }
    //MARK: - CREATE UI
    private func createUI() {
        addingContainerView()
        addingChangePercentLabel()
        addingLastValueLabel()
        addingLikeButton()
        addingLabelStack()
    }
    private func addingContainerView() {
        contentView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            containerView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    private func addingChangePercentLabel() {
        containerView.addSubview(changePercentLabel)
        NSLayoutConstraint.activate([
            changePercentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            changePercentLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
    
    private func addingLastValueLabel() {
        containerView.addSubview(lastValueLabel)
        NSLayoutConstraint.activate([
            lastValueLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            lastValueLabel.leadingAnchor.constraint(equalTo: changePercentLabel.trailingAnchor, constant: 60)
        ])
    }
    
    private func addingLikeButton() {
        containerView.addSubview(likeButton)
        NSLayoutConstraint.activate([
            likeButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            likeButton.widthAnchor.constraint(equalToConstant: 15),
            likeButton.heightAnchor.constraint(equalToConstant: 15)
        ])
    }
    private func addingLabelStack() {
        containerView.addSubview(labelStack)
        labelStack.addArrangedSubview(currencySymbolsLabel)
        labelStack.addArrangedSubview(lastVolumeLabel)
        NSLayoutConstraint.activate([
            labelStack.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
            labelStack.trailingAnchor.constraint(equalTo: likeButton.leadingAnchor, constant: -10)
        ])
    }
    
    //MARK: - OBJC FUNCTIONS
    @objc func likeButtonPressed() {
        guard let market = market else { return }
        likeButton.showLoader(userInteraction: false)
//        delegate?.likeMarketHandler(market: market)
        delegate?.likeButtonAction(with: market)
    }
    
    func updateUI() {
        guard let unwrappedMarket = market else { return }
        lastVolumeLabel.text = unwrappedMarket.marketLastVolume
        lastValueLabel.text = unwrappedMarket.lastValueMarket
        currencySymbolsLabel.text = unwrappedMarket.mainMarketSymbol
        changePercentLabel.text = unwrappedMarket.marketDailyChangePercent
        changePercentLabel.textColor = unwrappedMarket.marketDailyChangePercentColor
        likeButton.setImage(UIImage(named: unwrappedMarket.icon), for: .normal)
        likeButton.hideLoader()
    }
}

