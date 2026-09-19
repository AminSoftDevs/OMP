//
//  CenteredButton.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 8/13/21.
//

import UIKit

class CenteredButton: UIButton {
    
    var bottomBorder = UIView()
    var badgeLabel = UILabel()
    
    var titleBottomPadding: CGFloat = 0.0 {
        didSet{
            self.updateUI()
        }
    }
    
    var hasBorder: Bool = false {
        didSet {
            self.updateUI()
        }
    }
    
    var badgeText: String = "" {
        didSet{
            self.updateUI()
        }
    }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let rect = super.titleRect(forContentRect: contentRect)
        
        return CGRect(x: 0, y: contentRect.height - rect.height - 5 - self.titleBottomPadding,
                      width: contentRect.width, height: rect.height)
    }
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let rect = super.imageRect(forContentRect: contentRect)
        let titleRect = self.titleRect(forContentRect: contentRect)
        
        return CGRect(x: contentRect.width/2.0 - rect.width/2.0,
                      y: (contentRect.height - titleRect.height)/2.0 - rect.height/2.0,
                      width: rect.width, height: rect.height)
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        
        if let image = imageView?.image {
            var labelHeight: CGFloat = 0.0
            
            if let size = titleLabel?.sizeThatFits(CGSize(width: self.contentRect(forBounds: self.bounds).width, height: CGFloat.greatestFiniteMagnitude)) {
                labelHeight = size.height
            }
            
            return CGSize(width: size.width, height: image.size.height + labelHeight + 5)
        }
        
        return size
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        centerTitleLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.centerTitleLabel()
    }
    
    private func centerTitleLabel() {
        self.titleLabel?.textAlignment = .center
    }
    
    private func addBottomBorder() {
        //MARK: Setup Bottom-Border
        self.translatesAutoresizingMaskIntoConstraints = false
        bottomBorder = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        bottomBorder.backgroundColor = UIColor.init(hex: "e1e1e1")
        bottomBorder.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bottomBorder)
        //Mark: Setup Anchors
        bottomBorder.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bottomBorder.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        bottomBorder.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        bottomBorder.heightAnchor.constraint(equalToConstant: 1).isActive = true // Set Border-Strength
    }
    
    private func createBadge() {
        self.badgeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(badgeLabel)
        badgeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        badgeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        badgeLabel.configure(text: self.badgeText, fontSize: 9.0, textColor: .red, textAlignment: .left, fontType: .bold)
        badgeLabel.transform = CGAffineTransform(rotationAngle: -(.pi / 4))

    }
    
    private func updateUI() {
        self.layoutIfNeeded()
        self.layoutSubviews()
        if self.hasBorder {
            self.addBottomBorder()
        }
        if self.badgeText.count > 0 {
            self.createBadge()
        }

    }
}
