//
//  InvitationCodeCreationViewModel.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 11/24/21.
//

import UIKit

protocol InvitationCodeCreationViewModelProtocol: AnyObject {
    func percentsValuesShouldUpdate()
    func responseReceivedStopLoading()
}

class InvitationCodeCreationViewModel {
    
    var getYourShare: String {
        return String(yourShare) + "%"
    }
    
    var getFriendShare: String {
        return String(friendShare) + "%"
    }
    
    private var yourShare: Int = 30
    private var friendShare: Int = 0
    
    let sharePercentsDataSource: [String] = Array(["30", "25", "20", "15", "10", "5", "0"].map({ $0.convertEngNumToPersianNum()}))
    
    var numberOfItemsForCollectionView: Int {
        return sharePercentsDataSource.count
    }
    
    weak var delegate: InvitationCodeCreationViewModelProtocol?
    
    //MARK: - FUNCTIONS
    func valueForItemAt(indexPath: IndexPath) -> String {
        return sharePercentsDataSource[indexPath.item] + "%"
    }
    
    func selectedItemFromCommissionCollectionView(indexPath: IndexPath) {
        let value = sharePercentsDataSource[indexPath.row].persianToEng()
        let valueToInt = Int(value) ?? 0
        yourShare = valueToInt
        friendShare = 30 - yourShare
        delegate?.percentsValuesShouldUpdate()
        
    }
    
    func createNewInvitationCode() {
        newInvitationCodeAPI()
    }
    //MARK: - API
    private func newInvitationCodeAPI() {
        CreateReferralCodeService.createReferralCode(request: .init(friendShare: friendShare)) { [weak self] results in
            switch results {
            case let .success(response):
                switch response {
                case .success(response: _):
                    self?.delegate?.responseReceivedStopLoading()
                case let .validation(error: errorModel):
                    if let error = errorModel.errors.friendShare {
                        Popup.showError(body: error.createErrorMessage())
                    }
                }
            case let .failure(error):
                Popup.showError(body: error.localizedStrings)
            }
        }
    }
}
