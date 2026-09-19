//
//  SelfIdentityVerification.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 8/17/21.
//

import UIKit

protocol SelfIdentityVerificationViewDelegate: AnyObject {
    func identityImagePickerButtonPressed()
    func requestToVerifyUser()
}

class SelfIdentityVerificationView: UIView {
    
    var showPendingScreen: Bool = false {
        didSet {
            self.successLabel.text = "SelfIdentityVerificationView.waitVerification".localized
            self.successLabel.textColor = .rejectOrangeColor
            self.checkBoxImageView.image = UIImage(named: "wating_icon")?.withRenderingMode(.alwaysTemplate)
            self.checkBoxImageView.tintColor = .rejectOrangeColor
            self.addingVerifiedScreen()
            self.addingRecoveryEmailSentSuccessfullyState()
        }
    }
    
    var selectedImage: Data? {
        didSet {
            self.updateUI()
        }
    }
    
    let utility = BaseModule.sharedInstance
    
    var selectedImageViewHeight = NSLayoutConstraint()
    var selectedImageViewTop = NSLayoutConstraint()
    var containerViewHeight = NSLayoutConstraint()
    
    lazy var mainScrollView: UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    lazy var containerView: UIView = {
       var view = UIView()
        view.backgroundColor = .cardsColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var exampleImageView: UIImageView = {
       var imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.image = UIImage(named: "identity_example")
        return imageView
    }()
    
    lazy var selectedImageView: UIImageView = {
       var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    lazy var upload‌SelfIdentityImageButton: UIButton = {
        var button = UIButton()
        button.configure(fontSize: 14, title: "SelfIdentityVerificationView.identityImagePickerTitle".localized, fontType: .regular, titleColor: .submitGreenColor, backgroundColor: .backgroundColor, borderColor: .submitGreenColor, cornerRadius: 10)
        button.setImage(UIImage(named: "logout_icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .submitGreenColor
        button.imageView?.transform = CGAffineTransform(rotationAngle: -.pi / 2)
        button.semanticContentAttribute = .forceRightToLeft
        button.imageEdgeInsets = .init(top: -4, left: 15, bottom: 4, right: -15)
        button.addTarget(self, action: #selector(selectImageButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var continueButton: UIButton = {
       var button = UIButton()
        button.configure(fontSize: 12, title: "continue".localized, fontType: .regular, titleColor: .backgroundColor, backgroundColor: .submitButtonColor, borderColor: .clear, cornerRadius: 10)
        button.addTarget(self, action: #selector(continueButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var instructionTextView: UITextView = {
        var textView = UITextView()
        textView.text = "SelfIdentityVerificationView.instructionText".localized
        textView.backgroundColor = .clear
        textView.textColor = .textColor
        textView.textAlignment = .right
        textView.font = UIFont(type: .regular, fontSize: 14)
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
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
    
    let userInfo: UserInfo?
    weak var delegate: SelfIdentityVerificationViewDelegate?
    
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
        self.addingContainerView()
        self.addingExampleImageView()
        self.addingSelectedImage()
        self.addingUploadImageButton()
        self.addingInstructionTextView()
        self.addingContinueButton()
        
        if userInfo?.identityVerified == .pending {
            self.successLabel.text = "SelfIdentityVerificationView.waitVerification".localized
            self.successLabel.textColor = .rejectOrangeColor
            self.checkBoxImageView.image = UIImage(named: "wating_icon")?.withRenderingMode(.alwaysTemplate)
            self.checkBoxImageView.tintColor = .rejectOrangeColor
            self.addingVerifiedScreen()
            self.addingRecoveryEmailSentSuccessfullyState()
        }
    }
    
    fileprivate func addingMainScrollView() {
        self.addSubview(mainScrollView)
        self.mainScrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: mainScrollView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: mainScrollView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: mainScrollView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: mainScrollView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    }
    
    fileprivate func addingContainerView() {
        self.mainScrollView.addSubview(containerView)
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: containerView, attribute: .top, relatedBy: .equal, toItem: mainScrollView, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: containerView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: containerView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        
        let sizeThatFitsTextView = instructionTextView.sizeThatFits(CGSize(width: Constants.screenWidth - 10, height: CGFloat(MAXFLOAT)))
        containerViewHeight = NSLayoutConstraint(item: containerView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 320 + sizeThatFitsTextView.height)
        containerViewHeight.isActive = true
        self.mainScrollView.contentSize.height = 320 + sizeThatFitsTextView.height + 80
    }
    
    fileprivate func addingExampleImageView() {
        self.containerView.addSubview(exampleImageView)
        self.exampleImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: exampleImageView, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: exampleImageView, attribute: .trailing, relatedBy: .equal, toItem: containerView, attribute: .trailing, multiplier: 1, constant: -15).isActive = true
        NSLayoutConstraint(item: exampleImageView, attribute: .leading, relatedBy: .equal, toItem: containerView, attribute: .leading, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: exampleImageView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 200).isActive = true
    }
    
    fileprivate func addingSelectedImage() {
        self.containerView.addSubview(selectedImageView)
        self.selectedImageView.translatesAutoresizingMaskIntoConstraints = false
        selectedImageViewTop = NSLayoutConstraint(item: selectedImageView, attribute: .top, relatedBy: .equal, toItem: exampleImageView, attribute: .bottom, multiplier: 1, constant: 0)
        selectedImageViewTop.isActive = true
        NSLayoutConstraint(item: selectedImageView, attribute: .trailing, relatedBy: .equal, toItem: containerView, attribute: .trailing, multiplier: 1, constant: -15).isActive = true
        NSLayoutConstraint(item: selectedImageView, attribute: .leading, relatedBy: .equal, toItem: containerView, attribute: .leading, multiplier: 1, constant: 15).isActive = true
        selectedImageViewHeight =  NSLayoutConstraint(item: selectedImageView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 0)
        selectedImageViewHeight.isActive = true
    }
    
    fileprivate func addingUploadImageButton() {
        self.containerView.addSubview(upload‌SelfIdentityImageButton)
        self.upload‌SelfIdentityImageButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: upload‌SelfIdentityImageButton, attribute: .top, relatedBy: .equal, toItem: selectedImageView, attribute: .bottom, multiplier: 1, constant: 25).isActive = true
        NSLayoutConstraint(item: upload‌SelfIdentityImageButton, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -15).isActive = true
        NSLayoutConstraint(item: upload‌SelfIdentityImageButton, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: upload‌SelfIdentityImageButton, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 50).isActive = true
    }
    
    fileprivate func addingInstructionTextView() {
        self.containerView.addSubview(instructionTextView)
        self.instructionTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: instructionTextView, attribute: .top, relatedBy: .equal, toItem: upload‌SelfIdentityImageButton, attribute: .bottom, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: instructionTextView, attribute: .trailing, relatedBy: .equal, toItem: containerView, attribute: .trailing, multiplier: 1, constant: -5).isActive = true
        NSLayoutConstraint(item: instructionTextView, attribute: .leading, relatedBy: .equal, toItem: containerView, attribute: .leading, multiplier: 1, constant: 5).isActive = true
        NSLayoutConstraint(item: instructionTextView, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1, constant: -10).isActive = true
    }
    
    fileprivate func addingContinueButton() {
        self.mainScrollView.addSubview(continueButton)
        self.continueButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: continueButton, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: continueButton, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 30).isActive = true
        NSLayoutConstraint(item: continueButton, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -30).isActive = true
        NSLayoutConstraint(item: continueButton, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 50).isActive = true
    }
    
    fileprivate func addingVerifiedScreen() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0.8
        self.addSubview(blurEffectView)
    }
    
    fileprivate func addingRecoveryEmailSentSuccessfullyState() {
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
    
    //MARK: - OBJC FUNCTIONS
    @objc func continueButtonPressed() {
        guard selectedImage != nil else {
            utility.notification.show(title: "", body: "SelfIdentityVerificationView.selfiRequired".localized, .error, "error", 2.0)
            return
        }
        self.delegate?.requestToVerifyUser()
    }
    
    @objc func selectImageButtonPressed() {
        self.delegate?.identityImagePickerButtonPressed()
    }
    
    //MARK: - UPDATE UI
    fileprivate func updateUI() {
        if selectedImage == nil {
            return
        }
        UIView.animate(withDuration: 0.2) {
            self.selectedImageView.alpha = 1
            self.selectedImageViewTop.constant = 25
            self.selectedImageViewHeight.constant = 200
            self.mainScrollView.contentSize.height += 225
            self.containerViewHeight.constant += 225
            self.layoutIfNeeded()
        } completion: { _ in
            self.selectedImageView.image = UIImage(data: self.selectedImage!)
        }
    }
    
}

