//
//  IdentityVerificationNavBar.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 8/7/21.
//

import UIKit
import StepIndicator

protocol IdentityVerificationNavBarDelegate: AnyObject {
    func backButtonPressed()
}

class IdentityVerificationNavBar: UIView {
    
    var step: Int = 0 {
        didSet {
            self.progressControlCollectionView.currentStep = step
        }
    }
    var navigationTitle: String {
        get {
           return _titleLabelString
        }
        set {
            self._titleLabelString = newValue
        }
    }
    
    fileprivate var _titleLabelString: String = "" {
        didSet {
            self.titleLabel.text = _titleLabelString
        }
    }
    
    var navigationMainTitle: String {
        get {
           return _navigationMainTitle
        }
        set {
            self._navigationMainTitle = newValue
        }
    }
    
    fileprivate var _navigationMainTitle: String = "" {
        didSet {
            self.mainTitleLabel.text = _navigationMainTitle
        }
    }
    
    private lazy var mainTitleLabel: UILabel = {
       var label = UILabel()
        label.configure(text: "", fontSize: 16, textColor: .textColor, textAlignment: .center, fontType: .bold)
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
       var label = UILabel()
        label.configure(text: "", fontSize: 14, textColor: .submitButtonColor, textAlignment: .center, fontType: .bold)
        return label
    }()
    
    private lazy var backButton: UIButton = {
       var button = UIButton()
        button.setImage(UIImage(named: "back_arrow_icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .textColor
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.mediumGrayColor.cgColor
        button.imageView?.transform = dir == .leftToRight ? CGAffineTransform(scaleX: -1, y: 1) : CGAffineTransform(scaleX: 1, y: 1)
        return button
    }()
    
    let progressControlCollectionView: StepIndicatorView = {
       let view = StepIndicatorView()
        view.numberOfSteps = 5
        view.currentStep = 0
        view.circleColor = .submitButtonColor
        view.circleTintColor = .submitButtonColor
        view.circleStrokeWidth = 2.0
        view.circleRadius = 18.0
        view.lineColor = .lightGray
        view.lineTintColor = .submitButtonColor
        view.lineMargin = 6.0
        view.lineStrokeWidth = 3
        view.displayNumbers = false
        view.direction = .rightToLeft
        return view
    }()
    
    let dir = Localization.sharedInstance.getlanguageDirection()
    
    //MARK: - DEFAULT INIT
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .cardsColor
        self.layer.cornerRadius = 15
        self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        self.createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var delegate: IdentityVerificationNavBarDelegate?
    
    //MARK: - CREATE UI
    fileprivate func createUI() {
        self.addingBackButton()
        self.addingMainTitleLabel()
        self.addingProgressControllerView()
        self.addingTitleLabel()
    }
    
    fileprivate func addingBackButton() {
        self.addSubview(backButton)
        self.backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: backButton, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: backButton, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: backButton, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0, constant: 35).isActive = true
        NSLayoutConstraint(item: backButton, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 35).isActive = true
    }
    
    fileprivate func addingMainTitleLabel() {
        self.addSubview(mainTitleLabel)
        self.mainTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: mainTitleLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: mainTitleLabel, attribute: .centerY, relatedBy: .equal, toItem: self.backButton, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
    }
    
    fileprivate func addingProgressControllerView() {
        self.addSubview(progressControlCollectionView)
        self.progressControlCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: progressControlCollectionView, attribute: .top, relatedBy: .equal, toItem: backButton, attribute: .bottom, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: progressControlCollectionView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: progressControlCollectionView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: progressControlCollectionView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 40).isActive = true
    }
    
    fileprivate func addingTitleLabel() {
        self.addSubview(titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: progressControlCollectionView, attribute: .bottom, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    }
    
    //MARK: - OBJC FUNCTIONS
    @objc func backButtonPressed() {
        self.delegate?.backButtonPressed()
    }
}
