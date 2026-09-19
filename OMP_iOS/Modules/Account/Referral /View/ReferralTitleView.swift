//
//  ReferralTitleView.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 11/24/21.
//

import UIKit

class ReferralTitleView: UIView {
    
    private lazy var titleLabel: UILabel = {
       var label = UILabel()
        label.configure(text: title, fontSize: 15, textColor: .textColor, textAlignment: .right, fontType: .regular)
        return label
    }()
    
    private lazy var titleImageView: UIImageView = {
       var imageView = UIImageView()
        imageView.image = UIImage(named: "line")
        return imageView
    }()
    
    //MARK: - INITIALIZER
    private let title: String
    
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - CREATE UI
    private func createUI() {
        addingTitleLabel()
        addingTitleImageView()
    }
    
    private func addingTitleLabel() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    private func addingTitleImageView() {
        addSubview(titleImageView)
        titleImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            titleImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8)
        ])
    }
}
