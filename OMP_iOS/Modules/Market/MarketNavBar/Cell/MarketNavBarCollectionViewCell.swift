//
//  MarketNavBarCollectionViewCell.swift
//  OMP_iOS
//
//  Created by AminSoft on 8/18/1400 AP.
//

import UIKit

class MarketNavBarCollectionViewCell: UICollectionViewCell {
    
    //MARK: - PROPERTIES
    lazy var changeMarketLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configure(text: "", fontSize: 14, textColor: .textColor, textAlignment: .center, fontType: .regular)
        label.sizeToFit()
        return label
    }()
    
    //MARK: - INITLIZERS
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        layer.borderColor = UIColor.clear.cgColor
        layer.borderWidth = 0
        backgroundColor = .clear
    }
    
    //MARK: - CREATEUI
    private func createUI() {
        addingChangeMarketButton()
    }
    private func addingChangeMarketButton() {
        contentView.addSubview(changeMarketLabel)
        NSLayoutConstraint.activate([
            changeMarketLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            changeMarketLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}
