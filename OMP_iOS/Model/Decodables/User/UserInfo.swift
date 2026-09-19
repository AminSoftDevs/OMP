//
//  UserInfo.swift
//  OMP_iOS
//
//  Created by AminSoft on 7/24/1400 AP.
//

import Foundation
// MARK: - User Info
struct UserInfo: Decodable {
    let firstName, lastName, email, birthday: String
    let phone: Int
    let nationalID: String
    let gender: String
    let emailVerified: AcceptState
    let phoneVerified: AcceptState
    let identityCardVerified: AcceptState
    let landlinePhoneVerified: AcceptState
    let bankVerified: AcceptState
    let addressVerified: AcceptState
    let identityVerified: AcceptState
    let referred: Bool
    let transactionFee, totalVolume: Double
    let userLevel: String
    let languages: [AppLanguage]
    let themes: [AppTheme]
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case birthday
        case phone
        case nationalID = "national_id"
        case gender
        case emailVerified = "email_verified"
        case phoneVerified = "phone_verified"
        case identityCardVerified = "identity_card_verified"
        case landlinePhoneVerified = "landline_phone_verified"
        case bankVerified = "bank_verified"
        case addressVerified = "address_verified"
        case identityVerified = "identity_verified"
        case referred
        case transactionFee = "transaction_fee"
        case totalVolume = "total_volume"
        case userLevel = "user_level"
        case settings
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.email = try container.decode(String.self, forKey: .email)
        self.emailVerified = try container.decode(AcceptState.self, forKey: .emailVerified)
        self.phoneVerified = try container.decode(AcceptState.self, forKey: .phoneVerified)
        self.identityCardVerified = try container.decode(AcceptState.self, forKey: .identityCardVerified)
        self.landlinePhoneVerified = try container.decode(AcceptState.self, forKey: .landlinePhoneVerified)
        self.bankVerified = try container.decode(AcceptState.self, forKey: .bankVerified)
        self.addressVerified = try container.decode(AcceptState.self, forKey: .addressVerified)
        self.identityVerified = try container.decode(AcceptState.self, forKey: .identityVerified)
        self.referred = try container.decode(Bool.self, forKey: .referred)
        self.transactionFee = try container.decode(Double.self, forKey: .transactionFee)
        self.totalVolume = try container.decode(Double.self, forKey: .totalVolume)
        self.userLevel = try container.decode(String.self, forKey: .userLevel)
        
        if let firsName = try container.decodeIfPresent(String.self, forKey: .firstName) {
            self.firstName = firsName
        } else {
            self.firstName = ""
        }
        
        if let lastName = try container.decodeIfPresent(String.self, forKey: .lastName) {
            self.lastName = lastName
        } else {
            self.lastName = ""
        }
        
        if let birthDay = try container.decodeIfPresent(String.self, forKey: .birthday) {
            self.birthday = birthDay
        } else {
            self.birthday = ""
        }
        
        if let mobile = try container.decodeIfPresent(Int.self, forKey: .phone) {
            self.phone = mobile
        } else {
            self.phone = 0
        }
        
        if let nationalID = try container.decodeIfPresent(String.self, forKey: .nationalID) {
            self.nationalID = nationalID
        } else {
            self.nationalID = ""
        }
        
        if let gender = try container.decodeIfPresent(String.self, forKey: .gender) {
            self.gender = gender
        } else {
            self.gender = ""
        }
        
        let settings = try container.decode([Setting].self, forKey: .settings)
        self.languages = settings.getLanguages()
        self.themes = settings.getThemes()
    }
}

// MARK: - Setting
struct Setting: Decodable {
    let name, label, type: String
    let min, max: Int?
    let items: [Item]?
}

// MARK: - Item
struct Item: Decodable {
    let id, label: String
}

enum AcceptState: String, Codable {
    case accepted   = "ACCEPTED"
    case rejected   = "REJECTED"
    case notStarted = "NOT_STARTED"
    case pending    = "PENDING"
    case none
    
    public static func fromString(_ caseStudy: String) -> AcceptState {
        switch caseStudy {
        case "ACCEPTED":
            return .accepted
        case "REJECTED":
            return .rejected
        case "NOT_STARTED":
            return .notStarted
        case "PENDING":
            return .pending
        default:
            return .none
        }
    }
}

extension Array where Element == Setting {
   
    func getLanguages() -> [AppLanguage] {
        var languages: [AppLanguage] = []
        
        if let appLanguageSection = filter({$0.name == "LANGUAGE"}).first, let items = appLanguageSection.items {
            items.forEach({ item in
                if let language = AppLanguage(rawValue: item.id) {
                    languages.append(language)
                }
            })
        }
        return languages
    }
    
    func getThemes() -> [AppTheme] {
        var themes: [AppTheme] = []
        if let appThemeSection = filter({$0.name == "THEME"}).first, let items = appThemeSection.items {
            items.forEach({ item in
                if let item  = AppTheme(rawValue: item.id) {
                    themes.append(item)
                }
            })
        }
        return themes
    }
}


extension UserInfo {
    var userMobile: String {
        return  self.phone == 0 ? "" : String(self.phone)
    }
    
    var convertedTransactionFee: String {
        return self.transactionFee.format(f: "4")
    }
    
    var monthlyTransactionsValue: String {
        return self.totalVolume == 0 ? "0" : self.totalVolume.format(f: "2")
    }
}
