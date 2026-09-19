//
//  EmptyListView.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 8/28/21.
//

import UIKit

class EmptyListView: UIView {
    
    lazy var mainImageView: UIImageView = {
       var imageView = UIImageView()
        imageView.image = UIImage(named: "empty_box")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var mainLabel: UILabel = {
        let messageLabel = UILabel()
        messageLabel.textColor = .textColor
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(type: .regular, fontSize: 15)
        messageLabel.sizeToFit()
        messageLabel.text = "collectionView.empty".localized
        return messageLabel
    }()
    
    //MARK:  - DEFAULT INITIALIZER
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - CREATE UI
    fileprivate func createUI() {
        self.addingMainImageView()
        self.addingMainLabel()
    }
    
    fileprivate func addingMainImageView() {
        self.addSubview(mainImageView)
        self.mainImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: mainImageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: mainImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 0.8, constant: 0).isActive = true
        NSLayoutConstraint(item: mainImageView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.4, constant: 0).isActive = true
        NSLayoutConstraint(item: mainImageView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.2, constant: 0).isActive = true
    }
    
    fileprivate func addingMainLabel() {
        self.addSubview(mainLabel)
        self.mainLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: mainLabel, attribute: .centerX, relatedBy: .equal, toItem: mainImageView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: mainLabel, attribute: .top, relatedBy: .equal, toItem: mainImageView, attribute: .bottom, multiplier: 1, constant: 20).isActive = true
    }
}
