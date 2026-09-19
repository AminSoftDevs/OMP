//
//  LoginViewModel.swift
//  OMP_iOS
//
//  Created by AminSoft on 7/1/1400 AP.
//

//import UIKit
//
//class LoginViewModel {
//    
//    var email: String?
//    var password: String?
//    var reCaptchaToken: String?
//    
//    func signIn() {
//        guard let email = email else { return }
//        guard let password = password else { return }
//        guard let reCaptchaToken = reCaptchaToken else { return }
//        
//        Preloader.sharedInstance.startLoading()
//        
//        UserRegisterEndPoint.signIn(email: email,
//                                    password: password,
//                                    reCaptchaToken: reCaptchaToken) { result in
//            
//            Preloader.sharedInstance.stopLoading()
//            
//            switch result {
//            case let .success(loginData):
//                KeychainData.token = loginData.token
//                UserDefaults.standard.isLogin = true
//                UserDefaults.standard.userEmail = loginData.email
//                UIApplication.changeRootViewController(MainTabBarController())
//                
//            case let .failure(error):
//                Popup.showError(body: error.localizedStrings)
//            }
//        }
//    }
//}

