//
//  IdentityVerificationControllerViewModel.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 12/15/21.
//

import Foundation

protocol IdentityVerificationControllerViewModelProtocol: AnyObject {
    func whichStepOfIdentityVerification(identityVerificationInputType: IdentityVerificationInputType, step: Int, navTitle: String)
    func bankAccountListReceived()
    func creditCardsListReceived()
    func provinceListReceived()
    func cityListReceived()
    func stopLoadingButton()
    func requestForEmailVerificationCodeSentSuccessfully()
    func emailAddressVerified()
    func mobileVerificationCodeRequestSent()
    func mobileVerified()
    func landlinePhoneVerified()
    func addressRegisteredSuccessfully()
}

class IdentityVerificationControllerViewModel {
    
    var mobileNumber: String?
    private var nextViewType: IdentityVerificationInputType = .email
    private var cityList: [City] = []
    private var provinceList: [Province] = []
    private var creditCards: [CreditCard] = []
    private var bankAccounts: [Iban] = []
    private var landlineIsVerified: Bool = false
    
    var getCreditCards: [BankInfoAdapter] {
        var cards = creditCards.map({ BankInfo(id: $0.id, card: $0.card, account: nil, name: $0.name, verified: $0.verified, created_at: $0.createdAt, type: .credit)})
        let bankInfo = BankInfo(id: 0, card: "", account: nil, name: "", verified: "", created_at: "", type: .credit)
        cards.insert(bankInfo, at: 0)
        return cards.map({ BankInfoAdapter(bankInfo: $0)})
    }
    
    var getBankAccounts: [BankInfoAdapter] {
        var accounts = bankAccounts.map({ BankInfo(id: $0.id, card: nil, account: $0.iban, name: "", verified: $0.verified, created_at: $0.createdAt, type: .account)})
        let bankInfo = BankInfo(id: 0, card: nil, account: "", name: "", verified: "", created_at: "", type: .account)
        accounts.insert(bankInfo, at: 0)
        return accounts.map({ BankInfoAdapter(bankInfo: $0)})
    }
    
    var getProvinces: [Province] {
        return provinceList
    }
    
    var getCityList: [City] {
        return cityList
    }
    
    var getLandLineVerificationStatus: Bool {
        return landlineIsVerified
    }
    
    var navigationTitle: String {
        return "IdentityVerificationNavBar.identityVerification".localized
    }
    
    var mobileVerificationNavTitle: String {
        return "IdentityVerificationNavBar.mobile".localized
    }
    
    var identityVerificationNavTitle: String {
        return "IdentityVerificationNavBar.identity".localized
    }
    
    var getNextViewType: IdentityVerificationInputType {
        return nextViewType
    }
    
    var currentStep: Int = 0
    
    weak var delegate: IdentityVerificationControllerViewModelProtocol?
    
    //MARK: - INITIALIZER
    let userInfo: UserInfo?
    
    init(userInfo: UserInfo?) {
        self.userInfo = userInfo
    }
    
    //MARK: - FUNCTIONS
    func handleVerificationStep() {
        guard let userInfo = userInfo else {
            return
        }
        
        if userInfo.emailVerified != .accepted {
            delegate?.whichStepOfIdentityVerification(identityVerificationInputType: .email, step: 0, navTitle: "IdentityVerificationNavBar.email".localized)
        } else if userInfo.phoneVerified != .accepted {
            delegate?.whichStepOfIdentityVerification(identityVerificationInputType: .mobile, step: 1, navTitle: "IdentityVerificationNavBar.mobile".localized)
        } else if userInfo.identityCardVerified == .pending {
            delegate?.whichStepOfIdentityVerification(identityVerificationInputType: .waiting, step: 2, navTitle: "IdentityVerificationNavBar.identity".localized)
        } else if userInfo.identityCardVerified != .accepted {
            delegate?.whichStepOfIdentityVerification(identityVerificationInputType: .identity, step: 2, navTitle: "IdentityVerificationNavBar.identity".localized)
        }  else if userInfo.bankVerified != .accepted {
            getCreditCardsList()
            getBankAccountList()
            delegate?.whichStepOfIdentityVerification(identityVerificationInputType: .bankInfo, step: 3, navTitle: "IdentityVerificationNavBar.bankInformation".localized)
        } else if userInfo.identityVerified != .accepted {
            delegate?.whichStepOfIdentityVerification(identityVerificationInputType: .identityVerification, step: 4, navTitle: "IdentityVerificationNavBar.identityConfirmation".localized)
        } else {
            delegate?.whichStepOfIdentityVerification(identityVerificationInputType: .finalScreen, step: 5, navTitle: "IdentityVerificationNavBar.identityConfirmation".localized)
        }
    }
    //MARK: - API
    func emailVerificationCodeRequest() {
        delegate?.stopLoadingButton()
        EmailVerificationCodeRequestService.emailVerificationCodeRequest { [weak self] results in
            guard let self = self else { return }
            switch results {
            case let .success(response):
                switch response {
                case .success(response: _):
                    self.nextViewType = .emailCode
                    self.delegate?.requestForEmailVerificationCodeSentSuccessfully()
                case .validation(error: _):
                    print("nothing to verify")
                }
            case let .failure(error):
                Popup.showError(body: error.localizedStrings)
            }
        }
    }
    
