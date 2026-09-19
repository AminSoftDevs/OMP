//
//  TransactionButton.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 9/25/21.
//

import UIKit

class TransactionButton: UIButton {

    let type: TransactionType
    let title: String
    
    init(type: TransactionType, title: String) {
        self.type = type
        self.title = title
        super.init(frame: .zero)
        self.defaultStyle()
        self.createButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func createButton() {
        switch type {
        case .withdraw:
            self.createWithdrawButton()
        case .deposit:
            self.createDepositButton()
        default:
            break
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = layer.bounds.height / 2
    }
    
    fileprivate func defaultStyle() {
        layer.borderWidth = 1
        setTitle(title, for: .normal)
        imageView?.layer.transform = CATransform3DMakeScale(0.65, 0.65, 0.65)
        if Localization.sharedInstance.getlanguageDirection() == .leftToRight {
            semanticContentAttribute = .forceRightToLeft
            setInsets(forContentPadding: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: -8), imageTitlePadding: -20)
        } else {
            semanticContentAttribute = .forceLeftToRight
            setInsets(forContentPadding: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: -8), imageTitlePadding: 5)
        }
    }
    
    fileprivate func createWithdrawButton() {
        backgroundColor = .rejectOrangeColor.withAlphaComponent(0.12)
        setTitleColor(.rejectOrangeColor, for: .normal)
        layer.borderColor = UIColor.rejectOrangeColor.cgColor
        setImage(UIImage(named: "withdraw_icon"), for: .normal)
        imageEdgeInsets = .init(top: 0, left: -20, bottom: 0, right: 20)
    }
    
    fileprivate func createDepositButton() {
        backgroundColor = .submitGreenColor.withAlphaComponent(0.12)
        setTitleColor(.submitGreenColor, for: .normal)
        layer.borderColor = UIColor.submitGreenColor.cgColor
        setImage(UIImage(named: "deposit_icon"), for: .normal)
        imageEdgeInsets = .init(top: 0, left: -20, bottom: 0, right: 20)
    }
}



