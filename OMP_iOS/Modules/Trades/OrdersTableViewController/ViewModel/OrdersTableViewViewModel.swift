//
//  OrdersTableViewViewModel.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 11/3/21.
//

import UIKit

protocol OrdersTableViewProtocol: AnyObject {
    func loadMoreData()
    func cancelPendingOrder(order: Orders)
    func moveToMarketBySelectingOpenOrder(order: Orders)
}

extension OrdersTableViewProtocol {
    func loadMoreData() {}
    func moveToMarketBySelectingOpenOrder(order: Orders) {}
}

enum OrdersListType {
    case history
    case open
}

class OrdersTableViewViewModel {
    
    enum Section {
        case first
    }
    
    var page = 1
    
    var orders = [Orders]()
    
    var dataSource: UITableViewDiffableDataSource<Section,Orders>!
        
    var listType: OrdersListType {
        return type
    }
    
    var mainViewMaskedCorners: CACornerMask {
        return listType == .history ? [.layerMinXMinYCorner, .layerMaxXMinYCorner] : [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    
    weak var delegate: OrdersTableViewProtocol?
    
    //MARK: - INITIALIZER
    private let type: OrdersListType
    
    init(tableType: OrdersListType) {
        self.type = tableType
    }
    
    //MARK: - FUNCTIONS
    func updateDataSource(items: [Orders]) {
        orders = items
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Orders>()
        snapshot.appendSections([.first])
        snapshot.appendItems(orders)
        dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }
    
    func fetchMoreData() {
        delegate?.loadMoreData()
    }
}
