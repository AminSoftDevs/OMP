//
//  WithdrawRialViewModel.swift
//  OMP_iOS
//
//  Created by AminSoft on 7/11/1400 AP.
//

import Foundation

protocol SendingIbanListProtocol: AnyObject {
    func updateIbanList(ibanList: [String])
    func calculationFinished()
}

class WithdrawRialViewModel {
    
    var totalWithdrawAmount: String = ""
    var withdrawFee: String = ""
    var withdrawItem:  RialWithdrawService.Response?
    
    private var ibanList: [Iban] = []
    private var selectedIban: Iban?
    private var _withdrawalAmount: Int?
    
    var withdrawalAmount: Int? {
        didSet {
            self._withdrawalAmount = (self.withdrawalAmount ?? 0) * 10
        }
    }
       
    var totalBalance: String {
        wallet.totalWalletBalance
    }
    
    weak var delegate: SendingIbanListProtocol?
   
    //MARK: - INITIALIZER
    let wallet: Wallet
    
    init(wallet: Wallet) {
        self.wallet = wallet
    }
    
    //MARK: - FUNCTIONS
    private func getArrayOfIbansList() -> [String] {
        return ibanList.map({ $0.ibanValue })
    }
    
    func dropDownItemDidSelect(at index: Int) {
        selectedIban = ibanList[index]
    }
    
    func finalAmountOfWithdraw(feeDetails: RialWithdrawFee) {
        let final = (feeDetails.amount.toDouble - feeDetails.fee.toDouble).changeToToman.formattedWithSeparator
        totalWithdrawAmount = final
        withdrawFee = feeDetails.fee.toDouble.changeToToman.toString.removeZeroFromEnd
        //delegate?.withdrawFeeCalculationResultReceived()
        delegate?.calculationFinished()
    }
    
    //MARK: - API
    func getIbansList() {
        iBankListService.getIBanList { [weak self] results in
            guard let self = self else { return }
            switch results {
            case let .success(success):
                switch success {
                case let .success(response: responseModel):
                    self.ibanList = responseModel.data
                    self.delegate?.updateIbanList(ibanList: self.getArrayOfIbansList())
                case let .validation(error: errorModel):
                    print(errorModel)
                }
            case let .failure(error):
                Popup.showError(body: error.localizedStrings)
            }
        }
    }
    
    func performWithdrawRequest(completion: @escaping (Bool) -> ()) {
        if selectedIban == nil {
            selectedIban = ibanList.last
        }
        
        guard let ibanId = selectedIban?.id else {
           return completion(false)
        }
        
        guard let amount = _withdrawalAmount else {
            Popup.showError(body: "Withdraw.pleaseFillTheWithdrawAmount".localized)
            return completion(false)
        }
        
        Preloader.sharedInstance.startLoading()
        RialWithdrawService.createRialWithdraw(request: .init(amount: amount, id: ibanId)) { [weak self] results in
            Preloader.sharedInstance.stopLoading()
            switch results {
            case let .success(responseReceived):
                switch responseReceived {
                case let .success(response: responseModel):
                    self?.withdrawItem = responseModel
                    completion(true)
                case let .validation(error: errorModel):
                    completion(false)
                    var errorMessage = ""
                    if let ibanID  = errorModel.errors.id {
                        errorMessage =  ibanID.createErrorMessage() + "\n"
                    }
                    if let amountError = errorModel.errors.amount {
                        errorMessage += amountError.createErrorMessage()
                    }
                    Popup.showError(body: errorMessage)
                }
            case let .failure(error):
                Popup.showError(body: error.localizedStrings)
                completion(false)
            }
            
        }
    }
    
    func rialWithdrawFeeCalculatorAPI() {
        guard let amount = _withdrawalAmount, amount > 99999 else {
            totalWithdrawAmount = ""
            withdrawFee = ""
            delegate?.calculationFinished()
            return
        }
        Preloader.sharedInstance.startLoading()
        RialWithdrawFeeCalculationService.calculateRialWithdrawFee(request: .init(amount: String(amount))) { [weak self] results in
            Preloader.sharedInstance.stopLoading()
            guard let self = self else { return }
            switch results {
            case let .success(response):
                switch response {
                case let .success(response: responseModel):
                    self.finalAmountOfWithdraw(feeDetails: responseModel.data)
                case let .validation(error: errorModel):
                    if let amountError = errorModel.errors.amount {
                        Popup.showError(body: amountError.createErrorMessage())
                    }
                    self.totalWithdrawAmount = ""
                    self.withdrawFee = ""
                    self.delegate?.calculationFinished()
                }
            case let .failure(error):
                Popup.showError(body: error.localizedStrings)
                self.totalWithdrawAmount = ""
                self.withdrawFee = ""
                self.delegate?.calculationFinished()
            }
        }
    }
}

