//
//  BaseViewController.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 7/28/21.
//

import UIKit

class BaseViewController: UIViewController {
    
    lazy var defaultNavigationBarView = DefaultNavigationBarView()
    
    //MARK: - Constants
    let utility = BaseModule.sharedInstance
    
    //MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let theme = UserDefaults.standard.selectedTheme
        switch theme {
        case .light:
            navigationController?.navigationBar.barStyle = .default
            
        case .dark:
            navigationController?.navigationBar.barStyle = .black
            
        case .OMP:
            navigationController?.navigationBar.barStyle = .black
        }
    }
    
    func addingDefaultNavigationBarView(title: String, hasBackButton: Bool = true, leftSideButtonName: String? = nil, shouldHaveRadius: Bool = true) {
        self.defaultNavigationBarView.configure(title: title, hasBackButton: hasBackButton, leftSideButtonName: leftSideButtonName, shouldHaveRadius: shouldHaveRadius)
        self.view.addSubview(defaultNavigationBarView)
        self.defaultNavigationBarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            defaultNavigationBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            defaultNavigationBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            defaultNavigationBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            defaultNavigationBarView.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    //MARK: - Functions
    func changeStatusBarColor(color: UIColor = .cardsColor) {
        if #available(iOS 13.0, *) {
            let statusBar1 =  UIView()
            let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
            if let statusBarView = keyWindow?.subviews.first(where: { $0.tag == 1000 }) {
                statusBarView.removeFromSuperview()
            }
            if let statusBarFrame = keyWindow?.windowScene?.statusBarManager?.statusBarFrame {
                
                let currentTheme = UserDefaults.standard.selectedTheme
                switch currentTheme {
                case .OMP:
                    statusBar1.backgroundColor = .cardsColor
                case .dark:
                    statusBar1.backgroundColor = .cardsColor
                case .light:
                    statusBar1.backgroundColor = .cardsColor
                }

                
                statusBar1.frame = statusBarFrame
                statusBar1.tag = 1000
                keyWindow?.addSubview(statusBar1)
            }
        }
    }
    
    func setBackgroundColor(_ color: UIColor? = .backgroundColor) {
        self.view.backgroundColor = color
    }
    
    public func hideNavigationBar(_ isHide:Bool){
        navigationController?.navigationBar.isHidden = isHide
    }
    
    public func hideTabBar(_ isHide:Bool){
        tabBarController?.tabBar.isHidden = isHide
    }
    
    func removeNavigationBarBorder() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
}
