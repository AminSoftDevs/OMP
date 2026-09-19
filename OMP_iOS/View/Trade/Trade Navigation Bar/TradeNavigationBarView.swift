//
//  TradeNavigationBarView.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 8/31/21.
//

import UIKit

protocol TradeNavigationBarDelegate: AnyObject {
    func actionHappened(with action: TradeNavButtonsAction )
}

enum TradeNavButtonsAction {
    case symbols
    case graph
    case orderHistory
    case buy
    case sell
}

class TradeNavigationBarView: UIView {
    
    var setDefaultButton: Bool = false {
        didSet {
            if selectedButton == buttonsList[0] {
                categoryButtonPressed(buttonsList[1])
            }
        }
    }
    
    var setActionType: OrdersType = .buy {
        didSet {
            if setActionType == .sell {
                categoryButtonPressed(buttonsList[0])
            } else {
                categoryButtonPressed(buttonsList[1])
            }
        }
    }
    
    var headerTitle: String = "" {
        didSet {
            self.headerButton.setTitle(headerTitle, for: .normal)
        }
    }
    
    let utility = BaseModule.sharedInstance
    
    private lazy var titleLabel: UILabel = {
       var label = UILabel()
        label.configure(text: "", fontSize: Constants.navFontSize , textColor: .textColor, textAlignment: .center, fontType: .regular)
        return label
    }()
    
