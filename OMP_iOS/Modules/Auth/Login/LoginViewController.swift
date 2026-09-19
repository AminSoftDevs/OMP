//
//  LoginViewController.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 7/31/21.
//

import UIKit

class LoginViewController: BaseViewController {

    var email: String?
    var password: String?
    var reCaptchaToken: String?
    var captchaVC: ReCAPTCHAViewController?
    lazy var authNavigationView: AuthNavigationView = {
       var view = AuthNavigationView()
        view.delegate = self
        return view
    }()
    
    lazy var loginView: LoginView = {
       var view = LoginView()
        view.delegate = self
        return view
    }()
    
    //MARK: - VIEW CONTROLLER LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideNavigationBar(true)
        self.setBackgroundColor(.cardsColor)
        self.createUI()
    }
    
    //MARK: - CREATE UI
    fileprivate func createUI() {
        self.addingAuthenticationNavigationView()
        self.addingLoginView()
    }
    
    fileprivate func addingAuthenticationNavigationView() {
        self.view.addSubview(authNavigationView)
        self.authNavigationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: authNavigationView, attribute: .top, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: authNavigationView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: authNavigationView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: authNavigationView, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0, constant: 40).isActive = true
    }
    
    fileprivate func addingLoginView() {
        self.view.addSubview(loginView)
        self.loginView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: loginView, attribute: .top, relatedBy: .equal, toItem: authNavigationView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: loginView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: loginView, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: loginView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
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
    
    fileprivate func sendLoginNotification() {
        NotificationCenter.default.post(name: .signIn, object: nil)
    }
    
    //MARK: - API
    fileprivate func loginAPI() {
        guard let emailAddress = email else { return }
        guard let password = password else { return }
        guard let recaptcha = reCaptchaToken else { return }
        
        Preloader.sharedInstance.startLoading()
        LoginService.userLogin(request: .init(email: emailAddress, password: password, recaptchaToken: recaptcha)) { [weak self] results in
            Preloader.sharedInstance.stopLoading()
            guard let self = self else { return }
            switch results {
            case let .success(response):
                switch response {
                case let .success(response: responseModel):
                    UserDefaults.standard.tokenRef = "token"
                    UserDefaults.standard.securityCodeReference = "code"
                    KeychainData.token = responseModel.token
                    UserDefaults.standard.isLogin = true
                    UserDefaults.standard.userEmail = responseModel.data.email
                    self.sendLoginNotification()
                    UIApplication.changeRootViewController(MainTabBarController())
                case let .validation(error: errorModel):
                    var errorMessage = ""
                    if let email  = errorModel.errors.email {
                        errorMessage =  email.createErrorMessage() + "\n"
                    }
                    if let password = errorModel.errors.password {
                        errorMessage += password.createErrorMessage()
                    }
                    if let recaptcha = errorModel.errors.recaptchaToken {
                        errorMessage += recaptcha.createErrorMessage()
                    }
                    Popup.showError(body: errorMessage)
                }
            case let .failure(error):
                Popup.showError(body: error.localizedStrings)
            }
        }
    }
}

extension LoginViewController: LoginViewDelegate {
    func buttonsActionHandler(action: ButtonsAction, email: String?, password: String?) {
        switch action {
        case .login:
            self.email = email
            self.password = password
            self.captchaConfig()
            present(captchaVC!, animated: true, completion: nil)
        case .forgetPassword:
            let vc = ForgetPasswordViewController()
            vc.modalPresentationStyle = .fullScreen
            show(vc, sender: self)
        case .signup:
            let vc = SignupViewController()
            vc.modalPresentationStyle = .fullScreen
            show(vc, sender: self)
        }
    }
}

// MARK: - ReCAPTCHAViewModelDelegate
extension LoginViewController: ReCAPTCHAViewModelDelegate {
    func didSolveCAPTCHA(token: String) {
        self.reCaptchaToken = token
        self.captchaVC?.dismiss(animated: true, completion: {
            self.loginAPI()
        })
    }
}

extension LoginViewController: AuthNavigationDelegate {
    func backButtonPressed() {
        self.loginView.endEditing(true)
        UIApplication.changeRootViewController(MainTabBarController())
    }
}
