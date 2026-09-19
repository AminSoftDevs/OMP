//
//  HistoryWithdrawDigitalCurrencyViewController.swift
//  OMP_iOS
//
//  Created by AminSoft on 7/20/1400 AP.
//

import UIKit

class HistoryWithdrawDigitalCurrencyViewController: BaseViewController {
    
    //    MARK: - PROPERTIES
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
        tableView.register(WithdrawHistoryDigitalCurrencyTableViewCell.self, forCellReuseIdentifier: WithdrawHistoryDigitalCurrencyTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
//        MARK: - INITILIZER
    private let viewModel: WithdrawHistoryViewModel
    
    init(viewModel: WithdrawHistoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //    MARK: - VIEWCONTROLLER LIFECYCLE
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
 
    //    MARK: - CREATE UI
    private func createUI() {
        addingDefaultNavigationBarView(title: viewModel.screenTitle(), hasBackButton: true, shouldHaveRadius: true)
        addingHistoryTableView()
    }
    private func addingHistoryTableView() {
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
extension HistoryWithdrawDigitalCurrencyViewController {
    static func makeInstance(wallet: Wallet) -> HistoryWithdrawDigitalCurrencyViewController {
        .init(viewModel: WithdrawHistoryViewModel(wallet: wallet))
    }
}
// MARK: - VIEW MODEL DELEGATE
extension HistoryWithdrawDigitalCurrencyViewController: WithdrawHistoryViewModelProtocol {
    func withdrawHistoryItemsReceived() {
        if viewModel.depositHistoryItems.count == 0 {
            mainTableView.setEmptyMessage()
        } else {
            mainTableView.restore()
        }
        mainTableView.reloadData()

    }
}

//MARK: - NAVIGATION BAR DELEGATE
extension HistoryWithdrawDigitalCurrencyViewController: DefaultNavigationBarViewProtocol {
    func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
}

//    MARK: - TABLEVIEW DELEGATE & DATASOURCE
extension HistoryWithdrawDigitalCurrencyViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: WithdrawHistoryDigitalCurrencyTableViewCell.identifier, for: indexPath) as? WithdrawHistoryDigitalCurrencyTableViewCell {
            cell.withdrawItem = viewModel.getItemForIndexPath(indexPath.row)
            return cell
        }
        return UITableViewCell()
    }
    
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
