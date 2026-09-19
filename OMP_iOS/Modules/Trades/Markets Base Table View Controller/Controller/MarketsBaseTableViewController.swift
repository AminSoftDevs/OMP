//
//  MarketsBaseTableViewController.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 11/6/21.
//

import UIKit

class MarketsBaseTableViewController: UITableViewController {

    let viewModel: MarketsBaseTableViewViewModel
    
    init(viewModel: MarketsBaseTableViewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - VIEW CONTROLLER LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cardsColor
        tableViewConfig()
        viewModel.delegate = self
    }
    
    private func tableViewConfig() {
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = true
        tableView.backgroundColor = .cardsColor
        tableView.layer.cornerRadius = 15
        tableView.rowHeight = UITableView.automaticDimension
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tableView.register(MarketsBaseTableViewCell.self, forCellReuseIdentifier: MarketsBaseTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MarketsBaseTableViewCell.identifier, for: indexPath) as! MarketsBaseTableViewCell
        cell.selectionStyle = .none
        cell.market = viewModel.getItemForRowAtIndex(index: indexPath.row)
        return cell
    }
}

extension MarketsBaseTableViewController {
    static func makeInstance(type: MarketOriginalParentType) -> MarketsBaseTableViewController {
        .init(viewModel: MarketsBaseTableViewViewModel())
    }
}

extension MarketsBaseTableViewController: MarketsTableViewProtocol {
    func tableShouldReloadWithNewData() {
        tableView.reloadData()
    }
}
