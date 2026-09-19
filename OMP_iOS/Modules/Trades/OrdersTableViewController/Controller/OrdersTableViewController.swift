//
//  OrdersTableViewController.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 11/3/21.
//

import UIKit

class OrdersTableViewController: UITableViewController {

    //MARK: - INITIALIZER
    let viewModel: OrdersTableViewViewModel
    
    init(viewModel: OrdersTableViewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - CONTROLLER LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableViewConfig()
        viewModel.dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, model -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: OrdersTableViewCell.identifier, for: indexPath) as! OrdersTableViewCell
            cell.cellType = self.viewModel.listType
            cell.delegate = self
            cell.order = model
            return cell
        })
    }
    
    private func tableViewConfig() {
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = true
        tableView.backgroundColor = .cardsColor
        tableView.layer.cornerRadius = 15
        tableView.rowHeight = UITableView.automaticDimension
        tableView.layer.maskedCorners = viewModel.mainViewMaskedCorners
        tableView.register(OrdersTableViewCell.self, forCellReuseIdentifier: OrdersTableViewCell.identifier)
        tableView.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = OrdersTableViewHeaderView(type: viewModel.listType)
        header.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50)
        return header
    }
}

//MARK: - MAKE INSTANCE METHOD
extension OrdersTableViewController {
    static func makeInstance(tableType: OrdersListType) -> OrdersTableViewController {
        .init(viewModel: OrdersTableViewViewModel(tableType: tableType))
    }
}

extension OrdersTableViewController: OrdersTableViewProtocol {
    func cancelPendingOrder(order: Orders) {
        viewModel.delegate?.cancelPendingOrder(order: order)
    }
}
