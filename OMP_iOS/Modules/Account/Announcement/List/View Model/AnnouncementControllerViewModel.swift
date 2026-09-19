//
//  AnnouncementControllerViewModel.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 12/12/21.
//

import UIKit

protocol AnnouncementControllerViewModelProtocol: AnyObject {
    func newDataReceived()
    func updateItemAt(index: IndexPath)
}

class AnnouncementControllerViewModel {
    
    private var announcements: [Announcement] = []
    private var page: Int = 1
    let rowHeight: CGFloat = 180
    
    var navigationTitle: String {
        return "AnnouncementViewController.navTitle".localized
    }
    
    var getNumberOfRows: Int {
        return announcements.count
    }
    
    weak var delegate: AnnouncementControllerViewModelProtocol?
    
    //MARK: - FUNCTIONS
    func loadMore() {
        if page > 0 {
            page += 1
            getAnnouncementList(newRefresh: false)
        }
    }
    
    func refreshForNewData() {
        page = 1
        getAnnouncementList(newRefresh: true)
    }
    
    func getItemForRowAt(indexPath: IndexPath) -> Announcement {
        return announcements[indexPath.row]
    }
    
    func updateItemWithSelectedImage(with item: Announcement, at indexPath: IndexPath) {
        let announcement = Announcement(id: item.id, title: item.title, message: item.message, createdAt: item.createTime, isRead: true)
        announcements.remove(at: indexPath.row)
        announcements.insert(announcement, at: indexPath.row)
        delegate?.updateItemAt(index: indexPath)
    }
    //MARK: - API
    func getAnnouncementList(newRefresh: Bool) {
        if page > 0 {
            AnnouncementsService.getAnnouncements(request: .init(page: page)) { [weak self] results in
                Preloader.sharedInstance.stopLoading()
                guard let self = self else { return }
                switch results {
                case let .success(response):
                    switch response {
                    case let .success(response: responseModel):
                        if responseModel.data.count == 0 {
                            self.page = -1
                        }
                        if newRefresh {
                            self.announcements = responseModel.data
                        } else {
                            self.announcements += responseModel.data
                        }
                        self.delegate?.newDataReceived()
                    case let .validation(error: errorModel):
                        print(errorModel)
                    }
                case let .failure(error):
                    Popup.showError(body: error.localizedStrings)
                }
            }
            page += 1
        }
    }
}
