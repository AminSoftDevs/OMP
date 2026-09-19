//
//  BaseNavigationBarView.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 8/20/21.
//

import UIKit

protocol BaseNavigationBarDelegate: AnyObject {
    func backButtonPressed()
    func landscapeButtonPressed(portrait: Bool)
}

extension BaseNavigationBarDelegate  {
    func landscapeButtonPressed(portrait: Bool) {}
}

enum NavigationBarType {
    case defaultMode
    case marketBrief
    case marketGraph
    case walletMainScreen
}

class BaseNavigationBarView: UIView {
    
    static let defaultHeight: CGFloat = 70.0
    
    var currentScreenOrientationIsPortrait: Bool = true {
        didSet {
            if currentScreenOrientationIsPortrait == false {
                landscapeButton.isSelected = true
            } else  {
                landscapeButton.isSelected = false
            }
        }
    }
    private lazy var titleLabel: UILabel = {
       var label = UILabel()
        label.configure(text: "", fontSize: Constants.navFontSize , textColor: .textColor, textAlignment: .center, fontType: .regular)
        return label
    }()
    
    private lazy var backButton: UIButton = {
       var button = UIButton()
        button.setImage(UIImage(named: "back_arrow_icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .textColor
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 0.8
        button.layer.borderColor = UIColor.mediumGrayColor.cgColor
        button.imageView?.transform = dir == .leftToRight ? CGAffineTransform(scaleX: -1, y: 1) : CGAffineTransform(scaleX: 1, y: 1)
        return button
    }()
    
    private lazy var landscapeButton: UIButton = {
       var button = UIButton()
        button.setImage(UIImage(named: "to_ fullScree_icon"), for: .normal)
        button.setImage(UIImage(named: "from_landscape_icon"), for: .selected)
        button.addTarget(self, action: #selector(landscapeButtonPressed), for: .touchUpInside)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 0.8
        button.layer.borderColor = UIColor.mediumGrayColor.cgColor
        button.imageView?.layer.transform = CATransform3DMakeScale(0.7, 0.7, 0.7)
        return button
    }()
    
    let dir = Localization.sharedInstance.getlanguageDirection()
    
    let navigationBarType: NavigationBarType
    let navTitle: String
    
    //MARK: - DELEGATE
    weak var delegate: BaseNavigationBarDelegate?
    
    //MARK: - INITIALIZER
    init(navigationType: NavigationBarType, title: String) {
        self.navigationBarType = navigationType
        self.navTitle = title
        super.init(frame: .zero)
        self.createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - CREATE UI
    fileprivate func createUI() {
        switch navigationBarType {
        case .defaultMode:
            createDefaultNavigationBar()
        case .marketBrief:
            createMarketBriefNavigationBar()
        case .marketGraph:
            createMarketGraphNavigationBar()
        case .walletMainScreen:
            createWalletMainScreenNavBar()
        }
    }
    
    //MARK: - DEFAULT MODE
    fileprivate func createDefaultNavigationBar() {
        self.defaultModeViewStyle()
        self.addingBackButton()
        self.addingTitleLabel()
    }
    
    fileprivate func defaultModeViewStyle() {
        self.backgroundColor = .cardsColor
        self.layer.cornerRadius = 15
        self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    fileprivate func addingBackButton() {
        self.addSubview(backButton)
        self.backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            backButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            backButton.widthAnchor.constraint(equalToConstant: 35),
            backButton.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    fileprivate func addingTitleLabel() {
        self.addSubview(titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor, constant: 4)
        ])
        self.titleLabel.text = self.navTitle
    }
    
    //MARK: - MARKET BRIEF
    fileprivate func createMarketBriefNavigationBar() {
        self.MarketBriefStyle()
        self.addingBackButton()
        self.addingTitleLabel()
    }
    
    fileprivate func MarketBriefStyle() {
        self.backgroundColor = .cardsColor
    }
    
    //MARK: - MARKET GRAPH
    fileprivate func createMarketGraphNavigationBar() {
        self.MarketBriefStyle()
        self.addingBackButton()
        self.addingTitleLabel()
        self.addingLandscapeButtonPressed()
    }
    
    fileprivate func addingLandscapeButtonPressed() {
        self.addSubview(landscapeButton)
        self.landscapeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            landscapeButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            landscapeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            landscapeButton.widthAnchor.constraint(equalToConstant: 30),
            landscapeButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    fileprivate func MarketGraphStyle() {
        self.backgroundColor = .cardsColor
    }
    
    //MARK: - WalletMainScreenNavBar Config
    fileprivate func createWalletMainScreenNavBar() {
        self.walletMainScreenModeStyle()
        self.addingWalletMainScreenTitle()
    }
    
    fileprivate func walletMainScreenModeStyle() {
        self.backgroundColor = .cardsColor
    }
    
    fileprivate func addingWalletMainScreenTitle() {
        self.addSubview(titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        self.titleLabel.text = self.navTitle
    }
    
    //MARK: - OBJC FUNCTIONS
    @objc func backButtonPressed() {
        self.delegate?.backButtonPressed()
    }
    
    @objc func landscapeButtonPressed() {
        landscapeButton.isSelected = !landscapeButton.isSelected
        self.delegate?.landscapeButtonPressed(portrait: !landscapeButton.isSelected)
    }
}
