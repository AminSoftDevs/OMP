//
//  SecurityViewModel.swift
//  OMP_iOS
//
//  Created by AminSoft on 9/4/1400 AP.
//

import UIKit
import LocalAuthentication

protocol SecurityItemsReceivedProtocol: AnyObject {
    func securityItemsReceived(items: [Security])
    func deleteButtonAction()
}

class SecurityViewModel {
    
    var securityWhenUserNotLoginData: [String] = [
         "SecurityViewController.securityOMP".localized
   ]
    
    var mainSecurityData: [String] = [
        "SecurityViewController.securityCode".localized,
        "SecurityViewController.activeID".localized,
        "SecurityViewController.entry&exit".localized,
        "SecurityViewController.securityOMP".localized
    ]
    
    var mainSecurityDataWithAuthentication: [String] = [
        "SecurityViewController.securityCode".localized,
        "SecurityViewController.activeID".localized,
        "SecurityViewController.entry&exit".localized,
        "SecurityViewController.entryWithAuthentication".localized,
        "SecurityViewController.securityOMP".localized
    ]
    
    var mainSecurityControllerTitle: String {
        return "AccountViewController.security".localized
    }
    
    var activeIdControllerTitle: String {
        return "SecurityViewController.activeID".localized
    }
    
    var entryAndExitControllerTitle: String {
        return "SecurityViewController.entry&exit".localized
    }
    
    var securityURL: String {
        return "https://www.ompfinex.com/pages/security"
    }
    var numberOfItems: Int {
        mainSecurityData.count
    }
    var numberOfItemsWithAuthentication: Int {
        mainSecurityDataWithAuthentication.count
    }
    var numberOfItemWhenUserNotLogin: Int {
        securityWhenUserNotLoginData.count
    }
    
    var securityItems: [Security] = [] {
        didSet {
            self.delegate?.securityItemsReceived(items: securityItems)
        }
    }
    // dellegate
    weak var delegate: SecurityItemsReceivedProtocol?
    
    func getItemsForIndexPath(_ index: Int) -> Security {
        return securityItems[index]
    }
    
    func getListFromServer(_ pageNumber: Int) {
        self.delegate?.securityItemsReceived(items: securityItems)
    }
    
    func loadMoreItemsForList() {
        if currentPage > 0 {
            currentPage += 1
            getUserSecurityInformation()
        }
    }
    
    var currentPage : Int = 1
    
    func getUserSecurityInformation() {
        SecurityService.getUserSecurityInformation(request: .init(active: true, page: currentPage)) { [weak self] results in
            guard let self = self else { return }
            switch results {
            case let .success(responseReceived):
                switch responseReceived {
                case let .success(response: response):
                    if response.data.count == 0 {
                        self.currentPage = -1
                    } else {
                        self.securityItems += response.data
                        self.delegate?.securityItemsReceived(items: response.data)
                    }
                case let .validation(error: errorModel):
                    print(errorModel.status)
                }
            case let .failure(error):
                Popup.showError(body: error.localizedStrings)
            }
        }
    }
    
    func deleteActiveIp(item: Int) {
        DeleteActiveIpSecurityService.deleteActiveIp(request: .init(id: item)) { [weak self] results in
            guard let self = self else { return }
            switch results {
            case let .success(responseReceived):
                switch responseReceived {
                case .success(response: _):
                    self.delegate?.deleteButtonAction()
                case let .validation(error: errorModel):
                    print(errorModel.status)
                    
                }
            case let .failure(error):
                Popup.showError(body: error.localizedStrings)
                print(error)
            }
        }
    }
    
    // Local Authentication Handler
    func canEvaluatePolicy() -> Bool {
        return LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
}
