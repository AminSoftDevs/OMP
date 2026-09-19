//
//  MarketNavBarView.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 8/28/21.
//

import UIKit

enum MarketsType: Int {
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

class SecondaryMarketNavBarView: UIView {
    
    static let defaultHeight: CGFloat = 70.0
    
    let utility = BaseModule.sharedInstance
    
    var changeTab: MarketsType = .mainMarket{
        didSet {
            if navBarType == .main {
                updateButtonsMainMarketType()
            } else {
                updateButtonsBriefType()
            }
        }
    }
    
    var selectedTag: Int = 0 {
        didSet {
            deselectButton(selectedButton)
            selectButton(buttonsList[selectedTag])
            selectedButton = buttonsList[selectedTag]
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
    weak var delegate: MarketDelegate?
    
    //MARK: - INITIALIZER
    init(type: MarketOriginalParentType) {
        self.navBarType = type
        super.init(frame: .zero)
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - CREATE UI
    private func createUI() {
        switch navBarType {
        case .main:
            mainTypeConfig()
        case .brief:
            briefTypeConfig()
        case .marketGraph:
            marketGraphConfig()
        }
    }
    
    private func defaultStyle() {
        backgroundColor = .cardsColor
        layer.cornerRadius = 20
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    //MARK: - MAIN TYPE
    private func mainTypeConfig() {
        defaultStyle()
        addingMainStackView(width: 0.7, height: 50)
        createButtons(itemCount: 3)
        selectedButton = buttonsList[1]
        selectButton(selectedButton)
    }
    
    private func addingMainStackView(width: CGFloat, height: CGFloat) {
        addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            mainStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            mainStackView.heightAnchor.constraint(equalToConstant: height),
        ])
    }
    
    private func createButtons(itemCount: Int) {
        for i in 0...itemCount - 1 {
            let button = UIButton()
            button.configure(fontSize: 14, title: buttonTitles[i], fontType: .bold, titleColor: .mediumGrayColor, backgroundColor: .clear, borderColor: .clear)
            button.layer.borderWidth = 0
            button.tag = buttonTags[i]
            button.titleEdgeInsets = .init(top: 4, left: 0, bottom: 0, right: 0)
            button.addTarget(self, action: #selector(categoryButtonPressed), for: .touchUpInside)
            buttonsList.append(button)
            mainStackView.addArrangedSubview(button)
        }
    }
        
    private func updateButtonsMainMarketType() {
        deselectButton(selectedButton)
        switch changeTab {
        case .proMarket, .ompMarket:
            selectButton(buttonsList[0])
            selectedButton = buttonsList[0]
        case .mainMarket, .worldMarket:
            selectButton(buttonsList[1])
            selectedButton = buttonsList[1]
        case .favorites:
            selectButton(buttonsList[2])
            selectedButton = buttonsList[2]
        }
    }
    
    //MARK: - BRIEF TYPE
    private func briefTypeConfig() {
        defaultStyle()
        addingStackViewCenter(width: 0.4, height: 30)
        buttonTitles = ["MarketNavBarView.mainMarket".localized, "MarketNavBarView.proMarket".localized]
        buttonTags = [0,1]
        createButtons(itemCount: buttonTitles.count)
        buttonsBriefConfig()
        selectedButton = buttonsList[0]
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.selectButton(self.selectedButton)
        }
    }
    //MARK: - MARKET GRAPH
    private func marketGraphConfig() {
        defaultStyle()
        mainStackView.distribution = .fillProportionally
        addingStackViewCenter(width: 0.6, height: 30)
        buttonTitles = ["MarketNavBarView.worldWide".localized, "MarketNavBarView.ompFinex".localized]
        buttonTags = [4,3]
        createButtons(itemCount: buttonTitles.count)
        buttonsBriefConfig()
        selectedButton = buttonsList[1]
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.selectButton(self.selectedButton)
        }
    }
    
    private func addingStackViewCenter(width: CGFloat, height: CGFloat) {
        addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            mainStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            mainStackView.widthAnchor.constraint(equalTo: self.widthAnchor),
            mainStackView.heightAnchor.constraint(equalToConstant: height),
        ])
    }
    
    
    //MARK: - FUNCTIONS
    private func selectButton(_ button: UIButton) {
        switch navBarType {
        case .main:
            button.setTitleColor(.textColor, for: .normal)
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.submitButtonColor.cgColor
            button.backgroundColor = .submitButtonColor.withAlphaComponent(0.1)
        case .brief, .marketGraph:
            button.setTitleColor(.textColor, for: .normal)
            addBottomBorder(button: button)
        }
    }
    
    private func deselectButton(_ button: UIButton) {
        switch navBarType {
        case .main:
            button.setTitleColor(.mediumGrayColor, for: .normal)
            button.layer.borderWidth = 0
            button.backgroundColor = .clear
        case .brief, .marketGraph:
            button.setTitleColor(.mediumGrayColor, for: .normal)
            bottomBorder.removeFromSuperview()
        }
    }
    
    private func addBottomBorder(button: UIButton) {
        bottomBorder.backgroundColor = .submitButtonColor
        button.addSubview(bottomBorder)
        bottomBorder.frame = CGRect(x: (button.frame.width / 2) - (button.frame.width * 0.5 / 2), y:  button.frame.height - 1, width: button.frame.width * 0.5, height: 1)
    }
    
    private func buttonsBriefConfig() {
        for item in buttonsList {
            item.titleLabel?.font = UIFont(type: .regular, fontSize: 11)
        }
    }
    
    private func updateButtonsBriefType() {
        deselectButton(selectedButton)
        switch changeTab {
        case .proMarket, .ompMarket:
            selectButton(buttonsList[1])
            selectedButton = buttonsList[1]
        case .mainMarket, .worldMarket:
            selectButton(buttonsList[0])
            selectedButton = buttonsList[0]
        case .favorites:
            print("there isn't in this mode")
        }
    }
    
    //MARK: - OBJC FUNCTIONS
    @objc func categoryButtonPressed(_ sender: UIButton) {
        if sender != selectedButton {
            delegate?.selectedTabTag(tag: sender.tag)
            delegate?.selectedNavItem(type: MarketsType.init(rawValue: sender.tag)!)
            deselectButton(selectedButton)
            selectButton(sender)
            selectedButton = sender
        }
    }
}
