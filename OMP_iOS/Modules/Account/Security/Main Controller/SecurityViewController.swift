//
//  SecurityViewController.swift
//  OMP_iOS
//
//  Created by AminSoft on 9/3/1400 AP.
//

import UIKit

class SecurityViewController: BaseViewController {
    
    //MARK: - PROPERTIES
    private lazy var securityTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
        tableView.backgroundColor = .clear
        tableView.register(SecurityTableViewCell.self, forCellReuseIdentifier: SecurityTableViewCell.identifier)
        return tableView
    }()
    
    private let viewModel: SecurityViewModel
    
    init(viewModel: SecurityViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - CONTROLLER LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBar(true)
        setBackgroundColor()
        createUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let index = [IndexPath(row: 0, section: 0), IndexPath(row:3, section: 0)]
        securityTableView.reloadRows(at: index, with: .automatic)
    }
    
    //MARK: - CREATE UI
    private func createUI() {
        addingDefaultNavBar()
        addedSecurityTableView()
    }
    
    private func addingDefaultNavBar() {
        addingDefaultNavigationBarView(title: viewModel.mainSecurityControllerTitle , hasBackButton: true, leftSideButtonName: nil, shouldHaveRadius: true)
        defaultNavigationBarView.delegate = self
    }
    
    private func addedSecurityTableView() {
        view.addSubview(securityTableView)
        NSLayoutConstraint.activate([
            securityTableView.topAnchor.constraint(equalTo: defaultNavigationBarView.bottomAnchor, constant: 10),
            securityTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            securityTableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            securityTableView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
    }
}

// MARK: - MAKE INSTANCE
extension SecurityViewController {
    static func makeInstance() -> SecurityViewController {
        .init(viewModel: SecurityViewModel())
    }
}
// MARK: - TABLE VIEW Data Source
extension SecurityViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if UserDefaults.standard.isLogin == false {
            return viewModel.securityWhenUserNotLoginData.count
        }
        if viewModel.canEvaluatePolicy() {
            return viewModel.numberOfItemsWithAuthentication
        }
        return viewModel.numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SecurityTableViewCell.identifier, for: indexPath) as! SecurityTableViewCell
        if UserDefaults.standard.isLogin == false {
            cell.titleLabel.text = viewModel.securityWhenUserNotLoginData[indexPath.row]
        } else {
            if viewModel.canEvaluatePolicy() {
                cell.titleLabel.text = viewModel.mainSecurityDataWithAuthentication[indexPath.row]
            } else {
                cell.titleLabel.text = viewModel.mainSecurityData[indexPath.row]
            }
            
            cell.delegate = self
            if indexPath.row == 0 {
                cell.addedEditStackButton()
                if KeychainData.securityCode != "" {
                    cell.addingElementForEditMode()
                }
            }
            if viewModel.canEvaluatePolicy() {
                if indexPath.row == 3 {
                    cell.addingLocalAuthenticationSwitch()
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if UserDefaults.standard.isLogin == false {
            guard let url = URL(string: viewModel.securityURL), !url.absoluteString.isEmpty else {
                return
            }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            
        switch indexPath.row {
        case 1:
            let vc = ActiveIpOrEntryExitViewController(viewModel: viewModel, type: .activeIP)
            navigationController?.pushViewController(vc, animated: true)
            
        case 2:
            
            let vc = ActiveIpOrEntryExitViewController(viewModel: viewModel, type: .entryAndExit)
            navigationController?.pushViewController(vc, animated: true)
            
        case 4:
            guard let url = URL(string: viewModel.securityURL), !url.absoluteString.isEmpty else {
                return
            }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
        default:
            break
        }
        }
    }
}
// MARK: - TABLEVIEW DELEGATE
extension SecurityViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if KeychainData.securityCode != "" {
            if indexPath.row == 0 {
                return 100
            } else {
                return 60
            }
        }
        return 60
    }
}

// MARK: - ACTIVE OR DEACTIVATED SECURITY CODE
extension SecurityViewController: ActiveOrDeactivateSecuritySwitchProtocol {
    
    func editSecurityCodeButton() {
        let vc = EditSecurityCodeViewController.makeInstance()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func ActiveOrDeactivateSwitchHandler() {
        let vc = AddSecurityCodeViewController.makeInstance()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func offSecurityCode() {
        let vc = AddSecurityCodeViewController.makeInstance()
        vc.ofSecurityCode = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - DefaultNavigationBarViewProtocol
extension SecurityViewController: DefaultNavigationBarViewProtocol {
    func backButtonPressed() {
        navigationController?.popToRootViewController(animated: true)
    }
}


