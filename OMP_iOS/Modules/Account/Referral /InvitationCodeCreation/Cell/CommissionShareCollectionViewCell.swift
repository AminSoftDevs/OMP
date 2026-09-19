//
//  CommissionShareCollectionViewCell.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 11/24/21.
//

import UIKit

class CommissionShareCollectionViewCell: UICollectionViewCell {
    
    lazy var valueLabel: UILabel = {
        var label = UILabel()
        label.configure(text: "", fontSize: 14, textColor: .textColor, textAlignment: .center, fontType: .regular)
        return label
    }()
    
    //MARK: - DEFAULT INIT
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 10
        layer.borderColor = UIColor.textColor.cgColor
        layer.borderWidth = 1.5
        addingMainLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                selectedStyle()
            } else {
                deSelectedStyle()
            }
        }
    }
    
    private func addingMainLabel() {
        contentView.addSubview(valueLabel)
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            valueLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            valueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            valueLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }
    
    func selectedStyle() {
        backgroundColor = .submitGreenColor.withAlphaComponent(0.1)
        valueLabel.textColor = .submitGreenColor
        layer.borderColor = UIColor.submitGreenColor.cgColor
    }
    
    func deSelectedStyle() {
        layer.borderColor = UIColor.textColor.cgColor
        backgroundColor = .clear
        valueLabel.textColor = .textColor
    }
}
