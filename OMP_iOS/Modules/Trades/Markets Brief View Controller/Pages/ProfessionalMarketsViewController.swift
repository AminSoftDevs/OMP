//
//  ProfessionalMarketsViewController.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 11/6/21.
//

import UIKit

protocol ProfessionalMarketsViewControllerProtocol: MarketsTableViewProtocol {}

class ProfessionalMarketsViewController: MarketsBaseTableViewController {
    
    weak var delegate: ProfessionalMarketsViewControllerProtocol?
    
    //MARK: - VIEW CONTROLLER LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
    }
    
    func updateDataSource(items: [Markets]) {
        viewModel.updateDataSource(items: items)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selectedItemFromMarkets(market: viewModel.getItemForRowAtIndex(index: indexPath.row))
    }
}

extension ProfessionalMarketsViewController {
    static func makeInstance() -> ProfessionalMarketsViewController {
        .init(viewModel: MarketsBaseTableViewViewModel())
    }
}
