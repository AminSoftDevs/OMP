//
//  ViewController.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 7/28/21.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    var tabBarItems: [UIViewController] = []
    
    let accountViewController = UINavigationController(rootViewController: AccountViewController.makeInstanceMethod())
    let marketViewController = UINavigationController(rootViewController: MarketViewController.makeInstance())
    let tradesViewController = UINavigationController(rootViewController: TradesViewController.makeInstance())
    let walletsViewController = UINavigationController(rootViewController: WalletsViewController.makeInstance())
    
    
    //MARK: - VIEW CONTROLLER LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTabBarController()
        self.stylingTabBar()
        self.selectedIndex = 0
        self.tabBar.isTranslucent = false
        self.tabBar.barTintColor = .cardsColor
        self.delegate = self
        
        if UIDevice.current.newDevice {
            self.tabBar.items?.forEach({ $0.titlePositionAdjustment = UIOffset(horizontal: 0.0, vertical: 8.0) })
            self.tabBar.items?.forEach ({ $0.imageInsets = .init(top: 5, left: 0, bottom: -5, right: 0)})
        } else {
            self.tabBar.items?.forEach ({ $0.imageInsets = .init(top: 5, left: 0, bottom: -3, right: 0)})
        }
    }
    
    private func setupTabBarController() {
        let account = "tabBar.Account".localized
        let market = "tabBar.Market".localized
        let trades = "tabBar.Trade".localized
        let wallet = "tabBar.Wallet".localized
        
        accountViewController.tabBarItem =
        UITabBarItem(title: account,
                     image: UIImage(named: "account_icon"),
                     selectedImage: UIImage(named: "account_icon_selected")?.withRenderingMode(.alwaysTemplate))
        
        marketViewController.tabBarItem =
        UITabBarItem(title: market,
                     image: UIImage(named: "market_icon"),
                     selectedImage: UIImage(named: "market_icon_selected")?.withRenderingMode(.alwaysTemplate))
        
        tradesViewController.tabBarItem =
        UITabBarItem(title: trades,
                     image: UIImage(named: "trades_icon"),
                     selectedImage: UIImage(named: "trades_icon_selected")?.withRenderingMode(.alwaysTemplate))
        
        walletsViewController.tabBarItem =
        UITabBarItem(title: wallet,
                     image: UIImage(named: "wallet_icon"),
                     selectedImage: UIImage(named: "wallet_icon_selected")?.withRenderingMode(.alwaysTemplate))
        
        tabBarItems = [accountViewController, marketViewController, tradesViewController, walletsViewController]
        
        setViewControllers(tabBarItems, animated: true)
    }
    
    func stylingTabBar() {
        
        let selectedColor   = UIColor.submitButtonColor
        let unselectedColor = #colorLiteral(red: 0.5960784314, green: 0.5960784314, blue: 0.6745098039, alpha: 1)
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.font: UIFont.init(type: .regular, fontSize: 14)]
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.font: UIFont.init(type: .regular, fontSize: 14)]
            UITabBarItem.appearance().setTitleTextAttributes([.font: UIFont.init(type: .regular, fontSize: 14)], for: .normal)
            appearance.configureWithDefaultBackground()
            appearance.backgroundColor = .cardsColor
            tabBar.standardAppearance = appearance
            tabBar.tintColor = .submitButtonColor
            tabBar.scrollEdgeAppearance = appearance
        } else {
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: unselectedColor], for: .normal)
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: selectedColor], for: .selected)
            let fontAttributes = [NSAttributedString.Key.font: UIFont(type: .regular, fontSize: 14)]
            UITabBarItem.appearance().setTitleTextAttributes(fontAttributes, for: .normal)
            //Set Tab bar text/item color
            UITabBar.appearance().tintColor = UIColor.submitButtonColor
            UINavigationBar.appearance().titleTextAttributes = [
                NSAttributedString.Key.font: UIFont(type: .regular, fontSize: 14)
            ]
            UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(type: .bold, fontSize: 14), NSAttributedString.Key.foregroundColor: UIColor.submitButtonColor], for: UIControl.State.normal)
        }
    }
}
extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex == 3 {
            if UserDefaults.standard.isLogin == false {
                UIApplication.changeRootViewController(LoginViewController())
            }
        }
    }
}
