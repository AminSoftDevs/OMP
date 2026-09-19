//
//  ReferralStatsView.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 11/25/21.
//

import UIKit

class ReferralStatsView: UIView {
    
    private lazy var totalBenefitsStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 0
        return stackView
    }()
    
    private lazy var totalBenefitsTitleLabel: UILabel = {
        var label = UILabel()
        label.configure(text: "ReferralStatsView.totalBenefitsTitle".localized, fontSize: 14, textColor: .mediumGrayColor, textAlignment: .center, fontType: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var totalBenefitsValueLabel: UILabel = {
        var label = UILabel()
        label.configure(text: "-", fontSize: 15, textColor: .textColor, textAlignment: .center, fontType: .regular)
        return label
    }()
    
    private lazy var numberOfFriendsStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 0
        return stackView
    }()
    
    private lazy var numberOfFriendsTitleLabel: UILabel = {
        var label = UILabel()
        label.configure(text: "ReferralStatsView.numberOfFriendsTitle".localized, fontSize: 14, textColor: .mediumGrayColor, textAlignment: .center, fontType: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var numberOfFriendsValueLabel: UILabel = {
        var label = UILabel()
        label.configure(text: "-", fontSize: 15, textColor: .textColor, textAlignment: .center, fontType: .regular)
        return label
    }()
    
    private lazy var verticalSeparatorView: UIView = {
       var view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    lazy var usersStatisticsTitleView: ReferralTitleView = ReferralTitleView(title: "ReferralViewController.usersStatisticsTitleView".localized)
    
    //MARK: - DEFAULT INITIALIZER
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .cardsColor
        layer.cornerRadius = 20
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - CREATE UI
    private func createUI() {
        addingUsersStatisticsTitleView()
        addingTotalBenefitsStackView()
        addingNumberOfFriendsStackView()
        addingVerticalSeparatorView()
    }
    
    private func addingUsersStatisticsTitleView() {
        addSubview(usersStatisticsTitleView)
        usersStatisticsTitleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            usersStatisticsTitleView.topAnchor.constraint(equalTo: topAnchor , constant: 15),
            usersStatisticsTitleView.leadingAnchor.constraint(equalTo: leadingAnchor , constant: 20),
            usersStatisticsTitleView.trailingAnchor.constraint(equalTo: trailingAnchor , constant: -20),
            usersStatisticsTitleView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func addingTotalBenefitsStackView() {
        addSubview(totalBenefitsStackView)
        totalBenefitsStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            totalBenefitsStackView.topAnchor.constraint(equalTo: usersStatisticsTitleView.bottomAnchor , constant: 5),
            totalBenefitsStackView.leadingAnchor.constraint(equalTo: leadingAnchor , constant: 20),
            totalBenefitsStackView.widthAnchor.constraint(equalTo: widthAnchor , multiplier: 0.4),
            totalBenefitsStackView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        totalBenefitsStackView.addArrangedSubview(totalBenefitsTitleLabel)
        totalBenefitsStackView.addArrangedSubview(totalBenefitsValueLabel)
    }
    
    private func addingNumberOfFriendsStackView() {
        addSubview(numberOfFriendsStackView)
        numberOfFriendsStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            numberOfFriendsStackView.topAnchor.constraint(equalTo: usersStatisticsTitleView.bottomAnchor , constant: 5),
            numberOfFriendsStackView.trailingAnchor.constraint(equalTo: trailingAnchor , constant: -20),
            numberOfFriendsStackView.widthAnchor.constraint(equalTo: totalBenefitsStackView.widthAnchor),
            numberOfFriendsStackView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        numberOfFriendsStackView.addArrangedSubview(numberOfFriendsTitleLabel)
        numberOfFriendsStackView.addArrangedSubview(numberOfFriendsValueLabel)
    }
    
    private func addingVerticalSeparatorView() {
        addSubview(verticalSeparatorView)
        verticalSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            verticalSeparatorView.centerYAnchor.constraint(equalTo: numberOfFriendsStackView.centerYAnchor),
            verticalSeparatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            verticalSeparatorView.widthAnchor.constraint(equalToConstant: 1),
            verticalSeparatorView.heightAnchor.constraint(equalTo: numberOfFriendsStackView.heightAnchor, multiplier: 0.5)
        ])
    }
    //MARK: - UPDATE VALUES FUNCTIONS
    func updateValues(numberOfFriends: String, totalBenefits: String) {
        numberOfFriendsValueLabel.text = numberOfFriends
        totalBenefitsValueLabel.text = totalBenefits
    }
    
}
