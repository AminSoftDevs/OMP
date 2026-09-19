//
//  IdentityInformationView.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 8/11/21.
//

import UIKit
import MHLoadingButton
import DropDown

protocol IdentityInformationViewDelegate: AnyObject {
    func selectImageButtonPressed()
    func submitButtonPressedWithIdentityInformation(with information: UserIdentity)
}

class IdentityInformationView: UIView {
    
    var identityCardImage: Data? {
        didSet {
            self.updateUI()
        }
    }
    
    let utility = BaseModule.sharedInstance
    
    var nationalId: String?
    var bornDay: String?
    var bornMonth: String?
    var bornYear: String?
    var fullBirthday: String?
    
    var selectedImageViewHeight = NSLayoutConstraint()
    var selectedImageViewTop = NSLayoutConstraint()
    
    let days: [String] = Array(1...31).map {String($0)}
    let years: [String] = Array(1330...1377).map {String($0)}
    
    let persianMonth: [String] = {
        var identifier: Calendar.Identifier = .persian
        var manualLocale: String = "fa_IR"
        switch Localization.sharedInstance.getLanguage() {
        case "ar":
            identifier = .islamic
            manualLocale = "ar"
        case "fa-IR":
            identifier = .persian
            manualLocale = "fa_IR"
        default:
            identifier = .gregorian
            manualLocale = "en-us"
        }
        var calendar = Calendar(identifier: identifier)
        calendar.locale = Locale(identifier: manualLocale)
        return calendar.monthSymbols
    }()
    
    lazy var mainScrollView: UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    lazy var headerTitleLabel: UILabel = {
        var label = UILabel()
        label.configure(text: "IdentityInformationView.headerTitle".localized, fontSize: 15, textColor: .mediumGrayColor, textAlignment: .center, fontType: .regular)
        return label
    }()
    
    lazy var birthDayTitleLabel: UILabel = {
        var label = UILabel()
        label.configure(text: "IdentityInformationView.birthdayTitle".localized, fontSize: 14, textColor: .textColor, textAlignment: .right, fontType: .regular)
        return label
    }()
    
    lazy var dateStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    lazy var selectedImageView: UIImageView = {
       var imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.mediumGrayColor.cgColor
        return imageView
    }()
    
