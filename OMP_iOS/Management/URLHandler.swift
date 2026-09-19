//
//  URLHandler.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 10/5/21.
//

import UIKit

class URLHandler {
    static func processBackURL(_ url: URL) {
        guard let source = url.valueOf("from") else { return }
        switch source {
        case "rial_deposit":
            let token = url.valueOf("token") ?? ""
            let paymentStatus = PaymentStatus(rawValue: url.valueOf("payment_status") ?? "") ?? .failed
            UIApplication.changeRootViewController(DepositVerificationViewController.makeInstance(status: paymentStatus, token: token))
        default:
            break
        }
    }
}

