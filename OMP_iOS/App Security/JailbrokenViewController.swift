//
//  JailbrokenViewController.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 12/8/21.
//

import UIKit

class JailbrokenViewController: BaseViewController {

    private lazy var containerView: UIView = {
       var view = UIView()
        view.backgroundColor = .cardsColor
        view.layer.cornerRadius = 15
        view.shadowConfig(UIColor.cardsColor.withAlphaComponent(0.5).cgColor)
        return view
    }()
    
    private lazy var noticeLabel: UILabel = {
       var label = UILabel()
        label.configure(text: "JailbrokenViewController.appWillTerminate".localized, fontSize: 14, textColor: .textColor, textAlignment: .center, fontType: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    //MARK: - VIEW CONTROLLER LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor()
        hideNavigationBar(true)
        createUI()
        // Do any additional setup after loading the view.
    }
    
    private func createUI() {
        addingContainerView()
        addingNoticeLabel()
    }
    
    private func addingContainerView() {
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3)
        ])
    }
    
    private func addingNoticeLabel() {
        containerView.addSubview(noticeLabel)
        noticeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noticeLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            noticeLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            noticeLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.7),
            noticeLabel.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.3)
        ])
    }
}
