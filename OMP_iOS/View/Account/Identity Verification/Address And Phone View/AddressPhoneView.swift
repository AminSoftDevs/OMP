//
//  AddressPhoneView.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 8/15/21.
//

import UIKit

protocol AddressPhoneViewDelegate: AnyObject {
    func addressViewContinueButtonPressed()
    func requestForLandLineVerificationCode(with number: String)
    func selectedProvince(with id: Int)
    func addressToVerify(address: UserAddress)
    func checkLandlineVerificationCode(code: String)
}

class AddressPhoneView: UIView {
    
    var addressVerified: Bool = false {
        didSet {
            self.addressVerificationView.showPendingMode()
        }
    }
    
    var landlineVerified: Bool = false {
        didSet {
            if landlineVerified == true {
                self.landlinePhoneView.showPendingMode()
            } else {
                self.landlinePhoneView.stopLoader()
            }
        }
    }
    
    var provinceList: [Province] = [] {
        didSet {
            self.addressVerificationView.provinceList = provinceList
        }
    }
    
    var stateList: [City] = [] {
        didSet {
            self.addressVerificationView.stateList = stateList
        }
    }
    
    let utility = BaseModule.sharedInstance
    let userInfo: UserInfo?
    var addressViewHeight = NSLayoutConstraint()
    var landlineViewHeight = NSLayoutConstraint()
    
    lazy var mainScrollView: UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    lazy var continueButton: UIButton = {
       var button = UIButton()
        button.configure(fontSize: 12, title: "continue".localized, fontType: .regular, titleColor: .backgroundColor, backgroundColor: .submitButtonColor, borderColor: .clear, cornerRadius: 10)
        button.addTarget(self, action: #selector(continueButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var addressVerificationView: AddressVerificationView = {
        var view = AddressVerificationView(verificationState: userInfo?.addressVerified ?? .rejected)
        view.delegate = self
        return view
    }()
    
    lazy var landlinePhoneView: LandlinePhoneView = {
       var view = LandlinePhoneView(verified: userInfo?.landlinePhoneVerified == .accepted)
        view.delegate = self
        return view
    }()
    
    weak var delegate: AddressPhoneViewDelegate?
    
    //MARK: - INITIALIZER
    init(userInfo: UserInfo?) {
        self.userInfo = userInfo
        super.init(frame: .zero)
        self.createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - CREATE UI
    fileprivate func createUI() {
        self.addingMainScrollView()
        self.addingAddressVerificationView()
        self.addingLandlinePhoneView()
        self.addingContinueButton()
        self.mainScrollView.contentSize.height = 800
    }
    
    fileprivate func addingMainScrollView() {
        self.addSubview(mainScrollView)
        self.mainScrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: mainScrollView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: mainScrollView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: mainScrollView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: mainScrollView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    }
    
    fileprivate func addingAddressVerificationView() {
        self.mainScrollView.addSubview(addressVerificationView)
        self.addressVerificationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: addressVerificationView, attribute: .top, relatedBy: .equal, toItem: mainScrollView, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: addressVerificationView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: addressVerificationView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        addressViewHeight = NSLayoutConstraint(item: addressVerificationView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 480)
        addressViewHeight.isActive = true
    }
    
    fileprivate func addingLandlinePhoneView() {
        self.mainScrollView.addSubview(landlinePhoneView)
        self.landlinePhoneView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: landlinePhoneView, attribute: .top, relatedBy: .equal, toItem: addressVerificationView, attribute: .bottom, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: landlinePhoneView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: landlinePhoneView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        landlineViewHeight = NSLayoutConstraint(item: landlinePhoneView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 200)
        landlineViewHeight.isActive = true
    }
    
    fileprivate func addingContinueButton() {
        self.mainScrollView.addSubview(continueButton)
        self.continueButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: continueButton, attribute: .top, relatedBy: .equal, toItem: landlinePhoneView, attribute: .bottom, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: continueButton, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 30).isActive = true
        NSLayoutConstraint(item: continueButton, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -30).isActive = true
        NSLayoutConstraint(item: continueButton, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 50).isActive = true
    }
    //MARK: - OBJC FUNCTIONS
    @objc func continueButtonPressed() {
        guard let addressVerification = self.userInfo, addressVerification.addressVerified != .pending else {
            utility.notification.show(title: "", body: "AddressPhoneView.waitForAddressVerification".localized, .error, "error", 2.0)
            return
        }
        guard let addressVerification = self.userInfo, addressVerification.addressVerified == .accepted else {
            utility.notification.show(title: "", body: "AddressPhoneView.addressVerificationNotComplete".localized, .error, "error", 2.0)
            return
        }
        
        guard let landlinePhone = self.userInfo, landlinePhone.landlinePhoneVerified == .accepted else {
            utility.notification.show(title: "", body: "AddressPhoneView.landlineVerificationNotComplete".localized, .error, "error", 2.0)
            return
        }
        
        self.delegate?.addressViewContinueButtonPressed()
    }
    
}

extension AddressPhoneView: LandlinePhoneViewDelegate {
    func checkLandlineVerificationCode(code: String) {
        self.delegate?.checkLandlineVerificationCode(code: code)
    }
    
    func backToEditLandlineNumber() {
        UIView.animate(withDuration: 0.4) {
            self.landlineViewHeight.constant = 200
            self.mainScrollView.contentSize.height -= 40
            self.layoutIfNeeded()
        }
    }
    
    func requestLandlineVerificationCode(with number: String) {
        self.delegate?.requestForLandLineVerificationCode(with: number)
        UIView.animate(withDuration: 0.4) {
            self.landlineViewHeight.constant = 240
            self.mainScrollView.contentSize.height += 40
            self.layoutIfNeeded()
        }
    }
}

extension AddressPhoneView: AddressVerificationViewDelegate {
    func addressToVerify(address: UserAddress) {
        self.delegate?.addressToVerify(address: address)
    }
    
    func selectedProvince(with id: Int) {
        self.delegate?.selectedProvince(with: id)
    }
}
