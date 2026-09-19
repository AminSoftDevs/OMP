//
//  AppDelegate.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 7/28/21.
//

import UIKit
import IQKeyboardManagerSwift
import DropDown
import Toast
import Firebase
import Crisp

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    var orientationLock = UIInterfaceOrientationMask.portrait
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        DropDown.startListeningToKeyboard()
        configToast()
        FirebaseApp.configure()
        
        // Configure Crisp Messenger
        CrispSDK.configure(websiteID: "6b11c58c-4a22-43a7-b350-affba1bbc4c0")
        
        // Handle logout
        NotificationCenter.default.addObserver(self, selector: #selector(handlingUnauthorizedResponse), name: .shouldLogin, object: nil)
        // Localization
        if let selectedLanguage = Localization.sharedInstance.getLanguage(firstRun: true) {
            Localization.sharedInstance.setLanguage(language: selectedLanguage)
        } else {
            Localization.sharedInstance.setLanguage(language: "fa-IR")
        }
        
        // Handle Security Code
        if KeychainData.securityCode != "" || UserDefaults.standard.isBiometric == true {
            DispatchQueue.main.async {
                let vc = InputSecurityCodeViewController.makeInstance()
                UIApplication.changeRootViewController(vc)
            }
        } else {
            self.initRootView()
        }
        IQKeyboardManagerConfig()
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }
    
    func IQKeyboardManagerConfig() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "keyboard.done".localized
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.placeholderFont = UIFont(type: .bold, fontSize: 15)
        IQKeyboardManager.shared.placeholderButtonColor = .blue
    }
    
    fileprivate func configToast() {
        var style = ToastStyle()
        style.messageColor = .textColor
        style.backgroundColor = .darkGray
        style.titleFont = UIFont.init(type: .regular, fontSize: 10.0)
        style.titleAlignment = .right
        ToastManager.shared.style = style
        ToastManager.shared.isQueueEnabled = false
    }
    
    @objc func handlingUnauthorizedResponse() {
        UserDefaults.standard.isLogin = false
        KeychainData.deleteToken()
        DispatchQueue.main.async {
            let vc = UINavigationController(rootViewController: LoginViewController())
            UIApplication.changeRootViewController(vc)
            NotificationCenter.default.post(name: .logout, object: nil)
        }
    }
    
    func initRootView(_ fromForgetPassword: Bool = false){
        // set appearance of component on basic of language direction
        let dir = Localization.sharedInstance.getlanguageDirection()
        
        if fromForgetPassword == false {
            if UserDefaults.standard.isLogin == false {
                return
            }
        }
        
        if  dir == .leftToRight {
            let semantic: UISemanticContentAttribute = .forceRightToLeft
            UITabBar.appearance().semanticContentAttribute = semantic
            UIView.appearance().semanticContentAttribute = semantic
            UINavigationBar.appearance().semanticContentAttribute = semantic
        } else {
            let semantic: UISemanticContentAttribute = .forceLeftToRight
            UITabBar.appearance().semanticContentAttribute = semantic
            UIView.appearance().semanticContentAttribute = semantic
            UINavigationBar.appearance().semanticContentAttribute = semantic
        }
        let vc = MainTabBarController()
        UIApplication.changeRootViewController(vc)
    }
}

