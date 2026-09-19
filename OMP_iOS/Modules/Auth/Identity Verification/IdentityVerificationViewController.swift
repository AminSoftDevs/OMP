//
//  IdentityVerificationViewController.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 8/7/21.
//

import UIKit

class IdentityVerificationViewController: BaseViewController {
        
    var addressVerified: Bool? = false {
        didSet {
            if identityVerificationInputView != nil {
                identityVerificationInputView!.addressVerified = addressVerified ?? false
            }
        }
    }
    
    var selectedImage: Data? {
        didSet {
            if identityVerificationInputView != nil {
                identityVerificationInputView!.selectedImage = selectedImage
            }
        }
    }
    
    var showPendingScreen: Bool = false {
        didSet {
            if identityVerificationInputView != nil {
                self.identityVerificationInputView!.showPendingScreen = showPendingScreen
            }
        }
    }
    
    private var nextViewType: IdentityVerificationInputType?
    private lazy var transparentView: UIView? = UIView()
    private lazy var identityVerificationInputView: IdentityVerificationInputView? = nil
    
    private lazy var identityVerificationNavBar: IdentityVerificationNavBar = {
        var navBar = IdentityVerificationNavBar()
        navBar.navigationMainTitle = viewModel.navigationTitle
        navBar.delegate = self
        return navBar
    }()
    
    private var imagePickerOptionView: ImagePickerOptionView?
    
    //MARK: - INITIALIZER
    private let viewModel: IdentityVerificationControllerViewModel
    
    init(viewModel: IdentityVerificationControllerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - VIEW CONTROLLER LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        changeStatusBarColor(color: .cardsColor)
        setBackgroundColor()
        createUI()
        
        viewModel.delegate = self
        
        viewModel.handleVerificationStep()
    }
    
    //MARK: - CREATE UI
    private func createUI() {
        addingNavigationBar()
    }
    
    private func addingNavigationBar() {
        view.addSubview(identityVerificationNavBar)
        identityVerificationNavBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            identityVerificationNavBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            identityVerificationNavBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            identityVerificationNavBar.widthAnchor.constraint(equalTo: view.widthAnchor),
            identityVerificationNavBar.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    private func addingIdentityVerificationInputView(type: IdentityVerificationInputType) {
        identityVerificationInputView = IdentityVerificationInputView(type: type, userInfo: viewModel.userInfo)
        identityVerificationInputView?.delegate = self
        view.addSubview(identityVerificationInputView!)
        identityVerificationInputView?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            identityVerificationInputView!.topAnchor.constraint(equalTo: identityVerificationNavBar.bottomAnchor, constant: 20),
            identityVerificationInputView!.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            identityVerificationInputView!.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
        
        if type == .identity || type == .waiting || type == .finalScreen {
            identityVerificationInputView!.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15).isActive = true
        } else if type == .bankInfo || type == .address || type == .identityVerification {
            identityVerificationInputView!.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        }
    }
    
