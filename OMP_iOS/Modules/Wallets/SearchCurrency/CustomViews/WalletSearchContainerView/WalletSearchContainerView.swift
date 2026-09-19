//
//  WalletSearchContainerView.swift
//  OMP_iOS
//
//  Created by AminSoft on 7/4/1400 AP.
//

import UIKit

protocol WalletSearchViewProtocol: AnyObject {
    func selectedItem(_ item: Wallet)
}

class WalletSearchContainerView: UIView {
    
    //    MARK: - PROPERTIES
    private lazy var currencySearchBar: CustomSearchBarView = {
        let searchBar = CustomSearchBarView()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var currencyTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SearchWalletCell.self, forCellReuseIdentifier: SearchWalletCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .cardsColor
        return tableView
    }()
    
    weak var delegate: WalletSearchViewProtocol?
    
    //MARK: - INITIALIZERS
    private let viewModel: WalletSearchContainerViewModel
    
    init(viewModel: WalletSearchContainerViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        self.backgroundColor = .cardsColor
        self.layer.cornerRadius = 20
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.createUI()
        
//        reload TableView
        self.viewModel.reloadView = { [weak self] in
            self?.currencyTableView.reloadData()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - CREATE UI
    private func createUI() {
        addingCurrencySearchBar()
        addingSearchCurrencyTableView()
    }
    
    private func addingCurrencySearchBar() {
        self.addSubview(currencySearchBar)
        NSLayoutConstraint.activate([
            currencySearchBar.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            currencySearchBar.centerXAnchor.constraint(equalTo: centerXAnchor),
            currencySearchBar.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.95),
            currencySearchBar.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func addingSearchCurrencyTableView() {
        self.addSubview(currencyTableView)
        NSLayoutConstraint.activate([
            currencyTableView.topAnchor.constraint(equalTo: currencySearchBar.bottomAnchor, constant: 15),
            currencyTableView.centerXAnchor.constraint(equalTo: centerXAnchor),
            currencyTableView.widthAnchor.constraint(equalTo: widthAnchor),
            currencyTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension WalletSearchContainerView {
    static func makeInstance(wallets: [Wallet]) -> WalletSearchContainerView {
        .init(viewModel: WalletSearchContainerViewModel(wallets: wallets))
    }
}

extension WalletSearchContainerView: SendingValueFromTextFieldDelegate {
    func sendingTextFromTextField(_ text: String) {
        viewModel.filterData(walletName: text)
    }
}
// MARK: - TABLE VIEW DATASOURCE & DELEGATE
extension WalletSearchContainerView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getNumberOfWallets()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: SearchWalletCell.identifier, for: indexPath) as? SearchWalletCell {
            cell.configureCell(with: viewModel.getWalletFor(index: indexPath))
            return cell
        } else {
            return  UITableViewCell()
        }
    }
}
extension WalletSearchContainerView: UITableViewDelegate {   
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 0.3) {
            cell.alpha = 1
        }
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.selectedItem(viewModel.getWalletFor(index: indexPath))
    }
}

