//
//  AddressVerificationView.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 8/15/21.
//

import UIKit
import DropDown
import MHLoadingButton

protocol AddressVerificationViewDelegate: AnyObject {
    func selectedProvince(with id: Int)
    func addressToVerify(address: UserAddress)
}

class AddressVerificationView: UIView {
    
    var provinceList: [Province] = [] {
        didSet {
            self.provinceSelectionButton.hideLoader()
        }
    }
    
    var stateList: [City] = [] {
        didSet {
            self.stateSelectionButton.hideLoader()
        }
    }
    
    let utility = BaseModule.sharedInstance
    
    var address: String?
    var state: Int?
    var province: Int?
    var postalCode: String?
    
    
    private lazy var postalCodeView: UserInputView = UserInputView()
    
    lazy var mainStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    lazy var provinceStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = -10
        return stackView
    }()
    
    lazy var stateStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = -10
        return stackView
    }()
    
    lazy var addressStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 0
        return stackView
    }()
    
    lazy var stateButtonTitleLabel: PaddingLabel = {
        var label = PaddingLabel()
        label.configure(text: "AddressVerificationView.stateTitle".localized, fontSize: 14, textColor: .textColor, textAlignment: .right, fontType: .regular)
        return label
    }()
    
    lazy var stateSelectionButton: LoadingButton = {
        var button = LoadingButton()
        button.configure(fontSize: 14, title: "chooseOne".localized, fontType: .regular, titleColor: .textColor, backgroundColor: .backgroundColor, borderColor: .clear, cornerRadius: 10)
        button.set(image: UIImage(named: "arrow_down_icon"), title: "chooseOne".localized, titlePosition: .right, additionalSpacing: 60, state: .normal)
        button.addTarget(self, action: #selector(stateSelectionButtonPressed), for: .touchUpInside)
        button.indicator = BallPulseSyncIndicator(color: .mediumGrayColor)
        button.cornerRadius  = 10
        button.bgColor = .backgroundColor
        button.indicator.color = .mediumGrayColor
        return button
    }()
    
    lazy var provinceButtonTitleLabel: PaddingLabel = {
        var label = PaddingLabel()
        label.configure(text: "AddressVerificationView.provinceTitle".localized, fontSize: 14, textColor: .textColor, textAlignment: .right, fontType: .regular)
        return label
    }()
    
    lazy var provinceSelectionButton: LoadingButton = {
        var button = LoadingButton()
        button.configure(fontSize: 14, title: "chooseOne".localized, fontType: .regular, titleColor: .textColor, backgroundColor: .backgroundColor, borderColor: .clear, cornerRadius: 10)
        button.set(image: UIImage(named: "arrow_down_icon"), title: "chooseOne".localized, titlePosition: .right, additionalSpacing: 60, state: .normal)
        button.addTarget(self, action: #selector(provinceSelectionButtonPressed), for: .touchUpInside)
        button.indicator = BallPulseSyncIndicator(color: .mediumGrayColor)
        button.cornerRadius  = 10
        button.bgColor = .backgroundColor
        button.indicator.color = .mediumGrayColor
        return button
    }()
    
    lazy var addressTitleLabel: PaddingLabel = {
        var label = PaddingLabel()
        label.configure(text: "AddressVerificationView.addressTitle".localized, fontSize: 14, textColor: .textColor, textAlignment: .right, fontType: .regular)
        return label
    }()
    
    lazy var addressTextView: UITextView = {
        var textView = UITextView()
        textView.backgroundColor = .backgroundColor
        textView.textColor = .textColor
        textView.autocorrectionType = .no
        textView.autocapitalizationType = .none
        textView.textAlignment = .right
        textView.layer.cornerRadius = 10
        textView.font = UIFont(type: .regular, fontSize: 14)
        textView.delegate = self
        textView.contentInset = .init(top: 5, left: 10, bottom: 5, right: 10)
        return textView
    }()

    private var saveButton: LoadingButton = {
        var button = LoadingButton()
        button.configure(fontSize: 12, title: "confirm".localized, fontType: .regular, titleColor: .backgroundColor, backgroundColor: .rejectOrangeColor, borderColor: .clear, cornerRadius: 15)
        button.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        button.indicator = BallPulseIndicator(color: .textColor)
        button.cornerRadius  = 15
        button.bgColor = .rejectOrangeColor
        button.indicator.color = .cardsColor
        return button
    }()
    
    lazy var dropDown: DropDown = {
        let view = DropDown()
        DropDown.appearance().backgroundColor = .cardsColor
        DropDown.appearance().textFont = UIFont(type: .regular, fontSize: 12)
        DropDown.appearance().textColor = .textColor
        DropDown.appearance().selectionBackgroundColor = .cardsColor
        DropDown.appearance().selectedTextColor = .textColor
        DropDown.appearance().layer.borderWidth = 1
        DropDown.appearance().layer.borderColor = UIColor.mediumGrayColor.cgColor
        return view
    }()
    
    lazy var checkBoxImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "success_checkBox_icon")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var successLabel: UILabel = {
        var label = UILabel()
        label.configure(text: "AddressVerificationView.success".localized, fontSize: 14, textColor: .init(hex: "55E0B3"), textAlignment: .center, fontType: .bold)
        return label
    }()
    
    weak var delegate: AddressVerificationViewDelegate?
    
    var acceptState: AcceptState
    
    //MARK: - INITIALIZER
    init(verificationState: AcceptState) {
        self.acceptState = verificationState
        super.init(frame: .zero)
        self.backgroundColor = .cardsColor
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.createUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - CREATE UI
    fileprivate func createUI() {
        self.provinceStackViewConfig()
        self.stateStackViewConfig()
        self.addingMainStackView()
        self.addingAddressStackView()
        self.addingPostalCodeView()
        self.addingSaveButton()
        
        if acceptState == .accepted {
            self.addingVerifiedScreen()
            self.addingSuccessfulCheckbox()
        } else if acceptState == .pending {
            self.successLabel.text = "AddressVerificationView.waitForAddressVerification".localized
            self.successLabel.textColor = .rejectOrangeColor
            self.checkBoxImageView.image = UIImage(named: "wating_icon")?.withRenderingMode(.alwaysTemplate)
            self.checkBoxImageView.tintColor = .rejectOrangeColor
            self.addingVerifiedScreen()
            self.addingSuccessfulCheckbox()
        }
    }
    
    fileprivate func addingMainStackView() {
        self.addSubview(mainStackView)
        self.mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: mainStackView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: mainStackView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: mainStackView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -15).isActive = true
        NSLayoutConstraint(item: mainStackView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 90).isActive = true
        
        self.mainStackView.addArrangedSubview(stateStackView)
        self.mainStackView.addArrangedSubview(provinceStackView)
    }
    
    fileprivate func provinceStackViewConfig() {
        provinceStackView.addArrangedSubview(provinceButtonTitleLabel)
        provinceStackView.addArrangedSubview(provinceSelectionButton)
    }
    
    fileprivate func stateStackViewConfig() {
        stateStackView.addArrangedSubview(stateButtonTitleLabel)
        stateStackView.addArrangedSubview(stateSelectionButton)
    }
    
    fileprivate func addingAddressStackView() {
        self.addSubview(addressStackView)
        self.addressStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: addressStackView, attribute: .top, relatedBy: .equal, toItem: mainStackView, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: addressStackView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: addressStackView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -15).isActive = true
        NSLayoutConstraint(item: addressStackView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 150).isActive = true
        
        self.addressStackView.addArrangedSubview(addressTitleLabel)
        self.addressStackView.addArrangedSubview(addressTextView)
    }
    
    fileprivate func addingPostalCodeView() {
        self.addSubview(postalCodeView)
        self.postalCodeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: postalCodeView, attribute: .top, relatedBy: .equal, toItem: addressStackView, attribute: .bottom, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: postalCodeView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: postalCodeView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -15).isActive = true
        NSLayoutConstraint(item: postalCodeView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 90).isActive = true
        
        self.postalCodeView.type = .postalCode
        self.postalCodeView.delegate = self
    }
        
    fileprivate func addingSaveButton() {
        self.addSubview(saveButton)
        self.saveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: saveButton, attribute: .top, relatedBy: .equal, toItem: postalCodeView, attribute: .bottom, multiplier: 1, constant: 25).isActive = true
        NSLayoutConstraint(item: saveButton, attribute: .centerX, relatedBy: .equal, toItem: postalCodeView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: saveButton, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0, constant: 100).isActive = true
        NSLayoutConstraint(item: saveButton, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 50).isActive = true
    }
    
    fileprivate func addingVerifiedScreen() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0.8
        self.addSubview(blurEffectView)
        self.saveButton.alpha = 0.6
    }
    
    fileprivate func addingSuccessfulCheckbox() {
        self.addSubview(checkBoxImageView)
        self.checkBoxImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: checkBoxImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: -30).isActive = true
        NSLayoutConstraint(item: checkBoxImageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: checkBoxImageView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0, constant: 40).isActive = true
        NSLayoutConstraint(item: checkBoxImageView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 40).isActive = true
        
        self.addSubview(successLabel)
        self.successLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: successLabel, attribute: .top, relatedBy: .equal, toItem: self.checkBoxImageView, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: successLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: successLabel, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: successLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 30).isActive = true
    }
    
    //MARK: - FUNCTIONS
    fileprivate func addingProvinceDropDown() {
        dropDown.dataSource = provinceList.map {$0.name}
        dropDown.anchorView = provinceSelectionButton
        dropDown.reloadAllComponents()
        
        dropDown.cellNib = UINib(nibName: "DropDownCustomTableViewCell", bundle: nil)
        
        dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? DropDownCustomTableViewCell else { return }
            
            cell.optionLabel.textAlignment = .right
            cell.optionLabel.text = item
        }
        
        dropDown.direction = .bottom
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        
        dropDown.selectionAction = { (index, item) in
            self.provinceSelectionButton.setTitle(item, for: .normal)
            self.province = self.provinceList[index].id
            self.delegate?.selectedProvince(with: self.provinceList[index].id)
            self.stateSelectionButton.showLoader(userInteraction: false)
        }
        self.dropDown.show()
    }
    
    fileprivate func addingStateDropDown() {
        dropDown.dataSource = stateList.map {$0.name}
        dropDown.anchorView = stateSelectionButton
        dropDown.reloadAllComponents()
        
        dropDown.cellNib = UINib(nibName: "DropDownCustomTableViewCell", bundle: nil)
        
        dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? DropDownCustomTableViewCell else { return }
            
            cell.optionLabel.textAlignment = .right
            cell.optionLabel.text = item
        }
        
        dropDown.direction = .bottom
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        
        dropDown.selectionAction = { (index, item) in
            self.stateSelectionButton.setTitle(item, for: .normal)
            self.state = self.stateList[index].id
        }
        self.dropDown.show()
    }
    //MARK: - OBJC FUNCTIONS
    @objc func stateSelectionButtonPressed() {
        self.addingStateDropDown()
    }
    
    @objc func provinceSelectionButtonPressed() {
        self.addingProvinceDropDown()
    }
    
    @objc func saveButtonPressed() {
        self.endEditing(true)
        guard let province = self.province else {
            utility.notification.show(title: "", body: "AddressVerificationView.provinceCheck".localized, .error, "error", 2.0)
            return
        }
        guard let state = self.state else {
            utility.notification.show(title: "", body: "AddressVerificationView.stateCheck".localized, .error, "error", 2.0)
            return
        }
        guard let address = self.address else {
            utility.notification.show(title: "", body: "AddressVerificationView.addressCheck".localized, .error, "error", 2.0)
            return
        }
        guard let postalCode = self.postalCode else {
            utility.notification.show(title: "", body: "AddressVerificationView.postalCodeCheck".localized, .error, "error", 2.0)
            return
        }
        
        let userAddress = UserAddress(province_id: String(province), city_id: String(state), address: address, postal_code: postalCode)
        self.delegate?.addressToVerify(address: userAddress)
    }
    
    //MARK: - FUNCTIONS
    func showPendingMode() {
        self.successLabel.text = "AddressVerificationView.waitForAddressVerification".localized
        self.successLabel.textColor = .rejectOrangeColor
        self.checkBoxImageView.image = UIImage(named: "wating_icon")?.withRenderingMode(.alwaysTemplate)
        self.checkBoxImageView.tintColor = .rejectOrangeColor
        self.addingVerifiedScreen()
        self.addingSuccessfulCheckbox()
    }    
}

extension AddressVerificationView: UserInputViewDelegate {
    func userInput(input: String, type: UserInputType) {
        if type == .postalCode {
            self.postalCode = input.persianToEng()
        }
    }
}

extension AddressVerificationView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.layer.borderWidth = 2
        textView.layer.borderColor = UIColor.submitButtonColor.cgColor
        textView.backgroundColor = .cardsColor
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.layer.borderWidth = 0
        textView.layer.borderColor = UIColor.clear.cgColor
        textView.backgroundColor = .backgroundColor
        self.address = textView.text
    }
}
