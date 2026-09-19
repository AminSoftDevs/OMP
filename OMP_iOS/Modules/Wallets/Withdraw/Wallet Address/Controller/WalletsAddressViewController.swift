//
//  WalletsAddressViewController.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 1/25/22.
//

import UIKit
import PanModal

class WalletsAddressViewController: BaseViewController {

    var dismissBriefTable: (() -> Void)?
    var selectedWallet: ((WalletAddress) -> Void)?
    
    //MARK: - UI ELEMENTS
    private lazy var mainTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(WalletsAddressTableViewCell.self, forCellReuseIdentifier: WalletsAddressTableViewCell.identifier)
        tableView.register(WalletAddressBriefTableViewCell.self, forCellReuseIdentifier: WalletAddressBriefTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var newAddressButton: UIButton = {
       var button = UIButton()
        button.configure(fontSize: 13, title: "WalletsAddressViewController.addNewAddress".localized, fontType: .regular, titleColor: .backgroundColor, backgroundColor: .submitButtonColor, borderColor: .clear, cornerRadius: 15)
        button.addTarget(self, action: #selector(newAddressButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var showCompleteWalletAddressListButton: UIButton = {
       var button = UIButton()
        button.configure(fontSize: 13, title: "WalletsAddressViewController.navTitle".localized, fontType: .regular, titleColor: .backgroundColor, backgroundColor: .submitButtonColor, borderColor: .clear, cornerRadius: 15)
        button.tintColor = .backgroundColor
        button.addTarget(self, action: #selector(showCompleteWalletAddressListButtonPressed), for: .touchUpInside)
        button.set(image: UIImage(named: "edit_icon2")?.withRenderingMode(.alwaysTemplate), title: "WalletsAddressViewController.navTitle".localized, titlePosition: .right, additionalSpacing: 30, state: .normal )
        return button
    }()
    private lazy var newWalletAddressView: NewWalletAddressViewController = NewWalletAddressViewController.makeInstance(wallet: nil, tokens: viewModel.getTokens, singleAddress: nil, type: .new)
    
    //MARK: - INITIALIZER
    private let viewModel: WalletsAddressViewModel
    
    init(viewModel: WalletsAddressViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - VIEW CONTROLLER LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBar(true)
        setBackgroundColor()
        createUI()
        
        viewModel.walletAddressListReceived = { [weak self] in
            if self?.viewModel.numberOfItems() == 0 {
                self?.mainTableView.setEmptyImage()
            } else {
                self?.mainTableView.restore()
            }
            self?.mainTableView.reloadData()
        }
        
        viewModel.deletedItemAt = { [weak self] index in
            let indexPath = IndexPath(row: index, section: 0)
            self?.mainTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getWalletAddressList()
    }
    
    //MARK: - CREATE UI
    private func createUI() {
        if viewModel.getScreenType == .full {
            addingDefaultNavBar()
            addingNewAddressButton()
            addingTableView()
        } else {
            addingShowCompleteWalletAddressListButton()
            addingTableViewForBriefMode()
        }
    }
    
    private func addingDefaultNavBar() {
        addingDefaultNavigationBarView(title: "WalletsAddressViewController.navTitle".localized, hasBackButton: true, shouldHaveRadius: true)
        defaultNavigationBarView.delegate = self
    }
    
    private func addingNewAddressButton() {
        view.addSubview(newAddressButton)
        newAddressButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newAddressButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            newAddressButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            newAddressButton.heightAnchor.constraint(equalToConstant: 48),
            newAddressButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }
    
    private func addingTableView() {
        view.addSubview(mainTableView)
        mainTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainTableView.topAnchor.constraint(equalTo: defaultNavigationBarView.bottomAnchor, constant: 10),
            mainTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainTableView.bottomAnchor.constraint(equalTo: newAddressButton.topAnchor, constant: -5)
        ])
    }
    
    //MARK: - brief mode
    private func addingShowCompleteWalletAddressListButton() {
        view.addSubview(showCompleteWalletAddressListButton)
        showCompleteWalletAddressListButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            showCompleteWalletAddressListButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            showCompleteWalletAddressListButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showCompleteWalletAddressListButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32),
            showCompleteWalletAddressListButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func addingTableViewForBriefMode() {
        view.addSubview(mainTableView)
        mainTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainTableView.topAnchor.constraint(equalTo: showCompleteWalletAddressListButton.bottomAnchor, constant: 10),
            mainTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5)
        ])
    }
    
    //MARK: - OBJC FUNCTIONS
    @objc func newAddressButtonPressed() {
        newWalletAddressView = NewWalletAddressViewController.makeInstance(wallet: nil, tokens: viewModel.getTokens, singleAddress: nil, type: .new)
        presentPanModal(newWalletAddressView)
        
        newWalletAddressView.addNewWalletAddressWasSuccessful = { [weak self] in
            self?.viewModel.getWalletAddressList()
        }
    }
    
    @objc func showCompleteWalletAddressListButtonPressed() {
        self.dismiss(animated: true) { [weak self] in
            self?.dismissBriefTable?()
        }
    }
}

//MARK: - TABLE VIEW DELEGATE
extension WalletsAddressViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 0.3) {
            cell.alpha = 1
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = viewModel.dataForRowAt(indexPath: indexPath)
        if viewModel.getScreenType == .brief {
            dismiss(animated: true) { [weak self] in
                self?.selectedWallet?(selectedItem)
            }
        } else {
            navigationController?.popViewController(animated: true)
            self.selectedWallet?(selectedItem)
        }
    }
}

//MARK: - TABLE VIEW DATA SOURCE
extension WalletsAddressViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.getScreenType == .full {
            let cell = tableView.dequeueReusableCell(withIdentifier: WalletsAddressTableViewCell.identifier, for: indexPath) as! WalletsAddressTableViewCell
            cell.walletAddress = viewModel.dataForRowAt(indexPath: indexPath)
            cell.deletedItem = { [weak self] wallet in
                self?.viewModel.deleteWalletAddress(id: wallet.id)
            }
            
            cell.editItem = { [weak self] wallet in
                guard let self = self else { return }
                self.newWalletAddressView = NewWalletAddressViewController.makeInstance(wallet: wallet, tokens: self.viewModel.getTokens, singleAddress: nil, type: .edit)
                self.presentPanModal(self.newWalletAddressView)
                
                self.newWalletAddressView.editedWalletAddressWasSuccessful = { [weak self] in
                    self?.viewModel.getWalletAddressList()
                }
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: WalletAddressBriefTableViewCell.identifier, for: indexPath) as! WalletAddressBriefTableViewCell
            cell.walletAddress = viewModel.dataForRowAt(indexPath: indexPath)
            return cell
        }
    }
}

//MARK: - MAKE INSTANCE METHOD
extension WalletsAddressViewController {
    static func makeInstance(type: WalletAddressListType, tokens: [String]) -> WalletsAddressViewController {
        .init(viewModel: WalletsAddressViewModel(type: type, tokens: tokens))
    }
}

// MARK: - NAVIGATION BAR DELEGATE
extension WalletsAddressViewController: DefaultNavigationBarViewProtocol {
    func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
}

extension WalletsAddressViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return nil
    }
    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(UIScreen.main.bounds.height * 0.3)
    }
    
    var showDragIndicator: Bool {
        return false
    }
}
