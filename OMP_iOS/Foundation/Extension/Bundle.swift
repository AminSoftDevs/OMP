//
//  Bundle.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 7/29/21.
//

import Foundation

extension Bundle {
    
    var releaseVersionNumber: String? {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    }
    
}
