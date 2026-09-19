//
//  IdentityVerificationPopupViewController.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 12/12/21.
//

import UIKit

class IdentityVerificationPopupViewController: BaseViewController {

    private lazy var identityVerificationNoticeView: IdentityVerificationNoticeView = IdentityVerificationNoticeView()
    
    weak var delegate: IdentityVerificationNoticeViewDelegate?
    
    //MARK: - VIEW CONTROLLER LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissPopup)))
        createUI()
    }

    //MARK: - CREATE UI
    private func createUI() {
        addingIdentityVerificationNoticeView()
    }
    
    private func addingIdentityVerificationNoticeView() {
        view.addSubview(identityVerificationNoticeView)
        identityVerificationNoticeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            identityVerificationNoticeView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            identityVerificationNoticeView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            identityVerificationNoticeView.heightAnchor.constraint(equalToConstant: 220),
            identityVerificationNoticeView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40)
        ])
        identityVerificationNoticeView.delegate = self
    }
    
    //MARK: - OBJC FUNCTION
    @objc func dismissPopup() {
        dismiss(animated: true, completion: nil)
    }
}

extension IdentityVerificationPopupViewController: IdentityVerificationNoticeViewDelegate {
    func closeButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    func actionButtonPressed() {
        dismiss(animated: true, completion: { [weak self] in
            self?.delegate?.actionButtonPressed()
        })
    }
}