    private func addingImagePickerViewOptions() {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        transparentView = UIView(frame: CGRect(x: 0, y: 0, width: (window.frame.width), height: (window.frame.height)))
        transparentView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapToDismissImagePickerOptions)))
        transparentView?.backgroundColor = .black.withAlphaComponent(0.6)
        window.addSubview(transparentView!)
        imagePickerOptionView = ImagePickerOptionView()
        imagePickerOptionView?.delegate = self
        transparentView!.addSubview(imagePickerOptionView!)
        imagePickerOptionView?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imagePickerOptionView!.topAnchor.constraint(equalTo: transparentView!.bottomAnchor),
            imagePickerOptionView!.centerXAnchor.constraint(equalTo: transparentView!.centerXAnchor),
            imagePickerOptionView!.widthAnchor.constraint(equalTo: transparentView!.widthAnchor),
            imagePickerOptionView!.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        UIView.animate(withDuration: 0.3) {
            self.imagePickerOptionView?.transform = CGAffineTransform(translationX: 0, y: -150)
        }
    }
    
    //MARK: - FUNCTIONS
    private func dismissCurrentView() {
        if identityVerificationInputView == nil || nextViewType == nil {
            return
        }
        UIView.animate(withDuration: 0.3) {
            self.identityVerificationInputView?.alpha = 0
        } completion: { _ in
            self.identityVerificationInputView?.removeFromSuperview()
            self.identityVerificationInputView = nil
            self.addingIdentityVerificationInputView(type: self.nextViewType!)
        }
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func dismissImagePickerOptions(completionHandler: @escaping () -> ()) {
        UIView.animate(withDuration: 0.3) {
            self.transparentView?.alpha = 0
            self.imagePickerOptionView?.transform = .identity
        } completion: { _ in
            self.transparentView?.removeFromSuperview()
            self.imagePickerOptionView?.removeFromSuperview()
            self.transparentView = nil
            self.imagePickerOptionView = nil
            completionHandler()
        }
    }
    
    //MARK: - OBJC FUNCTIONS
    @objc func tapToDismissImagePickerOptions() {
        self.dismissImagePickerOptions {}
    }
    
    //MARK: - API
    private func uploadNationalIdCardImageWithUserInformation(userInformation: UserIdentity) {
        guard let image = self.selectedImage else { return }
        utility.loader.startLoading()
        utility.network.uploadIdentityPhotoAPI(userInformation: userInformation, image: image) { status, error, msg in
            self.utility.loader.stopLoading()
            if !error {
                if status == .ok {
                    self.nextViewType = .waiting
                    self.dismissCurrentView()
                    self.selectedImage = nil
                } else {
                    self.utility.notification.show(title: "", body: msg, .error, "error", 2.0)
                }
            } else {
                self.utility.notification.show(title: "", body: msg, .error, "error", 2.0)
            }
        }
    }
    
    private func requestFinalIdentityVerification(with image: Data) {
        utility.loader.startLoading()
        utility.network.uploadSelfIdentityImageAPI(image: image) { status, error, msg in
            self.utility.loader.stopLoading()
            if !error {
                if status == .ok {
                    self.showPendingScreen = true
                    self.selectedImage = nil
                } else {
                    self.utility.notification.show(title: "", body: msg, .error, "error", 2.0)
                }
            } else {
                self.utility.notification.show(title: "", body: msg, .error, "error", 2.0)
            }
        }
    }
}

extension IdentityVerificationViewController: IdentityVerificationNavBarDelegate {
    func backButtonPressed() {
        navigationController?.popViewController(animated: true)
        identityVerificationInputView = nil
        selectedImage = nil
    }
}

extension IdentityVerificationViewController: IdentityVerificationInputViewDelegate {
    func finalIdentityVerificationRequest() {
        if selectedImage != nil {
            requestFinalIdentityVerification(with: selectedImage!)
        }
    }
    
    func checkLandlineVerificationCode(code: String) {
        viewModel.checkLandlineVerificationCodeAPI(with: code)
    }
    
    func addressToVerify(address: UserAddress) {
        viewModel.requestToVerifyAddress(userAddress: address)
    }
    
    func selectedProvince(with id: Int) {
        viewModel.getStateList(with: id)
    }
    
    func canLeaveCurrentState(type: IdentityVerificationInputType) {
        if type == .bankInfo {
            nextViewType = .identityVerification
            identityVerificationNavBar.step += 1
            identityVerificationNavBar.navigationTitle = "IdentityVerificationNavBar.identityConfirmation".localized
            dismissCurrentView()
            //nextViewType = .address
            //identityVerificationNavBar.step += 1
            //identityVerificationNavBar.navigationTitle = "IdentityVerificationNavBar.addressAndPhone".localized
            //dismissCurrentView()
            //self.cardList = nil
            //self.bankAccountList = nil
            viewModel.getProvinceList()
            viewModel.getStateList()
        } else if type == .address {
            nextViewType = .identityVerification
            identityVerificationNavBar.step += 1
            identityVerificationNavBar.navigationTitle = "IdentityVerificationNavBar.identityConfirmation".localized
            dismissCurrentView()
            //stateList = nil
            //provinceList = nil
            //landlineVerified = nil
            addressVerified = nil
        } else if type == .finalScreen {
            navigationController?.popViewController(animated: true)
            identityVerificationInputView = nil
        }
    }
    
    func requestLandlinePhoneVerificationCode(with number: String) {
        viewModel.landlinePhoneVerificationCodeRequest(number: number)
    }
    