    lazy var uploadIdCardButton: UIButton = {
        var button = UIButton()
        button.configure(fontSize: 14, title: "IdentityInformationView.uploadYourIdCard".localized, fontType: .regular, titleColor: .submitGreenColor, backgroundColor: .backgroundColor, borderColor: .submitGreenColor, cornerRadius: 10)
        button.setImage(UIImage(named: "logout_icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .submitGreenColor
        button.imageView?.transform = CGAffineTransform(rotationAngle: -.pi / 2)
        button.semanticContentAttribute = .forceRightToLeft
        button.imageEdgeInsets = .init(top: -4, left: 15, bottom: 4, right: -15)
        button.addTarget(self, action: #selector(selectImageButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var submitButton: LoadingButton = {
        var button = LoadingButton()
        button.configure(fontSize: 12, title: "IdentityInformationView.continue".localized, fontType: .regular, titleColor: .backgroundColor, backgroundColor: .submitButtonColor, borderColor: .clear, cornerRadius: 10)
        button.addTarget(self, action: #selector(submitButtonPressed), for: .touchUpInside)
        button.indicator = BallPulseSyncIndicator(color: .gray)
        button.cornerRadius  = 10
        button.bgColor = .submitButtonColor
        button.indicator.color = .cardsColor
        return button
    }()
    
    lazy var dateDropDown: DropDown = {
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
    
    var birthdayButtonsList: [UIButton] = []
    
    lazy var nationalCodeView: UserInputView = UserInputView()
    
    weak var delegate: IdentityInformationViewDelegate?
    
    //MARK: - DEFAULT INITIALIZER
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .cardsColor
        self.layer.cornerRadius = 10
        self.createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - CREATE UI
    fileprivate func createUI() {
        addingMainScrollView()
        addingHeaderTitleLabel()
        addingNationalCodeView()
        addingDateSectionTitleLabel()
        addingDateStackView()
        birthdayConfig()
        addingSelectedImage()
        addingUploadImageButton()
        addingSubmitButton()
    }
    
    fileprivate func addingMainScrollView() {
        self.addSubview(mainScrollView)
        self.mainScrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: mainScrollView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: mainScrollView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: mainScrollView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: mainScrollView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -10).isActive = true
    }
    
    fileprivate func addingHeaderTitleLabel() {
        self.mainScrollView.addSubview(headerTitleLabel)
        self.headerTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: headerTitleLabel, attribute: .top, relatedBy: .equal, toItem: mainScrollView, attribute: .top, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: headerTitleLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    }
    
    fileprivate func addingNationalCodeView() {
        self.mainScrollView.addSubview(nationalCodeView)
        self.nationalCodeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: nationalCodeView, attribute: .top, relatedBy: .equal, toItem: headerTitleLabel, attribute: .bottom, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: nationalCodeView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 25).isActive = true
        NSLayoutConstraint(item: nationalCodeView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -25).isActive = true
        NSLayoutConstraint(item: nationalCodeView, attribute: .height, relatedBy: .equal, toItem: mainScrollView, attribute: .height, multiplier: 0, constant: 90).isActive = true
        
        self.nationalCodeView.type = .nationalId
        self.nationalCodeView.delegate = self
    }
    
    fileprivate func addingDateSectionTitleLabel() {
        self.mainScrollView.addSubview(birthDayTitleLabel)
        self.birthDayTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: birthDayTitleLabel, attribute: .top, relatedBy: .equal, toItem: nationalCodeView, attribute: .bottom, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: birthDayTitleLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 25).isActive = true
        NSLayoutConstraint(item: birthDayTitleLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -25).isActive = true
    }
    
    fileprivate func addingDateStackView() {
        self.mainScrollView.addSubview(dateStackView)
        self.dateStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: dateStackView, attribute: .top, relatedBy: .equal, toItem: birthDayTitleLabel, attribute: .bottom, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: dateStackView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 25).isActive = true
        NSLayoutConstraint(item: dateStackView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -25).isActive = true
        NSLayoutConstraint(item: dateStackView, attribute: .height, relatedBy: .equal, toItem: mainScrollView, attribute: .height, multiplier: 0, constant: 50).isActive = true
    }
    
    fileprivate func birthdayConfig() {
        let buttonTitle = ["IdentityInformationView.year".localized, "IdentityInformationView.month".localized, "IdentityInformationView.day".localized, ]
        
        for (index,item) in buttonTitle.enumerated() {
            let button = UIButton()
            button.configure(fontSize: 12, title: item, fontType: .regular, titleColor: .textColor, backgroundColor: .backgroundColor, borderColor: .clear, cornerRadius: 10)
            //button.setImage(UIImage(named: "arrow_down_icon"), for: .normal)
            //button.titleEdgeInsets = .init(top: 1, left: -8, bottom: -1, right: 8)
            //button.imageEdgeInsets = .init(top: 0, left: 5, bottom: 0, right: -5)
            button.contentHorizontalAlignment = .center
            button.imageView?.contentMode = .center
            button.addTarget(self, action: #selector(birthdayButtonTapped), for: .touchUpInside)
            button.tag = index + 100
            dateStackView.addArrangedSubview(button)
            birthdayButtonsList.append(button)
            
        }
    }
    
    fileprivate func addingSelectedImage() {
        self.addSubview(selectedImageView)
        self.selectedImageView.translatesAutoresizingMaskIntoConstraints = false
        selectedImageViewTop = NSLayoutConstraint(item: selectedImageView, attribute: .top, relatedBy: .equal, toItem: dateStackView, attribute: .bottom, multiplier: 1, constant: 0)
        selectedImageViewTop.isActive = true
        NSLayoutConstraint(item: selectedImageView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -25).isActive = true
        NSLayoutConstraint(item: selectedImageView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 25).isActive = true
        selectedImageViewHeight =  NSLayoutConstraint(item: selectedImageView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 0)
        selectedImageViewHeight.isActive = true
    }
    
    fileprivate func addingUploadImageButton() {
        self.mainScrollView.addSubview(uploadIdCardButton)
        self.uploadIdCardButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: uploadIdCardButton, attribute: .top, relatedBy: .equal, toItem: selectedImageView, attribute: .bottom, multiplier: 1, constant: 25).isActive = true
        NSLayoutConstraint(item: uploadIdCardButton, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -25).isActive = true
        NSLayoutConstraint(item: uploadIdCardButton, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 25).isActive = true
        NSLayoutConstraint(item: uploadIdCardButton, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 50).isActive = true
    }
    
    fileprivate func addingSubmitButton() {
        self.mainScrollView.addSubview(submitButton)
        self.submitButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: submitButton, attribute: .top, relatedBy: .equal, toItem: uploadIdCardButton, attribute: .bottom, multiplier: 1, constant: 25).isActive = true
        NSLayoutConstraint(item: submitButton, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -25).isActive = true
        NSLayoutConstraint(item: submitButton, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 25).isActive = true
        NSLayoutConstraint(item: submitButton, attribute: .bottom, relatedBy: .equal, toItem: mainScrollView, attribute: .bottom, multiplier: 1, constant: -10).isActive = true
        let height = NSLayoutConstraint(item: submitButton, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 50)
        height.priority = UILayoutPriority(750)
        height.isActive = true
        
    }
    
