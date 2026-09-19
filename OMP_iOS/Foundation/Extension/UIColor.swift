//
//  UIColor.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 7/28/21.
//

import UIKit

extension UIColor {
    
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        //scanner.scanLocation = 0
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
    
    var hexString:String? {
        if let components = self.cgColor.components {
            let r = components[0]
            let g = components[1]
            let b = components[2]
            return  String(format: "%02X%02X%02X", (Int)(r * 255), (Int)(g * 255), (Int)(b * 255))
        }
        return nil
    }

    static var selectedDropDownItemColor: UIColor {
        switch UserDefaults.standard.selectedTheme {
        case .OMP:
            return UIColor(hex: "1B1B38")
        case .light:
            return UIColor(hex: "B5B5B6")
        case .dark:
            return UIColor(hex: "9898AC")
        }
    }
    
    static var submitButtonColor: UIColor {
        switch UserDefaults.standard.selectedTheme {
        case .OMP:
            return UIColor(hex: "A371FF")
        case .light:
           return  UIColor(hex: "3366FF")
        case .dark:
            return UIColor(hex: "6095FF")
        }
    }
    
    static var cardsColor: UIColor {
        switch UserDefaults.standard.selectedTheme {
        case .OMP:
            return UIColor(hex: "323259")
        case .light:
            return UIColor(hex: "FFFFFF")
        case .dark:
            return UIColor(hex: "080A0D")
        }
    }
    
    static var backgroundColor: UIColor {
        switch UserDefaults.standard.selectedTheme {
        case .OMP:
            return UIColor(hex: "1B1B38")
        case .light:
            return UIColor(hex: "EEF1F5")
        case .dark:
            return UIColor(hex: "111317")
        }
    }

    static var submitGreenColor: UIColor {
        switch UserDefaults.standard.selectedTheme {
        case .OMP:
            return UIColor(hex: "55E0B3")
        case .light:
            return UIColor(hex: "4CB050")
        case .dark:
            return UIColor(hex: "A8E2AC")
        }
    }
    
    static var rejectOrangeColor: UIColor {
        switch UserDefaults.standard.selectedTheme {
        case .OMP:
            return UIColor(hex: "FF9661")
        case .light:
            return UIColor(hex: "E55130")
        case .dark:
            return UIColor(hex: "FF9883")
        }
    }
    
    static var mediumGrayColor: UIColor {
        switch UserDefaults.standard.selectedTheme {
        case .OMP:
            return UIColor(hex: "B9C0CE")
        case .light:
            return UIColor(hex: "222B45")
        case .dark:
            return UIColor(hex: "D7DCE4")
        }
    }
    
    static var textFieldPlaceholderColor: UIColor {
        switch UserDefaults.standard.selectedTheme {
        case .OMP:
            return UIColor(hex: "B9C0CE")
        case .light:
            return UIColor(hex: "9898AC")
        case .dark:
            return UIColor(hex: "B9C0CE")
        }
    }
    
    static var textFiledBorderColor: UIColor {
        switch UserDefaults.standard.selectedTheme {
        case .OMP:
            return UIColor(hex: "6F6F8B")
        case .light:
            return UIColor(hex: "6F6F8B")
        case .dark:
            return UIColor(hex: "525356")
        }
    }
    
    static var switchColor: UIColor {
        switch UserDefaults.standard.selectedTheme {
        case .OMP:
            return UIColor(hex: "55E0B3")
        case .light:
            return UIColor(hex: "4CB050")
        case .dark:
            return UIColor(hex: "A8E2AC")
        }
    }
    static var tradingViewBackgroundColor: UIColor {
        switch UserDefaults.standard.selectedTheme {
        case .OMP:
            return UIColor(hex: "55E0B3")//TODO
        case .light:
            return UIColor(hex: "55E0B3")//TODO
        case .dark:
            return UIColor(hex: "55E0B3")//TODO
        }
    }
    
    static var textColor: UIColor {
        switch UserDefaults.standard.selectedTheme {
        case .OMP:
            return UIColor(hex: "FFFFFF")
        case .light:
            return UIColor(hex: "222B45")
        case .dark:
            return UIColor(hex: "FFFFFF")
        }
    }
    
    static var selectedTabbarColor: UIColor {
        switch UserDefaults.standard.selectedTheme {
        case .OMP:
            return UIColor(hex: "55E0B3")
        case .light:
            return UIColor(hex: "3366FF")
        case .dark:
            return UIColor(hex: "6095FF")
        }
    }
    
    static var tradeRowsHighlightForSellColor: UIColor {
        switch UserDefaults.standard.selectedTheme {
        case .OMP:
            return UIColor(hex: "7F1734")
        case .light:
            return UIColor(hex: "B31B1B")
        case .dark:
            return UIColor(hex: "7F1734")
        }
    }
    
    static var tradeRowsHighlightForBuyColor: UIColor {
        switch UserDefaults.standard.selectedTheme {
        case .OMP:
            return UIColor(hex: "009000")
        case .light:
            return UIColor(hex: "50C878")
        case .dark:
            return UIColor(hex: "FFFFFF")
        }
    }
}


