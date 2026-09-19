//
//  OrdersHistoryTableViewController.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 11/4/21.
//

import UIKit

class OrdersViewController: OrdersTableViewController {

    private let ordersViewModel: OrdersHistoryViewModel
    
    init(viewModel: OrdersHistoryViewModel) {
        self.ordersViewModel = viewModel
        super.init(viewModel: OrdersTableViewViewModel.init(tableType: .history))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - VIEW CONTROLLER LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        ordersViewModel.delegate = self
        ordersViewModel.requestForData()
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 0.3) {
            cell.alpha = 1
        }
    }
}

//MARK: - MAKE INSTANCE METHOD
extension OrdersViewController {
    static func makeInstance() -> OrdersViewController {
        .init(viewModel: OrdersHistoryViewModel())
    }
}

//MARK: - OrdersViewModelProtocol DELEGATE METHODS
extension OrdersViewController: OrdersHistoryViewModelProtocol {
    func newItemsReceived() {
        viewModel.updateDataSource(items: ordersViewModel.orders)
    }
}
