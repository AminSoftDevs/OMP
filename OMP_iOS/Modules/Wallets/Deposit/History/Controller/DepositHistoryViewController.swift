//
//  DepositHistoryViewController.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 10/11/21.
//

import UIKit

class DepositHistoryViewController: BaseViewController {

    private lazy var mainTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .cardsColor
        tableView.layer.cornerRadius = 15
        tableView.rowHeight = UITableView.automaticDimension
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tableView.register(DepositHistoryTableViewCell.self, forCellReuseIdentifier: DepositHistoryTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    //MARK: - INITIALIZER
    private let viewModel: DepositHistoryViewModel
    
    init(viewModel: DepositHistoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - VIEW CONTROLLER LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBar(true)
        setBackgroundColor()
        createUI()
        
        //navigation delegate
        defaultNavigationBarView.delegate = self
        viewModel.delegate  = self
        
        //fetching data
        viewModel.getDepositHistoryAPI()
    }
    
    //MARK: - CREATE UI
    private func createUI() {
        addingDefaultNavigationBarView(title: viewModel.screenTitle(), hasBackButton: true, shouldHaveRadius: true)
        addingMainTableView()
    }
    
    private func addingMainTableView() {
        view.addSubview(mainTableView)
        mainTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainTableView.topAnchor.constraint(equalTo: defaultNavigationBarView.bottomAnchor, constant: 15),
            mainTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

//MARK: - MAKE INSTANCE METHOD
extension DepositHistoryViewController {
    static func makeInstance(wallet: Wallet) -> DepositHistoryViewController {
        .init(viewModel: DepositHistoryViewModel(wallet: wallet))
    }
}

//MARK: - NAVIGATION BAR DELEGATE
extension DepositHistoryViewController: DefaultNavigationBarViewProtocol {
    func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - VIEW MODEL DELEGATE
extension DepositHistoryViewController: DepositHistoryViewModelProtocol {
    func depositHistoryItemsReceived() {
        if viewModel.depositHistoryItems.count == 0 {
            mainTableView.setEmptyMessage()
        } else {
            mainTableView.restore()
        }
        mainTableView.reloadData()
    }
}

extension DepositHistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 0.3) {
            cell.alpha = 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK: - Table VIEW DATA SOURCE
extension DepositHistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DepositHistoryTableViewCell.identifier, for: indexPath) as! DepositHistoryTableViewCell
        cell.depositItem = viewModel.getItemForIndexPath(indexPath.row)
        return cell
    }
}
