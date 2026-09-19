//
//  AccountViewController.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 7/28/21.
//

import UIKit
import Crisp

class AccountViewController: BaseViewController {
    
    private lazy var accountNavigationBarView: AccountNavigationBarView = {
        let navBar = AccountNavigationBarView(userLoggedIn: viewModel.isUserLoggedIn)
        navBar.navigationTitle = viewModel.navigationTitle
        navBar.userEmail = viewModel.userEmailAddress
        navBar.delegate = self
        return navBar
    }()
    
    private lazy var userAccountTableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 10
        tableView.bounces = false
        tableView.separatorStyle = .none
        tableView.allowsSelection = true
        tableView.allowsMultipleSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .cardsColor
        tableView.register(AccountTableViewCell.self, forCellReuseIdentifier: AccountTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private var accountTableViewHeightConstraint = NSLayoutConstraint()
    private var accountTableViewBottomConstraint = NSLayoutConstraint()
    
    //MARK: - INITIALIZER
    private let viewModel: AccountControllerViewModel
    
    init(viewModel: AccountControllerViewModel) {
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
        hideNavigationBar(true)
        createUI()
        
        //delegate
        viewModel.delegate = self
        viewModel.userAccountTableViewData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getUserInfo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.removeIdentityVerificationRow()
    }
    
    //MARK: - CREATE UI
    private func createUI() {
        self.addingNavigationBarView()
        self.addingUserAccountTableView()
    }
    
    private func addingNavigationBarView() {
        view.addSubview(accountNavigationBarView)
        accountNavigationBarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            accountNavigationBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            accountNavigationBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            accountNavigationBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            accountNavigationBarView.heightAnchor.constraint(equalToConstant: viewModel.navigationBarHeight),
        ])
    }
    
    private func addingUserAccountTableView() {
        view.addSubview(userAccountTableView)
        userAccountTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userAccountTableView.topAnchor.constraint(equalTo: accountNavigationBarView.bottomAnchor, constant: 10),
            userAccountTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            userAccountTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        accountTableViewHeightConstraint = userAccountTableView.heightAnchor.constraint(equalToConstant: viewModel.tableViewHeight)
        accountTableViewHeightConstraint.isActive = true
        
        accountTableViewBottomConstraint = userAccountTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        accountTableViewBottomConstraint.isActive = false
    }
    //MARK: - FUNCTIONS
    func refreshTableView() {
        if viewModel.accountTableViewShouldFillScreen() {
            accountTableViewHeightConstraint.isActive = false
            accountTableViewBottomConstraint.isActive = true
            view.layoutIfNeeded()
            userAccountTableView.reloadData()
        } else {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3) {
                    self.accountTableViewHeightConstraint.constant = self.viewModel.tableViewHeight
                    self.view.layoutIfNeeded()
                } completion: { _ in
                    self.userAccountTableView.reloadData()
                }
            }
        }
    }
    
    //MARK: - FUNCTIONS
    private func accountTableSelectionHandler(item: AccountTableOptions) {
        switch item.type {
        case .identityVerification:
            viewModel.getUserInfo()
            let vc = IdentityVerificationViewController.makeInstance(userInfo: viewModel.userInfo)
            vc.hidesBottomBarWhenPushed = true
            show(vc, sender: self)
        case .profile:
            let vc = ProfileViewController.makeInstance(userInfo: viewModel.userInfo)
            show(vc, sender: self)
            
        case .transactionHistory:
            let vc = TransactionHistoryViewController.makeInstance()
            show(vc, sender: self)
            
        case .setting:
            let vc = SettingViewController.makeInstance()
            show(vc, sender: self)
            
        case .support:
            let vc = ChatViewController()
            viewModel.sendUserInformationToCrisp()
            show(vc, sender: self)
            
        case .security:
            let vc = SecurityViewController.makeInstance()
            show(vc, sender: self)
            
        case .userGuid:
            let vc = ChangeLanguageViewController.makeInstance()
        //let vc = GuideViewController.makeInstance()
            show(vc, sender: self)
        case .logout:
            viewModel.logoutAPI()
        case .referral:
            if let userInfo = viewModel.userInfo {
                let vc = ReferralViewController.makeInstance(userInfo: userInfo)
                vc.hidesBottomBarWhenPushed = true
                show(vc, sender: self)
            }
        }
    }
}

//MARK: - NAVIGATION BAR DELEGATE
extension AccountViewController: AccountNavigationBarDelegate {
    func loginButtonPressed() {
        let vc = UINavigationController(rootViewController: LoginViewController())
        UIApplication.changeRootViewController(vc)
    }
    
    func notificationButtonPressed() {
        let announcementViewController = AnnouncementViewController.makeInstance()
        self.show(announcementViewController, sender: self)
    }
}

//MARK: - POPUP DELEGATE
extension AccountViewController: IdentityVerificationNoticeViewDelegate {
    func actionButtonPressed() {
        let vc = IdentityVerificationViewController.makeInstance(userInfo: viewModel.userInfo)
        vc.hidesBottomBarWhenPushed = true
        show(vc, sender: self)
    }
}

//MARK: - TABLE VIEW DATA SOURCE & DELEGATE
extension AccountViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        accountTableSelectionHandler(item: viewModel.dataForRowAt(indexPath: indexPath))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.getHeightForRow
    }
}

extension AccountViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInAccountTableView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AccountTableViewCell.identifier, for: indexPath) as! AccountTableViewCell
        cell.userAccountItem = viewModel.dataForRowAt(indexPath: indexPath)
        cell.selectionStyle = .none
        return cell
    }
}

//MARK: - MAKE INSTANCE METHOD
extension AccountViewController {
    static func makeInstanceMethod() -> AccountViewController {
        .init(viewModel: AccountControllerViewModel())
    }
}

//MARK: - VIEW MODEL DELEGATE
extension AccountViewController: AccountControllerViewModelProtocol {
    func removedAt(indexPath: IndexPath) {
        userAccountTableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func tableShouldReload() {
        refreshTableView()
    }
    
    func showIdentityVerificationNoticePopup() {
        let noticePopup = IdentityVerificationPopupViewController()
        noticePopup.delegate = self
        noticePopup.modalTransitionStyle = .crossDissolve
        noticePopup.modalPresentationStyle = .overFullScreen
        present(noticePopup, animated: true, completion: nil)
    }
}
