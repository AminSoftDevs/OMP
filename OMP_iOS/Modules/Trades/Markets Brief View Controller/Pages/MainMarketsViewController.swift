//
//  MainMarketsViewController.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 11/6/21.
//

import UIKit

protocol MainMarketsViewControllerProtocol: MarketsTableViewProtocol {}

class MainMarketsViewController: MarketsBaseTableViewController {

    func updateDateSource(items: [Markets]) {
        viewModel.updateDataSource(items: items)
    }
    
    weak var delegate: MainMarketsViewControllerProtocol?
    
    //MARK: - VIEW CONTROLLER LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selectedItemFromMarkets(market: viewModel.getItemForRowAtIndex(index: indexPath.row))
    }
}

extension MainMarketsViewController {
    static func makeInstance() -> MainMarketsViewController {
        .init(viewModel: MarketsBaseTableViewViewModel())
    }
}
