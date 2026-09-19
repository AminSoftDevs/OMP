//
//  ActiveIpOrEntryExitViewController.swift
//  OMP_iOS
//
//  Created by AminSoft on 9/4/1400 AP.
//

import UIKit

class ActiveIpOrEntryExitViewController: BaseViewController{
    
    enum SecurityTableViewType {
        case activeIP
        case entryAndExit
    }
    
    private lazy var headerView: SecurityHeaderView? = nil
    
    private lazy var mainTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.register(ActiveIpOrEntryExitTableViewCell.self, forCellReuseIdentifier: ActiveIpOrEntryExitTableViewCell.identifier)
        return tableView
    }()
    
    private var securityTableViewType: SecurityTableViewType
    private let viewModel: SecurityViewModel
    
    init(viewModel: SecurityViewModel, type: SecurityTableViewType) {
        self.viewModel = viewModel
        self.securityTableViewType = type
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
        
        // Delegate
        viewModel.delegate = self
        // Fetch Data
        viewModel.getUserSecurityInformation()
    }
    
    //MARK: - CREATE UI
    private func createUI() {
        addingDefaultNavBar()
        addingHeaderView()
        addedActiveIpTableView()
    }
    
    private func addingDefaultNavBar() {
        switch securityTableViewType {
        case .activeIP:
            addingDefaultNavigationBarView(title: viewModel.activeIdControllerTitle , hasBackButton: true, leftSideButtonName: nil, shouldHaveRadius: true)
        case .entryAndExit:
            addingDefaultNavigationBarView(title: viewModel.entryAndExitControllerTitle , hasBackButton: true, leftSideButtonName: nil, shouldHaveRadius: true)
        }
        defaultNavigationBarView.delegate = self
    }
    
    private func addingHeaderView() {
        switch securityTableViewType {
        case .activeIP:
            self.headerView = SecurityHeaderView(type: .activeID)
        case .entryAndExit:
            self.headerView = SecurityHeaderView(type: .entryAndExit)
            
        }
        headerView!.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView!)
        NSLayoutConstraint.activate([
            headerView!.topAnchor.constraint(equalTo: defaultNavigationBarView.bottomAnchor, constant: 5),
            headerView!.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headerView!.heightAnchor.constraint(equalToConstant: 50),
            headerView!.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
    
    private func addedActiveIpTableView() {
        view.addSubview(mainTableView)
        NSLayoutConstraint.activate([
            mainTableView.topAnchor.constraint(equalTo: headerView!.bottomAnchor),
            mainTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainTableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            mainTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5)
        ])
    }
}

// MARK: - TableView Delegate & Data Source
extension ActiveIpOrEntryExitViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.securityItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ActiveIpOrEntryExitTableViewCell.identifier, for: indexPath) as! ActiveIpOrEntryExitTableViewCell
        switch securityTableViewType {
            
        case .activeIP:
            cell.cellType = .activeIP
            
        case .entryAndExit:
            cell.cellType = .entryAndExit
            
        }
        cell.delegate = self
        cell.securityItems = viewModel.getItemsForIndexPath(indexPath.row)
        return cell
    }
}

extension ActiveIpOrEntryExitViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.securityItems.count - 1 {
            viewModel.loadMoreItemsForList()
        }
    }
}

// MARK: - DefaultNavigationBarViewProtocol
extension ActiveIpOrEntryExitViewController: DefaultNavigationBarViewProtocol {
    func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
}

extension ActiveIpOrEntryExitViewController: SecurityItemsReceivedProtocol, DeleteActiveIpProtocol {
    
    func deleteButtonAction() {
        mainTableView.reloadData()
    }
    
    func deleteActiveIpInCell(ip: Int) {
        viewModel.deleteActiveIp(item: ip)
        mainTableView.reloadData()
    }
    
    func securityItemsReceived(items: [Security]) {
        mainTableView.reloadData()
    }
}
