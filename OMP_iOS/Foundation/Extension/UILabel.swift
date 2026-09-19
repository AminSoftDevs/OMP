//
//  UILabel.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 7/28/21.
//

import Foundation
import UIKit

extension UILabel {
    
    func requiredHeight() {
        self.numberOfLines = 0
        self.lineBreakMode = NSLineBreakMode.byWordWrapping
    }
    
    func configure(text: String, fontSize: CGFloat, textColor: UIColor, textAlignment: NSTextAlignment = .right, fontType: FontString = .regular) {
        self.text = text.convertEngNumToPersianNum()
        self.font = UIFont.init(type: fontType, fontSize: fontSize)
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.sizeToFit()
    }
    
    func setLineSpacing(lineSpacing: CGFloat = 2.0, lineHeightMultiple: CGFloat = 0.0) {
        guard let labelText = self.text else { return }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        let attributedString:NSMutableAttributedString
        if let labelAttributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelAttributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }

        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        self.attributedText = attributedString
    }
    
}