    func addNewBankInfo(type: BankInformationType, number: String) {
        if type == .account {
            viewModel.addNewBankAccount(with: number)
        } else {
            viewModel.addNewCreditCard(with: number)
        }
    }
    
    func submitButtonOnIdentityInformationPressed(userInformation: UserIdentity) {
        uploadNationalIdCardImageWithUserInformation(userInformation: userInformation)
    }
    
    func selectImageButtonPressed() {
        addingImagePickerViewOptions()
    }
    
    func requestToResendVerificationCode() {
        if viewModel.mobileNumber != nil {
            viewModel.mobileVerificationCodeRequest(with: viewModel.mobileNumber!, firstTime: false)
        }
    }
    
    func userDecidedToEditMobileNumber() {
        nextViewType = .mobile
        dismissCurrentView()
    }
    
    func submitButtonPressed(input: String, type: IdentityVerificationInputType) {
        switch type {
        case .email:
            viewModel.emailVerificationCodeRequest()
        case .emailCode:
            viewModel.checkEmailVerificationCode(with: input)
        case .mobile:
            viewModel.mobileVerificationCodeRequest(with: input, firstTime: true)
            viewModel.mobileNumber = input
        case .mobileCode:
            viewModel.checkMobileVerificationCode(with: input)
        default:
            break
        }
    }
}

extension IdentityVerificationViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.editedImage] as? UIImage {
            let data = pickedImage.jpegData(compressionQuality: 0.9)
            selectedImage = data
        } else if let pickedImage = info[.originalImage] as? UIImage {
            let data = pickedImage.jpegData(compressionQuality: 0.9)
            selectedImage = data
        }
        picker.dismiss(animated: true, completion: nil)
    }
}


extension IdentityVerificationViewController: ImagePickerOptionDelegate {
    func openImagePickingSource(type: ImagePickerOptionType) {
        dismissImagePickerOptions {
            if type == .camera {
                self.openCamera()
            } else  {
                self.openGallery()
            }
        }
    }
}

//MARK: - MAKE INSTANCE
extension IdentityVerificationViewController {
    static func makeInstance(userInfo: UserInfo?) -> IdentityVerificationViewController {
        .init(viewModel: IdentityVerificationControllerViewModel(userInfo: userInfo))
    }
}

//MARK: - VIEW MODEL DELEGATE
extension IdentityVerificationViewController: IdentityVerificationControllerViewModelProtocol {
    func addressRegisteredSuccessfully() {
        addressVerified = true
    }
    
    func landlinePhoneVerified() {
        identityVerificationInputView!.landlineVerified = viewModel.getLandLineVerificationStatus
    }
    
    func mobileVerified() {
        nextViewType = viewModel.getNextViewType
        identityVerificationNavBar.step = viewModel.currentStep
        identityVerificationNavBar.navigationTitle = viewModel.identityVerificationNavTitle
        dismissCurrentView()
    }
    
    func mobileVerificationCodeRequestSent() {
        nextViewType = viewModel.getNextViewType
        dismissCurrentView()
    }
    
    func emailAddressVerified() {
        nextViewType = viewModel.getNextViewType
        identityVerificationNavBar.step = viewModel.currentStep
        identityVerificationNavBar.navigationTitle = viewModel.mobileVerificationNavTitle
        dismissCurrentView()
    }
    
    func requestForEmailVerificationCodeSentSuccessfully() {
        nextViewType = viewModel.getNextViewType
        dismissCurrentView()
    }
    
    func stopLoadingButton() {
        identityVerificationInputView?.stopLoadingButton = true
    }
    
    func cityListReceived() {
        identityVerificationInputView?.stateList = viewModel.getCityList
    }
    
    func provinceListReceived() {
        identityVerificationInputView?.provinceList = viewModel.getProvinces
    }
    
    func whichStepOfIdentityVerification(identityVerificationInputType: IdentityVerificationInputType, step: Int, navTitle: String) {
        addingIdentityVerificationInputView(type: identityVerificationInputType)
        identityVerificationNavBar.step = step
        identityVerificationNavBar.navigationTitle = navTitle
    }
    
    func bankAccountListReceived() {
        identityVerificationInputView?.bankAccountList = viewModel.getBankAccounts
    }
    
    func creditCardsListReceived() {
        identityVerificationInputView?.cardList = viewModel.getCreditCards
    }
}
