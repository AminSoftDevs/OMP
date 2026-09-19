//
//  DetailAnnouncementControllerViewModel.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 12/13/21.
//

import Foundation

class DetailAnnouncementControllerViewModel {
    
    var navigationTitle: String {
        return "AnnouncementViewController.navTitle".localized
    }
    
    var title: String {
        return announcement.title
    }
    
    var createTime: String {
        return announcement.createTime
    }
    
    var message: String {
        return announcement.message
    }
    
    //MARK: - INITIALIZER
    private let announcement: Announcement
    
    init(announcement: Announcement) {
        self.announcement = announcement
    }
    
    //MARK: - API
    func readAnnouncement() {
        guard announcement.isRead == false else { return }
        ReadingAnnouncementService.readingAnnouncement(request: .init(id: announcement.id)) { results in
            switch results {
            case let .success(receivedResponse):
                switch receivedResponse {
                case .success(response: _):
                    print("was success")
                case .validation(error: _):
                    print("id is not valid")
                }
            case let .failure(error):
                print(error.localizedStrings)
            }
        }
    }
}
