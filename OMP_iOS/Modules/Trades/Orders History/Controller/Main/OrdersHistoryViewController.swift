//
//  OrdersHistoryViewController.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 9/2/21.
//

import UIKit

class OrdersHistoryViewController: BaseViewController {
    
    lazy var ordersHistoryTableView = OrdersViewController.makeInstance()
    
    //MARK: - VIEW CONTROLLER LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBar(true)
        setBackgroundColor()
        createUI()
    }
    
    //MARK: - CREATE UI
    private func createUI() {
        addingDefaultNavBar()
        addingOrdersHistoryCollectionView()
    }
    
    private func addingDefaultNavBar() {
        addingDefaultNavigationBarView(title: "TradeNavigationBarView.ordersHistoryButton".localized, hasBackButton: true, shouldHaveRadius: true)
        defaultNavigationBarView.delegate = self
    }
    
    private func addingOrdersHistoryCollectionView() {
        add(ordersHistoryTableView)
        ordersHistoryTableView.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ordersHistoryTableView.view.topAnchor.constraint(equalTo: defaultNavigationBarView.bottomAnchor, constant: 15),
            ordersHistoryTableView.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ordersHistoryTableView.view.widthAnchor.constraint(equalTo: view.widthAnchor),
            ordersHistoryTableView.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
// MARK: - DefaultNavigationBarViewProtocol
extension OrdersHistoryViewController: DefaultNavigationBarViewProtocol {
    func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
}
