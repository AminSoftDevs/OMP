//
//  SearchCurrencyViewController.swift
//  OMP_iOS
//
//  Created by AminSoft on 7/3/1400 AP.
//

import UIKit

class SearchCurrencyViewController: BaseViewController {

    //    MARK: - PROPERTIES
    private lazy var baseNavigationBarView: BaseNavigationBarView? = nil
    
    private let mainWalletSearchView: WalletSearchContainerView
    
    private let viewModel: SearchCurrencyViewModel
    
    init(viewModel: SearchCurrencyViewModel) {
        self.mainWalletSearchView = WalletSearchContainerView.makeInstance(wallets: viewModel.wallets)
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: - VIEW CONTROLLER LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
//        Setup UI
        self.hideNavigationBar(true)
        self.setBackgroundColor()
        self.createUI()
        
        self.mainWalletSearchView.delegate = self
    }
    
    //MARK: - CREATE UI
   private func createUI() {
    self.addingNavBarView()
    self.addingMainWalletSearchBar()
    }
    
    private func addingNavBarView() {
        self.baseNavigationBarView = BaseNavigationBarView(navigationType: .defaultMode, title: viewModel.titleString)
        self.baseNavigationBarView?.delegate = self
        self.view.addSubview(baseNavigationBarView!)
        self.baseNavigationBarView?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            baseNavigationBarView!.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            baseNavigationBarView!.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            baseNavigationBarView!.widthAnchor.constraint(equalTo: view.widthAnchor),
            baseNavigationBarView!.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    private func addingMainWalletSearchBar() {
        mainWalletSearchView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainWalletSearchView)
        NSLayoutConstraint.activate([
            mainWalletSearchView.topAnchor.constraint(equalTo: baseNavigationBarView!.bottomAnchor, constant: 5),
            mainWalletSearchView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainWalletSearchView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            mainWalletSearchView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension SearchCurrencyViewController {
    static func makeInstance(wallets: [Wallet], transactionType: TransactionType) -> SearchCurrencyViewController {
        .init(viewModel: .init(wallets: wallets, transactionType: transactionType))
    }
}

extension SearchCurrencyViewController: BaseNavigationBarDelegate {
    func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
}

extension SearchCurrencyViewController: WalletSearchViewProtocol {
    func selectedItem(_ item: Wallet) {
        let vc = viewModel.handleSelection(item: item)
        navigationController?.pushViewController(vc, animated: true)
    }
}
