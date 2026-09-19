//
//  Const.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 7/28/21.
//

import UIKit

struct Constants {
    static var BASE_URL: String {
        return "https://api.ompfinex.com/v1"
    }
    
    static var navFontSize: CGFloat {
        return CGFloat(17)
    }
    
    static var screenWidth: CGFloat  {
        return UIScreen.main.bounds.width
    }
    
    static var screenHeight: CGFloat  {
        return UIScreen.main.bounds.height
    }
    
    static var isNewDevice: Bool {
        return UIDevice.current.newDevice
    }
}

public func print(_ object: Any...) {
    #if DEBUG
    for item in object {
        Swift.print(item)
    }
    #endif
}

public func print(_ object: Any) {
    #if DEBUG
    Swift.print(object)
    #endif
}
