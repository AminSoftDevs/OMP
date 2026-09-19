//
//  ReferralDetails.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 11/25/21.
//

import Foundation

// MARK: - DataClass
struct ReferralDetails: Codable {
    let stats: Stats
    let referrals: [ReferralElement]
}

// MARK: - ReferralElement
struct ReferralElement: Codable {
    let id: String
    let userShare, friendShare: Int
    let profit: String
    let totalFriends: Int

    enum CodingKeys: String, CodingKey {
        case id
        case userShare = "user_share"
        case friendShare = "friend_share"
        case profit
        case totalFriends = "total_friends"
    }
}

// MARK: - Stats
struct Stats: Codable {
    let totalFriends, totalTransactions: Int
    let totalProfit: String

    enum CodingKeys: String, CodingKey {
        case totalFriends = "total_friends"
        case totalTransactions = "total_transactions"
        case totalProfit = "total_profit"
    }
}

extension ReferralElement {
    var yourShare: String {
        return "\(self.userShare)%"
    }
    
    var othersShare: String {
        return "\(self.friendShare)%"
    }
    
    var getInvitationLink: String {
        return "https://app.ompfinex.com/sign-up?ref=\(self.id)"
    }
}
