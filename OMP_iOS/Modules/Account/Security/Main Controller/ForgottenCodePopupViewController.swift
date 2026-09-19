//
//  ForgottenCodePopupViewController.swift
//  OMP_iOS
//
//  Created by AminSoft on 9/10/1400 AP.
//

import UIKit

class ForgottenCodePopupViewController: BaseViewController {

// MARK: - PROPERTIES
    private lazy var popupView: ForgottenSecurityCodeView = {
       let view = ForgottenSecurityCodeView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBar(true)
        setBackgroundColor(.black.withAlphaComponent(0.6))
        createUI()
    }
    
    private func createUI() {
       addingPopupView()
    }

    private func addingPopupView() {
        view.addSubview(popupView)
        NSLayoutConstraint.activate([
            popupView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            popupView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            popupView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            popupView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
        ])
    }
    
    private func logoutAPI() {
        LogoutService.logout {results in
            switch results {
            case .success(_):
                print("will never be success")
            case .failure(_):
                KeychainData.deleteSecurityCode()
                //KeychainData.deleteToken()
//                NotificationCenter.default.post(name: .logout, object: nil)
//                DispatchQueue.main.async(execute: {
//                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                    appDelegate.initRootView(true)
//                })
            }
        }
    }
}

extension ForgottenCodePopupViewController: ForgottenSecurityCodeProtocol {
    func closeButtonAction() {
        dismiss(animated: true, completion: nil)
    }
    
    func confirmButtonAction() {
        logoutAPI()
    }
}
