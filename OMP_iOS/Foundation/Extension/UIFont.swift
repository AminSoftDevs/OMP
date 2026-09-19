//
//  UIFont.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 7/28/21.
//

import UIKit

extension UIFont {
    
    convenience init(type: FontString, fontSize: CGFloat) {
        let dir = Localization.sharedInstance.getlanguageDirection()
        var finalSize:CGFloat = fontSize
        let deviceType = DeviceType.detect(device: UIScreen.main.nativeBounds.height)
        switch deviceType {
        case .iPhoneSE:
            finalSize = fontSize * 0.9
        case .iPhone8:
            finalSize = fontSize * 1.1
        case .iPhonePlus:
            finalSize = fontSize * 1.2
        case .iPhoneXR:
            finalSize = fontSize * 1.2
        case .iPhoneXS:
            finalSize = fontSize * 1.1
        case .iPhoneXSMax:
            finalSize = fontSize * 1.2
        case .iPhone12ProMax:
            finalSize = fontSize * 1.2
        default:
            finalSize = fontSize * 1
        }
        
        switch dir {
        case .leftToRight:
            self.init(name: FontString.englishRegular.rawValue, size: finalSize)!
        case .rightToLeft:
            self.init(name: type.rawValue, size: finalSize)!
        }
    }
    
}
