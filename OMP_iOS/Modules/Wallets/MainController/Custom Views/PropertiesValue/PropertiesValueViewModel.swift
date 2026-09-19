//
//  PropertiesValueViewModel.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 9/29/21.
//

import Foundation

class PropertiesValueViewModel {
    
    var value: String = "- ".addCurrency()
    var iconPath: URL?
    
    var valuesReceived: (() -> Void)?
    
    let title: String
    
    init(title: String) {
        self.title = title
    }
    
    func propertyInfo(value: String, icon: String) {
        self.value = value
        self.iconPath = URL(string: icon)
        self.valuesReceived?()
    }
}