    func checkEmailVerificationCode(with code: String) {
        delegate?.stopLoadingButton()
        CheckEmailVerificationCodeService.checkEmailVerificationCodeRequest(request: .init(code: code)) { [weak self] results in
            guard let self = self else { return }
            switch results {
            case let .success(response):
                switch response {
                case .success(response: _):
                    self.nextViewType = .mobile
                    self.currentStep += 1
                    self.delegate?.emailAddressVerified()
                case let .validation(error: errorModel):
                    if let error = errorModel.errors.code {
                        Popup.showError(body: error.createErrorMessage())
                    }
                }
            case let .failure(error):
                Popup.showError(body: error.localizedStrings)
            }
        }
    }
    
    func mobileVerificationCodeRequest(with phone: String, firstTime: Bool) {
        delegate?.stopLoadingButton()
        MobileVerificationCodeRequestService.mobileVerificationCodeRequest(request: .init(phone: phone)) { [weak self] results in
            guard let self = self else { return }
            switch results {
            case let .success(response):
                switch response {
                case .success(response: _):
                    if firstTime {
                        self.nextViewType = .mobileCode
                        self.delegate?.mobileVerificationCodeRequestSent()
                    }
                case let .validation(error: errorModel):
                    if let error = errorModel.errors.phone {
                        Popup.showError(body: error.createErrorMessage())
                    }
                }
            case let .failure(error):
                Popup.showError(body: error.localizedStrings)
            }
        }
    }
    
    func checkMobileVerificationCode(with code: String) {
        delegate?.stopLoadingButton()
        CheckMobileVerificationCodeService.checkMobileVerificationCodeRequest(request: .init(code: code)) { [weak self] results in
            guard let self = self else { return }
            switch results {
            case let .success(response):
                switch response {
                case .success(response: _):
                    self.nextViewType = .identity
                    self.currentStep += 1
                    self.delegate?.mobileVerified()
                    self.mobileNumber = nil
                case let .validation(error: errorModel):
                    if let error = errorModel.errors.code {
                        Popup.showError(body: error.createErrorMessage())
                    }
                }
            case let .failure(error):
                Popup.showError(body: error.localizedStrings)
            }
        }
    }
    
    func landlinePhoneVerificationCodeRequest(number: String) {
        LandlineVerificationCodeRequestService.requestLandlineVerifyCodeRequest(request: .init(phone: number)) { results in
            switch results {
            case let .success(response):
                switch response {
                case .success(response: _):
                    print("success")
                case .validation(error: _):
                    print("nothing to verify")
                }
            case let .failure(error):
                Popup.showError(body: error.localizedStrings)
            }
        }
    }
    
    func checkLandlineVerificationCodeAPI(with code: String) {
        CheckLandlineVerificationCodeService.checkLandlineVerificationCodeRequest(request: CheckLandlineVerificationCodeService.Request.init(code: code)) { [weak self] results in
            guard let self = self else { return }
            switch results {
            case let .success(response):
                switch response {
                case .success(response: _):
                    self.landlineIsVerified = true
                case let .validation(error: errorModel):
                    self.landlineIsVerified = false
                    if let error = errorModel.errors.code {
                        Popup.showError(body: error.createErrorMessage())
                    }
                }
            case let .failure(error):
                self.landlineIsVerified = false
                Popup.showError(body: error.localizedStrings)
            }
            self.delegate?.landlinePhoneVerified()
        }
    }
    
