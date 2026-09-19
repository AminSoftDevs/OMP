//
//  ReferralControllerViewModel.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 11/23/21.
//

import Foundation

protocol ReferralControllerViewModelProtocol: AnyObject {
    func NowWeCanCreateUI()
    func updateReferralsTable()
    func statsReceived(friends: String, benefits: String)
    func updateInvitationCodeAndLink(code: String, link: String)
    func youHaveSubmittedReferralCode()
    func userHasCreatedNewInvitationCode()
}

class ReferralControllerViewModel {
    
    var uiCreated: Bool = false
    
    var referredByCode: String?
    
    var referralStats: Stats? {
        didSet {
            guard let stats = referralStats else { return }
            delegate?.statsReceived(friends: String(stats.totalFriends), benefits: String(stats.totalProfit))
        }
    }
    
    var referrals: [ReferralElement] = [] {
        didSet {
            delegate?.NowWeCanCreateUI()
            delegate?.updateReferralsTable()
            updateInvitationCodeAndLink()
        }
    }
    
    var navTitle: String {
        return "AccountViewController.referral".localized
    }
    
    var numberOfRowsInReferralTable: Int {
        return referrals.count
    }
    
    var isThereReferralCode: Bool {
        return referrals.count > 0
    }
    
    var isUserReferred: Bool {
        return userInfo.referred
    }
    
    weak var delegate: ReferralControllerViewModelProtocol?
    
    //MARK: - INITIALIZER
    private let userInfo: UserInfo
    
    init(userInfo: UserInfo) {
        self.userInfo = userInfo
    }
    
    //MARK: - FUNCTIONS
    func getReferralForRowAt(indexPath: IndexPath) -> ReferralElement {
        return referrals[indexPath.row]
    }
    func updateInvitationCodeAndLink() {
        if let firstItem = referrals.first {
            let link = "https://app.ompfinex\n.com/sign-up?ref=\(firstItem.id)"
            let code = firstItem.id
            delegate?.updateInvitationCodeAndLink(code: code, link: link)
        }
    }
    
    //MARK: - API
    func getReferralsDetails() {
        Preloader.sharedInstance.startLoading()
        ReferralDetailsService.getReferralsDetails { [weak self] results in
            guard let self = self else { return }
            switch results {
            case let .success(response):
                switch response {
                case let .success(response: receivedResponse):
                    self.referralStats = receivedResponse.data.stats
                    self.referrals = receivedResponse.data.referrals
                    Preloader.sharedInstance.stopLoading()
                case .validation(error: _):
                    Preloader.sharedInstance.stopLoading()
                }
            case let .failure(error):
                Preloader.sharedInstance.stopLoading()
                Popup.showError(body: error.localizedStrings)
            }
        }
    }
    
    func addReferredByCode() {
        guard let code = self.referredByCode else { return }
        ReferredByService.addReferralCode(request: .init(referralCode: code)) { [weak self] results in
            switch results {
            case let .success(receivedResponse):
                switch receivedResponse {
                case .success(response: _):
                    print("was success")
                    self?.delegate?.youHaveSubmittedReferralCode()
                case let .validation(error: responseError):
                    if let codeError  = responseError.errors.referralCode {
                        Popup.showError(body: codeError.createErrorMessage())
                    }
                }
            case let .failure(error):
                Popup.showError(body: error.localizedStrings)
            }
        }
    }
}
