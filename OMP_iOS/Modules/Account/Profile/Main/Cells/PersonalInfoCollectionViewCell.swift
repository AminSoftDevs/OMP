//
//  PersonalInfoCollectionViewCell.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 8/22/21.
//

import UIKit

class PersonalInfoCollectionViewCell: UICollectionViewCell {
    
    var userInfo: UserInfo? {
        didSet {
            self.updateUI()
        }
    }
    
    private lazy var titleLabel: UILabel = {
       var label = UILabel()
        label.configure(text: "PersonalInfoCollectionViewCell.title".localized, fontSize: 16, textColor: .textColor, textAlignment: .center, fontType: .regular)
        return label
    }()
    
    private lazy var titleImageView: UIImageView = {
       var imageView = UIImageView()
        imageView.image = UIImage(named: "line")
        return imageView
    }()
    
    private lazy var mainStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .trailing
        stackView.spacing = 0
        return stackView
    }()
    
    private lazy var firstLabel: UILabel = {
       var label = UILabel()
        label.configure(text: "PersonalInfoCollectionViewCell.name".localized + " :", fontSize: 15, textColor: .textColor, textAlignment: .right, fontType: .regular)
        return label
    }()
    
    private lazy var secondLabel: UILabel = {
       var label = UILabel()
        label.configure(text: "PersonalInfoCollectionViewCell.lastName".localized + " :", fontSize: 15, textColor: .textColor, textAlignment: .right, fontType: .regular)
        return label
    }()
    
    private lazy var thirdLabel: UILabel = {
       var label = UILabel()
        label.configure(text: "PersonalInfoCollectionViewCell.mobile".localized + " :", fontSize: 15, textColor: .textColor, textAlignment: .right, fontType: .regular)
        return label
    }()
    
    //MARK: - DEFAULT INITIALIZER
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .cardsColor
        layer.cornerRadius = 15
        clipsToBounds = true
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - CREATE UI
    private func createUI() {
        addingTitleLabel()
        addingTitleImageView()
        addingMainStackView()
    }
    
    private func addingTitleLabel() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 25),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
        ])
    }
    
    private func addingTitleImageView() {
        addSubview(titleImageView)
        titleImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            titleImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
        ])
    }
    
    private func addingMainStackView() {
        addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: titleImageView.bottomAnchor, constant: 10),
            mainStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainStackView.widthAnchor.constraint(equalTo: widthAnchor, constant: -40),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
        
        mainStackView.addArrangedSubview(firstLabel)
        mainStackView.addArrangedSubview(secondLabel)
        mainStackView.addArrangedSubview(thirdLabel)
        
    }
    
    //MARK: - UPDATE UI
    private func updateUI() {
        guard let item = userInfo else { return }
        firstLabel.text = "PersonalInfoCollectionViewCell.name".localized + " : " + item.firstName
        secondLabel.text = "PersonalInfoCollectionViewCell.lastName".localized + " : " + item.lastName
        thirdLabel.text = "PersonalInfoCollectionViewCell.mobile".localized + " : " + item.userMobile.convertEngNumToPersianNum()
    }
}