    func getCreditCardsList() {
        CreditCardsService.getCreditCards { [weak self] results in
            guard let self = self else { return }
            switch results {
            case let .success(success):
                switch success {
                case let.success(response: responseModel):
                    self.creditCards = responseModel.data
                    self.delegate?.creditCardsListReceived()
                case let .validation(error: errorModel):
                    print(errorModel)
                }
            case let .failure(error):
                Popup.showError(body: error.localizedStrings)
            }
        }
    }
    
    func getBankAccountList() {
        iBankListService.getIBanList { [weak self] results in
            guard let self = self else { return }
            switch results {
            case let .success(success):
                switch success {
                case let .success(response: responseModel):
                    self.bankAccounts = responseModel.data
                    self.delegate?.bankAccountListReceived()
                case let .validation(error: errorModel):
                    print(errorModel)
                }
            case let .failure(error):
                Popup.showError(body: error.localizedStrings)
            }
        }
    }
    
    func addNewCreditCard(with number: String) {
        AddNewCreditCardService.addNewCreditCardRequest(request: .init(card: number)) { [weak self] results in
            guard let self = self else { return }
            switch results {
            case let .success(success):
                switch success {
                case .success(response: _):
                    self.getCreditCardsList()
                case let .validation(error: errorModel):
                    if let cardNumberError  = errorModel.errors.card {
                        Popup.showError(body: cardNumberError.createErrorMessage())
                    }
                }
            case let .failure(error):
                Popup.showError(body: error.localizedStrings)
            }
        }
    }
    
    func addNewBankAccount(with number: String) {
        AddNewBankAccountService.addNewBankAccountRequest(request: .init(iban: number)) { [weak self] results in
            guard let self = self else { return }
            switch results {
            case let .success(success):
                switch success {
                case .success(response: _):
                    self.getBankAccountList()
                case let .validation(error: errorModel):
                    if let bankAccountError  = errorModel.errors.iban {
                        Popup.showError(body: bankAccountError.createErrorMessage())
                    }
                }
            case let .failure(error):
                Popup.showError(body: error.localizedStrings)
            }
        }
    }
    
    func getProvinceList() {
        ProvinceListService.getProvinceList { [weak self] results in
            guard let self = self else { return }
            switch results {
            case let .success(response):
                switch response {
                case let .success(response: responseModel):
                    self.provinceList = responseModel.data
                    self.delegate?.provinceListReceived()
                case .validation(error: _):
                    print("it would be empty")
                }
            case let .failure(error):
                Popup.showError(body: error.localizedStrings)
            }
        }
    }
    
    func getStateList(with id: Int = 1) {
        CityListService.getCityList (request:.init(id: id )) { [weak self] results in
            guard let self = self else { return }
            switch results {
            case let .success(response):
                switch response {
                case let .success(response: responseModel):
                    self.cityList = responseModel.data
                    self.delegate?.cityListReceived()
                case let .validation(error: errorModel):
                    if let error = errorModel.errors.provinceID {
                        Popup.showError(body: error.createErrorMessage())
                    }
                }
            case let .failure(error):
                Popup.showError(body: error.localizedStrings)
            }
        }
    }
    
    func requestToVerifyAddress(userAddress: UserAddress) {
        Preloader.sharedInstance.startLoading()
        AddressInformationService.registerAddressInformation(request: .init(provinceID: userAddress.province_id, cityID: userAddress.city_id, address: userAddress.address, postalCode: userAddress.postal_code)) { [weak self] results in
            Preloader.sharedInstance.stopLoading()
            guard let self = self else { return }
            switch results {
            case let .success(response):
                switch response {
                case .success(response: _):
                    self.delegate?.addressRegisteredSuccessfully()
                case let .validation(error: errorModel):
                    var errorMessage = ""
                    if let address  = errorModel.errors.address {
                        errorMessage =  address.createErrorMessage() + "\n"
                    }
                    if let postalCode = errorModel.errors.postalCode {
                        errorMessage += postalCode.createErrorMessage()
                    }
                    Popup.showError(body: errorMessage)
                }
            case let .failure(error):
                Popup.showError(body: error.localizedStrings)
            }
            
        }
    }
}
