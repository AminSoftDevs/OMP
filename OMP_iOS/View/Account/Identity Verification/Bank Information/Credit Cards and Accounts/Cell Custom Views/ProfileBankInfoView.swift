//
//  ProfileBankInfoView.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 8/24/21.
//

import UIKit
import MHLoadingButton

class ProfileBankInfoView: UIView {
    
    var bankInfoViewModel: BankInfoAdapter? {
        didSet {
            self.updateUI()
        }
    }
    
    lazy var infoLabel: UILabel = {
       var label = UILabel()
        label.configure(text: "", fontSize: 15, textColor: .textColor, textAlignment: .center, fontType: .regular)
        label.numberOfLines = 2
        return label
    }()
    
    lazy var acceptStateLabel: UILabel = {
       var label = UILabel()
        label.configure(text: "", fontSize: 12, textColor: .submitButtonColor, textAlignment: .right, fontType: .bold)
        return label
    }()
    
    lazy var deleteButton: LoadingButton = {
       var button = LoadingButton()
        button.setImage(UIImage(named: "delete_icon"), for: .normal)
        button.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        button.indicator = BallPulseSyncIndicator(color: .rejectOrangeColor)
        button.indicator.color = .rejectOrangeColor
        button.bgColor = .clear
        return button
    }()
    
    lazy var ownerLabel: UILabel = {
       var label = UILabel()
        label.configure(text: "", fontSize: 15, textColor: .textColor, textAlignment: .center, fontType: .regular)
        return label
    }()
    
    let type: BankInformationType
    weak var delegate: BankInfoDelegate?
    
    //MARK: - DEAULT INITIALIZER
    init(type: BankInformationType) {
        self.type = type
        super.init(frame: .zero)
        self.backgroundColor = .backgroundColor
        self.layer.cornerRadius = 15
        self.createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - CREATE UI
    fileprivate func createUI() {
        self.addingDeleteButton()
        self.addingAcceptStateLabel()
        
        if type == .profileCredit {
            self.addingInfoLabel()
            self.addingOwnerLabel()
        } else {
            self.addingBankAccountInfo()
        }
    }
    
    fileprivate func addingDeleteButton() {
        self.addSubview(deleteButton)
        self.deleteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: deleteButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: deleteButton, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: deleteButton, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0, constant: 25).isActive = true
        NSLayoutConstraint(item: deleteButton, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 25).isActive = true
    }
    
    fileprivate func addingAcceptStateLabel() {
        self.addSubview(acceptStateLabel)
        self.acceptStateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: acceptStateLabel, attribute: .leading, relatedBy: .equal, toItem: deleteButton, attribute: .trailing, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: acceptStateLabel, attribute: .centerY, relatedBy: .equal, toItem: deleteButton, attribute: .centerY, multiplier: 1, constant: 3).isActive = true
    }
    
    fileprivate func addingInfoLabel() {
        self.addSubview(infoLabel)
        self.infoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: infoLabel, attribute: .centerY, relatedBy: .equal, toItem: deleteButton, attribute: .centerY, multiplier: 0.7, constant: 0).isActive = true
        NSLayoutConstraint(item: infoLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -20).isActive = true
    }
    
    fileprivate func addingOwnerLabel() {
        self.addSubview(ownerLabel)
        self.ownerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: ownerLabel, attribute: .centerY, relatedBy: .equal, toItem: deleteButton, attribute: .centerY, multiplier: 1.4, constant: 0).isActive = true
        NSLayoutConstraint(item: ownerLabel, attribute: .trailing, relatedBy: .equal, toItem: infoLabel, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
    }
    
    fileprivate func addingBankAccountInfo() {
        self.addSubview(infoLabel)
        self.infoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: infoLabel, attribute: .centerY, relatedBy: .equal, toItem: deleteButton, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: infoLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: infoLabel, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.5, constant: 0).isActive = true
    }
    
    //MARK: - OBJC FUNCTIONS
    @objc func deleteButtonPressed() {
        if bankInfoViewModel !=  nil  {
            deleteButton.showLoader(userInteraction: false)
            deleteButton.autoHideLoader()
            delegate?.deleteBankInfoPressed(type: type, item: bankInfoViewModel!)
        }
    }
    
    //MARK: - UPDATE UI
    fileprivate func updateUI() {
        guard let item = bankInfoViewModel else { return }
        if item.name ==  "" {
            self.infoLabel.text = "IR" + item.mainInfo.convertEngNumToPersianNum()
        } else {
            self.infoLabel.text = item.mainInfo.convertEngNumToPersianNum()
        }
        self.ownerLabel.text = item.name
        self.acceptStateLabel.text = item.isAccepted 
        
    }
}