    lazy var headerButton: UIButton = {
       var button = UIButton()
        button.setTitle(DefaultCoin.name, for: .normal)
        button.titleLabel?.font = UIFont(type: .regular, fontSize: 18)
        button.setTitleColor(.textColor, for: .normal)
        button.setImage(UIImage(named: "arrow_down_icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.titleEdgeInsets = .init(top: 0, left: -20, bottom: 0, right: 20)
        button.addTarget(self, action: #selector(headerButtonPressed), for: .touchUpInside)
        button.tintColor = .textColor
        button.semanticContentAttribute = .forceRightToLeft
        return button
    }()
    
    private lazy var marketGraphButton: UIButton = {
       var button = UIButton()
        button.setImage(UIImage(named: "market_icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(marketGraphButtonPressed), for: .touchUpInside)
        button.imageEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
        button.tintColor = .textColor
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.textColor.cgColor
        button.layer.cornerRadius = 10
        return button
    }()
    
    private lazy var ordersHistoryButton: UIButton = {
       var button = UIButton()
        button.configure(fontSize: 13, title: "TradeNavigationBarView.ordersHistoryButton".localized, fontType: .regular, titleColor: .mediumGrayColor, backgroundColor: .clear, borderColor: .clear, cornerRadius: 0)
        button.setImage(UIImage(named: "history_icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.layer.transform = CATransform3DMakeScale(0.7, 0.7, 0.7)
        button.titleEdgeInsets = .init(top: 2, left: -7, bottom: -2, right: 7)
        button.tintColor = .textColor
        button.semanticContentAttribute = .forceRightToLeft
        button.addTarget(self, action: #selector(ordersHistoryButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var mainStackView: UIStackView = {
       var stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    var bottomBorder: UIView = UIView()
    var buttonTitles: [String] = []
    var buttonsList: [UIButton] = []
    var selectedButton: UIButton!
        
    //MARK: - DELEGATE
    weak var delegate: TradeNavigationBarDelegate?
    
    //MARK: - INITIALIZER
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - CREATE UI
    fileprivate func createUI() {
        self.defaultModeViewStyle()
        self.addingHeaderButton()
        self.addingMarketGraphButton()
        self.addingOrdersHistoryButton()
        self.addingMainStackView()
    }
    
    //MARK: - DEFAULT MODE
    fileprivate func defaultModeViewStyle() {
        self.backgroundColor = .cardsColor
        self.layer.cornerRadius = 15
        self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    fileprivate func addingHeaderButton() {
        self.addSubview(headerButton)
        self.headerButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: headerButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 0.7, constant: 0).isActive = true
        NSLayoutConstraint(item: headerButton, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: headerButton, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0, constant: 150).isActive = true
        NSLayoutConstraint(item: headerButton, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 30).isActive = true
    }
    
    fileprivate func addingMarketGraphButton() {
        self.addSubview(marketGraphButton)
        self.marketGraphButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: marketGraphButton, attribute: .centerY, relatedBy: .equal, toItem: headerButton, attribute: .centerY, multiplier: 1, constant: -6).isActive = true
        NSLayoutConstraint(item: marketGraphButton, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -30).isActive = true
        NSLayoutConstraint(item: marketGraphButton, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0, constant: 35).isActive = true
        NSLayoutConstraint(item: marketGraphButton, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 35).isActive = true
    }
    
    fileprivate func addingOrdersHistoryButton() {
        self.addSubview(ordersHistoryButton)
        self.ordersHistoryButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: ordersHistoryButton, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 30).isActive = true
        NSLayoutConstraint(item: ordersHistoryButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.5, constant: 0).isActive = true
        NSLayoutConstraint(item: ordersHistoryButton, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.4, constant: 0).isActive = true
    }
    
    fileprivate func addingMainStackView() {
        self.addSubview(mainStackView)
        self.mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: mainStackView, attribute: .centerY, relatedBy: .equal, toItem: ordersHistoryButton, attribute: .centerY, multiplier: 1, constant: -8).isActive  = true
        NSLayoutConstraint(item: mainStackView, attribute: .leading, relatedBy: .equal, toItem: ordersHistoryButton, attribute: .trailing, multiplier: 1, constant: 50).isActive  = true
        NSLayoutConstraint(item: mainStackView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -30).isActive  = true
        NSLayoutConstraint(item: mainStackView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 30).isActive  = true
        
        self.buttonTitles = ["sell".localized, "buy".localized]
        self.createButtons()
        self.selectedButton = buttonsList.last
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.selectButton(self.selectedButton)
        }
    }
    
    fileprivate func createButtons() {
        for i in 0...buttonTitles.count - 1 {
            let button = UIButton()
            button.configure(fontSize: 13, title: buttonTitles[i], fontType: .bold, titleColor: .mediumGrayColor, backgroundColor: .clear, borderColor: .clear)
            button.layer.borderWidth = 0
            button.tag = i
            button.titleEdgeInsets = .init(top: 4, left: 0, bottom: 0, right: 0)
            button.addTarget(self, action: #selector(categoryButtonPressed), for: .touchUpInside)
            buttonsList.append(button)
            mainStackView.addArrangedSubview(button)
        }
    }
    
    fileprivate func selectButton(_ button: UIButton) {
        button.setTitleColor(.textColor, for: .normal)
        addBottomBorder(button: button)
    }
    
    fileprivate func deselectButton(_ button: UIButton) {
        button.setTitleColor(.mediumGrayColor, for: .normal)
        bottomBorder.removeFromSuperview()
    }
    
    fileprivate func addBottomBorder(button: UIButton) {
        bottomBorder.backgroundColor = .submitButtonColor
        button.addSubview(bottomBorder)
        bottomBorder.frame = CGRect(x: (button.frame.width / 2) - (button.frame.width * 0.5 / 2), y:  button.frame.height - 1, width: button.frame.width * 0.5, height: 1)
    }
    
    //MARK: - OBJC FUNCTIONS
    @objc func categoryButtonPressed(_ sender: UIButton) {
        if sender == selectedButton {
            return
        }
        deselectButton(selectedButton)
        selectButton(sender)
        selectedButton = sender
        if sender.tag == 0 {
            delegate?.actionHappened(with: .sell)
        } else {
            delegate?.actionHappened(with: .buy)
        }
    }
    
    @objc func headerButtonPressed() {
        delegate?.actionHappened(with: .symbols)
    }
    
    @objc func marketGraphButtonPressed() {
        delegate?.actionHappened(with: .graph)
    }
    
    @objc func ordersHistoryButtonPressed() {
        delegate?.actionHappened(with: .orderHistory)
    }
}
