//
//  Announcement.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 8/20/21.
//

import Foundation

struct Announcement: Codable {
    let id: Int
    let title, message, createdAt: String
    let isRead: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, title, message
        case createdAt = "created_at"
        case isRead = "is_read"
    }
}

extension Announcement {
    var createTime: String {
        return self.createdAt.UTCLocalWithFormat().convertEngNumToPersianNum()
    }
    
    var iconName: String {
        return self.isRead ? "opened_message_icon" : "unread_notif_icon"
    }
}
