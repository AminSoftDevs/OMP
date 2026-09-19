//
//  MarketNavBarView.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 8/28/21.
//

import UIKit

enum OldMarketType: Int {
    case proMarket = 0
    case mainMarket
    case favorites
    case ompMarket
    case worldMarket
}

enum MarketOriginalParentType {
    case main
    case brief
    case marketGraph
}

class OldMarketNavBarView: UIView {
    
    static let defaultHeight: CGFloat = 70.0
    
    let utility = BaseModule.sharedInstance
    
    var changeTab: OldMarketType = .mainMarket{
        didSet {
            if navBarType == .main {
                self.updateButtonsMainMarketType()
            } else {
                self.updateButtonsBriefType()
            }
        }
    }
    
    private lazy var mainStackView: UIStackView = {
       var stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    var bottomBorder: UIView = UIView()
    
    var buttonTitles: [String] = ["MarketNavBarView.proMarket".localized,"MarketNavBarView.mainMarket".localized,"MarketNavBarView.favorites".localized]
    var buttonTags: [Int] = [0,1,2]
    var buttonsList: [UIButton] = []
    var selectedButton: UIButton!
    
    let navBarType: MarketOriginalParentType
    
    //MARK: - DELEGATE
    weak var delegate: OldMarketDelegate?
    
    //MARK: - INITIALIZER
    init(type: MarketOriginalParentType) {
        self.navBarType = type
        super.init(frame: .zero)
        self.createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - CREATE UI
    fileprivate func createUI() {
        switch navBarType {
        case .main:
            self.mainTypeConfig()
        case .brief:
            self.briefTypeConfig()
        case .marketGraph:
            self.marketGraphConfig()
        }
    }
    
    fileprivate func defaultStyle() {
        self.backgroundColor = .cardsColor
        self.layer.cornerRadius = 20
        self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    //MARK: - MAIN TYPE
    fileprivate func mainTypeConfig() {
        self.defaultStyle()
        self.addingMainStackView(width: 0.7, height: 50)
        self.createButtons(itemCount: 3)
        self.selectedButton = buttonsList[1]
        self.selectButton(selectedButton)
    }
    
    fileprivate func addingMainStackView(width: CGFloat, height: CGFloat) {
        self.addSubview(mainStackView)
        self.mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: mainStackView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: mainStackView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -15).isActive = true
        NSLayoutConstraint(item: mainStackView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: width, constant: 0).isActive = true
        NSLayoutConstraint(item: mainStackView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: height).isActive = true
    }
    
    fileprivate func createButtons(itemCount: Int) {
        for i in 0...itemCount - 1 {
            let button = UIButton()
            button.configure(fontSize: 14, title: buttonTitles[i], fontType: .bold, titleColor: .mediumGray, backgroundColor: .clear, borderColor: .clear)
            button.layer.borderWidth = 0
            button.tag = buttonTags[i]
            button.titleEdgeInsets = .init(top: 4, left: 0, bottom: 0, right: 0)
            button.addTarget(self, action: #selector(categoryButtonPressed), for: .touchUpInside)
            buttonsList.append(button)
            mainStackView.addArrangedSubview(button)
        }
    }
        
    fileprivate func updateButtonsMainMarketType() {
        self.deselectButton(selectedButton)
        switch changeTab {
        case .proMarket:
            selectButton(buttonsList[0])
            selectedButton = buttonsList[0]
        case .mainMarket:
            selectButton(buttonsList[1])
            selectedButton = buttonsList[1]
        case .favorites:
            selectButton(buttonsList[2])
            selectedButton = buttonsList[2]
        case .ompMarket:
            selectButton(buttonsList[0])
            selectedButton = buttonsList[0]
        case .worldMarket:
            selectButton(buttonsList[1])
            selectedButton = buttonsList[1]
        }
    }
    
    //MARK: - BRIEF TYPE
    fileprivate func briefTypeConfig() {
        self.defaultStyle()
        self.addingStackViewCenter(width: 0.4, height: 30)
        self.buttonTitles = ["MarketNavBarView.mainMarket".localized, "MarketNavBarView.proMarket".localized]
        self.buttonTags = [1,0]
        self.createButtons(itemCount: buttonTitles.count)
        self.buttonsBriefConfig()
        self.selectedButton = buttonsList[0]
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.selectButton(self.selectedButton)
        }
    }
    //MARK: - MARKET GRAPH
    fileprivate func marketGraphConfig() {
        self.defaultStyle()
        self.mainStackView.distribution = .fillProportionally
        self.addingStackViewCenter(width: 0.6, height: 30)
        self.buttonTitles = ["MarketNavBarView.ompFinex".localized, "MarketNavBarView.worldWide".localized]
        self.buttonTags = [3,4]
        self.createButtons(itemCount: buttonTitles.count)
        self.buttonsBriefConfig()
        self.selectedButton = buttonsList[0]
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.selectButton(self.selectedButton)
        }
    }
    
    fileprivate func addingStackViewCenter(width: CGFloat, height: CGFloat) {
        self.addSubview(mainStackView)
        self.mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: mainStackView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: mainStackView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: mainStackView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: mainStackView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: height).isActive = true
    }
    
    
    //MARK: - FUNCTIONS
    fileprivate func selectButton(_ button: UIButton) {
        switch navBarType {
        case .main:
            button.setTitleColor(.white, for: .normal)
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.submitButtonColor.cgColor
            button.backgroundColor = .submitButtonColor.withAlphaComponent(0.1)
        case .brief, .marketGraph:
            button.setTitleColor(.white, for: .normal)
            addBottomBorder(button: button)
        }
    }
    
    fileprivate func deselectButton(_ button: UIButton) {
        switch navBarType {
        case .main:
            button.setTitleColor(.mediumGray, for: .normal)
            button.layer.borderWidth = 0
            button.backgroundColor = .clear
        case .brief, .marketGraph:
            button.setTitleColor(.mediumGray, for: .normal)
            bottomBorder.removeFromSuperview()
        }
    }
    
    fileprivate func addBottomBorder(button: UIButton) {
        bottomBorder.backgroundColor = .submitButtonColor
        button.addSubview(bottomBorder)
        bottomBorder.frame = CGRect(x: (button.frame.width / 2) - (button.frame.width * 0.5 / 2), y:  button.frame.height - 1, width: button.frame.width * 0.5, height: 1)
    }
    
    fileprivate func buttonsBriefConfig() {
        for item in buttonsList {
            item.titleLabel?.font = UIFont(type: .regular, fontSize: 11)
        }
    }
    
    fileprivate func updateButtonsBriefType() {
        self.deselectButton(selectedButton)
        switch changeTab {
        case .proMarket:
            selectButton(buttonsList[1])
            selectedButton = buttonsList[1]
        case .mainMarket:
            selectButton(buttonsList[0])
            selectedButton = buttonsList[0]
        case .favorites:
            print("there isn't in this mode")
        case .ompMarket:
            selectButton(buttonsList[0])
            selectedButton = buttonsList[0]
        case .worldMarket:
            selectButton(buttonsList[1])
            selectedButton = buttonsList[1]
        }
    }
    
    //MARK: - OBJC FUNCTIONS
    @objc func categoryButtonPressed(_ sender: UIButton) {
        if sender != selectedButton {
            delegate?.selectedNavItem(type: OldMarketType.init(rawValue: sender.tag)!)
            deselectButton(selectedButton)
            selectButton(sender)
            selectedButton = sender
        }
    }
}
