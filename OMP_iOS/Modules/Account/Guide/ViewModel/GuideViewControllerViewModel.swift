//
//  GuideViewControllerViewModel.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 11/8/21.
//

import Foundation

class GuideViewControllerViewModel {
    
    private let dataSource: [Guide] = [
        Guide(title: "GuideViewControllerViewModel.contactUs".localized, url: "https://www.ompfinex.com/contact-us", iconName: "call_us"),
        Guide(title: "GuideViewControllerViewModel.AboutUs".localized, url: "https://www.ompfinex.com/pages/about", iconName: "about_us"),
        Guide(title: "GuideViewControllerViewModel.rules".localized, url: "https://www.ompfinex.com/pages/policies", iconName: "policies"),
        Guide(title: "GuideViewControllerViewModel.blogs".localized, url: "https://blog.ompfinex.com/", iconName: "weblog"),
        Guide(title: "GuideViewControllerViewModel.security".localized, url: "https://www.ompfinex.com/pages/security", iconName: "security"),
        Guide(title: "GuideViewControllerViewModel.demoMarket".localized, url: "https://www.ompfinex.com/pages/demo-market", iconName: "demo_market"),
        Guide(title: "GuideViewControllerViewModel.FAQ".localized, url: "https://www.ompfinex.com/pages/faq", iconName: "FAQ"),
        Guide(title: "GuideViewControllerViewModel.fees".localized, url: "https://www.ompfinex.com/pages/pricing", iconName: "pricing")
    ]
    
    var controllerTitle: String {
        return "AccountViewController.userGuid".localized
    }
    var numberOfRows: Int {
        return dataSource.count
    }
    
    //MARK: - FUNCTIONS
    func getItemForRow(index: Int) -> Guide {
        return dataSource[index]
    }
    
    func getSelectedItemPath(index: Int) -> String {
        return dataSource[index].url
    }
}
