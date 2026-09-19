//
//  WebServices.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 8/1/21.
//

import Foundation

enum PostWebService: String {
    case signIn                         = "/user/sign-in"
    case signup                         = "/user/sign-up"
    case resetPassword                  = "/user/reset-password"
    case requestForEmailVerification    = "/user/verification/email"
    case emailVerificationCode          = "/user/verification/email/verify"
    case requestForMobileVerification   = "/user/verification/phone"
    case sendMobileVerificationCode     = "/user/verification/phone/verify"
    case uploadIdentityInformation      = "/user/verification/personal-information"
    case addCreditCard                  = "/user/verification/credit-card"
    case addBankAccount                 = "/user/verification/iban"
    case requestLandlineVerification    = "/user/verification/landline-phone"
    case verifyLandlineVerification     = "/user/verification/landline-phone/verify"
    case addressVerification            = "/user/verification/address"
    case identityImage                  = "/user/verification/identity-photo"
}

enum GetWebService: String {
    case userInfo                       = "/user"
    case creditCardList                 = "/user/verification/credit-card"
    case bankAccountList                = "/user/verification/iban"
    case provinceList                   = "/province"
    case statesList                     = "/city"
    case announcement                   = "/notification"
    case transactionHistory             = "/user/transaction"
    case market                         = "/market"
    case order                          = "/user/order"
    case wallet                         = "/user/wallet"
}

enum DeleteWebService: String {
    case deleteCreditCard               = "/user/verification/credit-card"
    case deleteBankAccount              = "/user/verification/iban"
    case logout                         = "/user/logout"
    case deleteOrder                    = "/user/order"
}

enum PutWebServices: String {
    case announcement                   = "/notification"
    case userInfo                       = "/user"
}
