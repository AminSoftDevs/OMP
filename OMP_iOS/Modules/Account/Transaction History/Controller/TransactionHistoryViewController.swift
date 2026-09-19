//
//  TransactionHistoryViewController.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 8/26/21.
//

import UIKit

class TransactionHistoryViewController: BaseViewController {

    private let refreshControl = UIRefreshControl()
    
    private lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .vertical
        return collectionViewFlowLayout
    }()
    
    private lazy var transactionHistoryCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.register(TransactionHistoryCollectionViewCell.self, forCellWithReuseIdentifier: TransactionHistoryCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .cardsColor
        collectionView.showsVerticalScrollIndicator = false
        collectionView.refreshControl = refreshControl
        collectionView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        collectionView.layer.cornerRadius = 10
        return collectionView
    }()
    
    //MARK: - INITIALIZER
    private let viewModel: TransactionHistoryViewModel
    
    init(viewModel: TransactionHistoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - VIEW CONTROLLER LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor()
        hideNavigationBar(true)
        createUI()
        viewModel.getTransactionHistory()
        //delegate
        viewModel.delegate = self
        
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        refreshControl.tintColor = .textColor
    }
    
    //MARK: - CREATE UI
    private func createUI() {
        addingDefaultNavBar()
        addingTransactionHistoryCollectionView()
    }
    
    private func addingDefaultNavBar() {
        addingDefaultNavigationBarView(title: viewModel.navigationTitle, hasBackButton: true, shouldHaveRadius: true)
        defaultNavigationBarView.delegate = self
    }
    
    private func addingTransactionHistoryCollectionView() {
        view.addSubview(transactionHistoryCollectionView)
        transactionHistoryCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            transactionHistoryCollectionView.topAnchor.constraint(equalTo: defaultNavigationBarView.bottomAnchor, constant: 15),
            transactionHistoryCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            transactionHistoryCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            transactionHistoryCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    //MARK: - OBJC FUNCTIONS
    @objc func refreshData(_ sender: UIRefreshControl) {
        viewModel.getTransactionHistory()
    }
}

//MARK: - COLLECTION VIEW DELEGATE
extension TransactionHistoryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TransactionHistoryCollectionViewCell.identifier, for: indexPath) as! TransactionHistoryCollectionViewCell
        cell.transaction = viewModel.getItemForRowAt(indexPath: indexPath)
        return cell
    }
}

extension TransactionHistoryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width - 20
        return CGSize(width: width, height: viewModel.cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 0.3) {
            cell.alpha = 1
        }
    }
}

//MARK: - NAVIGATION BAR DELEGATE
extension TransactionHistoryViewController: DefaultNavigationBarViewProtocol {
    func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - VIEW MODEL DELEGATE
extension TransactionHistoryViewController: TransactionHistoryProtocol {
    func responseReceived() {
        if viewModel.numberOfItems == 0 {
            transactionHistoryCollectionView.setEmptyMessage()
        } else {
            transactionHistoryCollectionView.restore()
        }
        transactionHistoryCollectionView.reloadData()
        refreshControl.endRefreshing()
    }
}

//MARK: - MAKE INSTANCE
extension TransactionHistoryViewController {
    static func makeInstance() -> TransactionHistoryViewController {
        .init(viewModel: TransactionHistoryViewModel())
    }
}