    fileprivate func addingDayDropDown(tag: Int) {
        
        let realTag = tag - 100
        switch realTag {
        case 0:
            dateDropDown.dataSource = years.map({ $0.convertEngNumToPersianNum()})
            dateDropDown.anchorView = birthdayButtonsList[realTag]
            dateDropDown.reloadAllComponents()
        case 1:
            dateDropDown.dataSource = persianMonth
            dateDropDown.anchorView = birthdayButtonsList[realTag]
            dateDropDown.reloadAllComponents()
        case 2:
            dateDropDown.dataSource = days.map({ $0.convertEngNumToPersianNum()})
            dateDropDown.anchorView = birthdayButtonsList[realTag]
            dateDropDown.reloadAllComponents()
        default:
            print("will never execute")
        }
        
        dateDropDown.cellNib = UINib(nibName: "DropDownCustomTableViewCell", bundle: nil)
        
        dateDropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? DropDownCustomTableViewCell else { return }
            
            if realTag == 0 {
                cell.optionLabel.textAlignment = .left
            } else {
                cell.optionLabel.textAlignment = .right
            }
            cell.optionLabel.text = item
        }
        
        dateDropDown.direction = .bottom
        dateDropDown.bottomOffset = CGPoint(x: 0, y:(dateDropDown.anchorView?.plainView.bounds.height)!)
        dateDropDown.show()
        
        dateDropDown.selectionAction = { (index, item) in
            self.birthdayButtonsList[realTag].setTitle(item, for: .normal)
            switch realTag {
            case 0:
                self.bornYear  = item.persianToEng()
            case 1:
                self.bornMonth = String(index + 1)
            case 2:
                self.bornDay = String(index + 1)
            default:
                print("will never execute")
            }
        }
    }
    
    //MARK: - FUNCTIONS
    fileprivate func isValidIranianNationalCode(input: String) -> Bool {
        guard input.count == 10 else { return false }
        var digits = input.map { Int(String($0)) }
        guard digits.count == 10 && digits.count == input.count else {
            return false
        }
        let check = digits[9]
        digits.removeLast()
        var temp = 10
        var sum = 0
        for item in digits {
            sum += item! * temp
            temp -= 1
        }
        sum = sum % 11
        return sum < 2 ? check == sum : check! + sum == 11
    }
    
    fileprivate func getValidBirthday(year: String?, month: String?, day: String?) -> String? {
        guard let day = day, !day.isEmpty else {
            utility.notification.show(title: "", body: "IdentityInformationView.bornDay".localized, .error, "error", 2.0)
            return nil
        }
        
        guard let month = month, !month.isEmpty else {
            utility.notification.show(title: "", body: "IdentityInformationView.bornMonth".localized, .error, "error", 2.0)
            return nil
        }
        
        guard let year = year, !year.isEmpty else {
            utility.notification.show(title: "", body: "IdentityInformationView.bornYear".localized, .error, "error", 2.0)
            return nil
        }
        
        let fullDateString = "\(year)-\(month)-\(day)"
        let date = fullDateString.stringToDate(identifier: .persian)
        
        return date?.dateToString()
    }
    
    fileprivate func validateUserInputs() -> Bool {
        guard let nationalId = self.nationalId, !nationalId.isEmpty else {
            utility.notification.show(title: "", body: "IdentityInformationView.nationalCodeEmpty".localized, .error, "error", 2.0)
            return false
        }
        
        if !isValidIranianNationalCode(input: nationalId.persianToEng()) {
            utility.notification.show(title: "", body: "IdentityInformationView.nationalCodeNotValid".localized, .error, "error", 2.0)
            return false
        }
        return true
    }
    
    //MARK: - OBJC FUNCTIONS
    @objc func submitButtonPressed() {
        self.endEditing(true)
        if validateUserInputs() == false {
            return
        }
        
        if let birthday = getValidBirthday(year: bornYear, month: bornMonth, day: bornDay) {
            let userInformation = UserIdentity(nationalId: self.nationalId!.persianToEng(), birthDay: birthday)
            delegate?.submitButtonPressedWithIdentityInformation(with: userInformation)
        }
        
        if identityCardImage == nil {
            utility.notification.show(title: "", body: "IdentityInformationView.selectIdentityCardImage".localized, .error, "error", 2.0)
            return
        }
    }
    
    @objc func birthdayButtonTapped(_ sender: UIButton) {
        self.endEditing(true)
        self.addingDayDropDown(tag: sender.tag)
    }
    
    @objc func selectImageButtonPressed() {
        delegate?.selectImageButtonPressed()
    }
    
    //MARK: - UPDATE UI
    fileprivate func updateUI() {
        if identityCardImage == nil {
            return
        }
        UIView.animate(withDuration: 0.2) {
            self.selectedImageView.alpha = 1
            self.selectedImageViewTop.constant = 25
            self.selectedImageViewHeight.constant = 200
        } completion: { _ in
            self.selectedImageView.image = UIImage(data: self.identityCardImage!)
        }
    }
}

extension IdentityInformationView: UserInputViewDelegate {
    func userInput(input: String, type: UserInputType) {
        switch type {
        case .nationalId:
            self.nationalId = input
        default:
            print("not here")
        }
    }
}
