//
//  AccountControllerViewModel.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 12/11/21.
//

import UIKit
import Crisp

protocol AccountControllerViewModelProtocol: AnyObject {
    func showIdentityVerificationNoticePopup()
    func tableShouldReload()
    func removedAt(indexPath: IndexPath)
}

class AccountControllerViewModel {
    
    private var firstTime = true
    private var shouldUpdateUI: Bool = true
    private var userAccountTableViewProvidedData: [AccountTableOptions] = [] {
        didSet {
            delegate?.tableShouldReload()
        }
    }
    
    var userInfo: UserInfo? {
        didSet {
            if identityVerificationIsCompleted(userInfo: userInfo!) == true {
                userAccountTableViewData()
            }
        }
    }
    
    var navigationTitle: String {
        return "AccountViewController.account".localized
    }
    
    var userEmailAddress: String {
        return UserDefaults.standard.userEmail
    }
    
    var isUserLoggedIn: Bool {
        return UserDefaults.standard.isLogin
    }
    
    var numberOfRowsInAccountTableView: Int {
        return userAccountTableViewProvidedData.count
    }
    
    var getHeightForRow: CGFloat {
        return 65
    }
    
    var navigationBarHeight: CGFloat {
        return 130
    }
    
    var tableViewHeight: CGFloat {
        return CGFloat(userAccountTableViewProvidedData.count) * getHeightForRow
    }
    
    weak var delegate: AccountControllerViewModelProtocol?
    
    //MARK: - FUNCTIONS
    func dataForRowAt(indexPath: IndexPath) -> AccountTableOptions {
        return userAccountTableViewProvidedData[indexPath.row]
    }
    
    func accountTableViewShouldFillScreen() -> Bool {
        if tableViewHeight + navigationBarHeight > Constants.screenHeight {
            return true
        } else {
            return false
        }
    }
    
    func identityVerificationIsCompleted(userInfo: UserInfo) -> Bool {
        let verificationState = userInfo
        if verificationState.emailVerified != .accepted {
            return false
        } else if verificationState.phoneVerified != .accepted {
            return false
        } else if verificationState.bankVerified != .accepted {
            return false
        } else if verificationState.identityCardVerified != .accepted {
            return false
        } else if verificationState.identityVerified != .accepted {
            return false
        }
        return true
    }
    
    func userAccountTableViewData() {
        var data: [AccountTableOptions] = []
        let loggedInTitle: [String] = [
            "AccountViewController.profile".localized,
            "AccountViewController.history".localized,
            "AccountViewController.setting".localized,
            "AccountViewController.userGuid".localized,
            "AccountViewController.security".localized,
            "AccountViewController.support".localized,
            "AccountViewController.logout".localized]
        
        let loggedInImageName: [String]  = [
            "profile_icon",
            "history_icon",
            "setting_icon",
            "info_icon",
            "lock_icon",
            "support_icon",
            "logout_icon"]
        
        let loggedInType: [AccountTableItemsType] = [.profile, .transactionHistory, .setting, .userGuid, .security, .support, .logout]
        
        let notLoggedInTitle: [String] = ["AccountViewController.setting".localized,
                                          "AccountViewController.userGuid".localized,
                                          "AccountViewController.security".localized,
                                          "AccountViewController.support".localized]
        let notLoggedInImageName: [String]  = ["setting_icon", "info_icon", "lock_icon", "support_icon"]
        let notLoggedInType: [AccountTableItemsType] = [.setting, .userGuid, .security, .support]
        
        if UserDefaults.standard.isLogin {
            for (index, _) in loggedInTitle.enumerated() {
                let rowDetail = AccountTableOptions(title: loggedInTitle[index], iconName: loggedInImageName[index], type: loggedInType[index])
                data.append(rowDetail)
            }
        } else {
            for (index, _) in notLoggedInTitle.enumerated() {
                let rowDetail = AccountTableOptions(title: notLoggedInTitle[index], iconName: notLoggedInImageName[index], type: notLoggedInType[index])
                data.append(rowDetail)
            }
        }
        
        if let userInfo = userInfo, identityVerificationIsCompleted(userInfo: userInfo) == true {
            if UserDefaults.standard.isLogin {
                let referralRow = AccountTableOptions(title: "AccountViewController.referral".localized, iconName: "referral_icon", type: .referral)
                data.insert(referralRow, at: data.count - 1)
                shouldUpdateUI = false
            }
        } else {
            if UserDefaults.standard.isLogin {
                let identityVerification = AccountTableOptions(title: "AccountViewController.identityVerification".localized, iconName: "identity_verification_icon", type: .identityVerification)
                data.insert(identityVerification, at: 0)
                shouldUpdateUI = false
            }
        }
        userAccountTableViewProvidedData = data
    }
    
    func removeIdentityVerificationRow() {
        if let userInfo = userInfo, identityVerificationIsCompleted(userInfo: userInfo) == true {
            if let index = userAccountTableViewProvidedData.firstIndex(where: { $0.type == .identityVerification}) {
                let indexPath = IndexPath(row: index, section: 0)
                delegate?.removedAt(indexPath: indexPath)
            }
        }
    }
    
    func sendUserInformationToCrisp() {
        if UserDefaults.standard.isLogin {
            CrispSDK.user.email = UserDefaults.standard.userEmail
            CrispSDK.user.nickname = UserDefaults.standard.userName
        }
    }
    
    //MARK: - API
    func getUserInfo() {
        guard isUserLoggedIn else { return }
        UserSettingService.getUserSetting { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(success):
                switch success {
                case let .success(response: responseModel):
                    self.userInfo = responseModel.data
                    UserDefaults.standard.userName = "\(responseModel.data.firstName) \(responseModel.data.lastName)"
                    UserDefaults.standard.appConfig = AppConfig(languages: responseModel.data.languages, themes: responseModel.data.themes)
                    if self.identityVerificationIsCompleted(userInfo: self.userInfo!) == false {
                        if self.firstTime == true {
                            self.delegate?.showIdentityVerificationNoticePopup()
                            self.firstTime = false
                        }
                    }
                    
                case let .validation(error: errorModel):
                    print(errorModel)
                }
                
            case let .failure(error):
                Popup.showError(body: error.localizedStrings)
                print(error.localizedStrings)
            }
        }
    }
    
    func logoutAPI() {
        Preloader.sharedInstance.startLoading()
        LogoutService.logout { [weak self] results in
            Preloader.sharedInstance.stopLoading()
            guard let self = self else { return }
            switch results {
            case .success(_):
                print("will never be success")
            case .failure(_):
                // Delete SecurityCode And Disable Biometric When User Logout
                KeychainData.deleteSecurityCode()
                UserDefaults.standard.isBiometric = false
                self.delegate?.tableShouldReload()
            }
        }
    }
}
