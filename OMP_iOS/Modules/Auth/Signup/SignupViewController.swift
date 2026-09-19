//
//  SignupViewController.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 7/31/21.
//

import UIKit

class SignupViewController: BaseViewController {
    
    var email: String?
    var password: String?
    var referralCode: String?
    var reCaptchaToken: String?
    
    lazy var mainScrollView: UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isScrollEnabled = false
        return scrollView
    }()
    
    var captchaVC: ReCAPTCHAViewController?
    
    lazy var signupView: SignupView = {
       var view = SignupView()
        view.delegate = self
        return view
    }()
    
    //MARK: - VIEW CONTROLLER LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackgroundColor(.cardsColor)
        self.addingMainScrollView()
        self.createUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.mainScrollView.contentSize = CGSize(width: view.frame.width, height: signupView.estimatedViewHeight + view.safeAreaInsets.top + view.safeAreaInsets.bottom)
    }
    
    //MARK: - CREATE UI
    fileprivate func createUI() {
        self.addingSignupView()
    }
    
    fileprivate func addingMainScrollView() {
        self.view.addSubview(mainScrollView)
        self.mainScrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: mainScrollView, attribute: .top, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: mainScrollView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: mainScrollView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: mainScrollView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
    
    fileprivate func addingSignupView() {
        self.mainScrollView.addSubview(signupView)
        self.signupView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: signupView, attribute: .top, relatedBy: .equal, toItem: self.mainScrollView, attribute: .top, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: signupView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: signupView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: signupView, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 1, constant: 0).isActive = true
    }
    
    //MARK: - FUNCTIONS
    fileprivate func captchaConfig() {
        let viewModel = ReCAPTCHAViewModel(
            siteKey: "6Lfmw2EaAAAAAPHqVM1Y0GkePMjE3IiGHydIN0ug",
            url: URL(string: "http://app.ompfinex.com")!
        )

        viewModel.delegate = self
        
        let viewController = ReCAPTCHAViewController(viewModel: viewModel)
        self.captchaVC = viewController
    }
    //MARK: - API
    fileprivate func signupAPI() {
        guard let emailAddress = email else { return }
        guard let password = password else { return }
        guard let recaptcha = reCaptchaToken else { return }
        
        Preloader.sharedInstance.startLoading()
        SignupService.signupRequest(request: .init(email: emailAddress, password: password, recaptchaToken: recaptcha, referralCode: referralCode ?? "")) { [weak self] results in
            Preloader.sharedInstance.stopLoading()
            guard let self = self else { return }
            self.signupView.stopSubmitButtonAnimating = true
            switch results {
            case let .success(response):
                switch response {
                case let .success(response: responseModel):
                    UserDefaults.standard.tokenRef = "token"
                    UserDefaults.standard.securityCodeReference = "code"
                    KeychainData.token = responseModel.token
                    UserDefaults.standard.isLogin = true
                    UserDefaults.standard.userEmail = emailAddress
                    UIApplication.changeRootViewController(MainTabBarController())
                case let .validation(error: errorModel):
                    var errorMessage = ""
                    if let email  = errorModel.errors.email {
                        errorMessage =  email.createErrorMessage() + "\n"
                    }
                    if let password = errorModel.errors.password {
                        errorMessage += password.createErrorMessage() + "\n"
                    }
                    if let recaptcha = errorModel.errors.recaptchaToken {
                        errorMessage += recaptcha.createErrorMessage() + "\n"
                    }
                    if let referralCode = errorModel.errors.referralCode {
                        errorMessage += referralCode.createErrorMessage()
                    }
                    Popup.showError(body: errorMessage)
                }
            case let .failure(error):
                Popup.showError(body: error.localizedStrings)
            }
        }
    }
}

extension SignupViewController: SignupViewDelegate {
    func signupInformation(email: String, password: String, referralCode: String) {
        self.email = email
        self.password = password
        self.referralCode = referralCode
        self.captchaConfig()
        present(captchaVC!, animated: true, completion: nil)
    }
    
    func loginButtonPressed() {
        self.signupView.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - ReCAPTCHAViewModelDelegate
extension SignupViewController: ReCAPTCHAViewModelDelegate {
    func didSolveCAPTCHA(token: String) {
        self.reCaptchaToken = token
        self.captchaVC?.dismiss(animated: true, completion: {
            self.signupAPI()
        })
    }
}
