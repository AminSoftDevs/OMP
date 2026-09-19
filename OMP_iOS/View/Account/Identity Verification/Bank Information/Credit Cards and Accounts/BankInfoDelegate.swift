//
//  BankInfoDelegate.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 8/15/21.
//

import UIKit

protocol BankInfoDelegate: AnyObject {
    func tableHeight(type: BankInformationType, height: CGFloat)
    func infoFieldNumber(type: BankInformationType, number: String)
    func newCreditOrBankAccount(type: BankInformationType, with number: String)
    func continueButtonPressed()
    func deleteBankInfoPressed(type: BankInformationType, item: BankInfoAdapter)
}

extension BankInfoDelegate {
    func tableHeight(type: BankInformationType, height: CGFloat) {}
    func infoFieldNumber(type: BankInformationType, number: String) {}
    func newCreditOrBankAccount(type: BankInformationType, with number: String) {}
    func continueButtonPressed() {}
    func deleteBankInfoPressed(type: BankInformationType, item: BankInfoAdapter) {}
}
