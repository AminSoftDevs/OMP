//
//  MarketHeaderView.swift
//  OMP_iOS
//
//  Created by AminSoft on 8/17/1400 AP.
//

import UIKit

class MarketHeaderView: UIView {
    
    private lazy var dailyChangeTitleLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configure(text: "MarketCollectionView.dailyChange".localized, fontSize: 13, textColor: .textColor, textAlignment: .center, fontType: .regular)
        return label
    }()
    
    private lazy var lastPriceTitleLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configure(text: "MarketCollectionView.lastPrice".localized, fontSize: 13, textColor: .textColor, textAlignment: .center, fontType: .regular)
        return label
    }()
    
    private lazy var volumeTitleLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configure(text: "MarketCollectionView.volume".localized, fontSize: 13, textColor: .textColor, textAlignment: .center, fontType: .regular)
        return label
    }()
    
    private lazy var separatorImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "line")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .cardsColor
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //    MARK: -CREATE UI
    private func createUI() {
        addingDailyChangeTitleLabel()
        addingLastPriceTitleLabel()
        addingVolumeTitleLabel()
        addingSeparatorImageView()
    }
    private func addingDailyChangeTitleLabel() {
        addSubview(dailyChangeTitleLabel)
        NSLayoutConstraint.activate([
            dailyChangeTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            dailyChangeTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        ])
    }
    private func addingLastPriceTitleLabel() {
        addSubview(lastPriceTitleLabel)
        NSLayoutConstraint.activate([
            lastPriceTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            lastPriceTitleLabel.leadingAnchor.constraint(equalTo: dailyChangeTitleLabel.trailingAnchor, constant: 45)
        ])
    }
    private func addingVolumeTitleLabel() {
        addSubview(volumeTitleLabel)
        NSLayoutConstraint.activate([
            volumeTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            volumeTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30)
        ])
    }
    private func addingSeparatorImageView() {
        addSubview(separatorImageView)
        NSLayoutConstraint.activate([
            separatorImageView.topAnchor.constraint(equalTo: volumeTitleLabel.bottomAnchor, constant: 10),
            separatorImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            separatorImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6),
            separatorImageView.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
}
