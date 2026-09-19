//
//  BaseModule.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 7/28/21.
//

import UIKit

class BaseModule {

    static let sharedInstance = BaseModule()
    private init() {}
    
    //static let marketType = "/demo"
    static let marketType = UserDefaults.standard.selectedMarket.rawValue
    
    //MARK: - Singleton

    lazy var network      = BaseNetwork.sharedInstance
    lazy var notification = BaseNotification.sharedInstance
    lazy var loader       = Preloader.sharedInstance
}
