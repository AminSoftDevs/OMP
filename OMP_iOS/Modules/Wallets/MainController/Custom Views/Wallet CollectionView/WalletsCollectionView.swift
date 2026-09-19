//
//  WalletsCollectionView.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 9/26/21.
//

import UIKit

protocol WalletsCollectionViewProtocol: AnyObject {
    func hideZeroBalance(_ hide: Bool)
    func selectedItem(item wallet: Wallet)
}

class WalletsCollectionView: UIView {
    
    private let identifier = "walletCell"
    private let cellHeight: CGFloat = 100
    
    lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .vertical
        return collectionViewFlowLayout
    }()
    
    lazy var mainCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.register(WalletsCollectionViewCell.self, forCellWithReuseIdentifier: identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.bounces = false
        return collectionView
    }()
    
    lazy var titleImageView: UIImageView = {
       var imageView = UIImageView()
        imageView.image = UIImage(named: "line")
        return imageView
    }()
    
    lazy var walletListTitleLabel: UILabel = {
       var label = UILabel()
        label.configure(text: "WalletsCollectionView.hideEmptyWallets".localized, fontSize: 13, textColor: .mediumGrayColor, textAlignment: .center, fontType: .regular)
        return label
    }()
    
    lazy var showNotZeroBalanceSwitch: UISwitch = {
       var showSwitch = UISwitch()
        showSwitch.isOn = false
        showSwitch.onTintColor = .lightGray.withAlphaComponent(0.3)
        showSwitch.thumbTintColor = .lightGray
        showSwitch.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        return showSwitch
    }()
    
    weak var delegate: WalletsCollectionViewProtocol?
    
    //MARK: -  DEFAULT INITIALIZER
    let viewModel: WalletsCollectionViewModel
    
    init(viewModel: WalletsCollectionViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        self.backgroundColor = .cardsColor
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        self.createUI()
        
        self.viewModel.updateNeeded = { [weak self] in
            self?.mainCollectionView.reloadData()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func createUI() {
        self.addingWalletListTitleLabel()
        self.addingTitleImageView()
        self.addingSwitch()
        self.addingMainCollectionView()
    }
    
    fileprivate func addingWalletListTitleLabel() {
        self.addSubview(walletListTitleLabel)
        self.walletListTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            walletListTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            walletListTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25)
        ])
    }
    
    fileprivate func addingTitleImageView() {
        self.addSubview(titleImageView)
        self.titleImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleImageView.topAnchor.constraint(equalTo: walletListTitleLabel.bottomAnchor, constant: 20),
            titleImageView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            titleImageView.widthAnchor.constraint(equalTo: widthAnchor,  multiplier: 0.8, constant: 0),
        ])
    }
    
    fileprivate func addingSwitch() {
        self.addSubview(showNotZeroBalanceSwitch)
        self.showNotZeroBalanceSwitch.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            showNotZeroBalanceSwitch.centerYAnchor.constraint(equalTo: walletListTitleLabel.centerYAnchor, constant: 0),
            showNotZeroBalanceSwitch.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
        ])
        self.showNotZeroBalanceSwitch.transform = .init(scaleX: 0.6, y: 0.6)
    }
    
    fileprivate func addingMainCollectionView() {
        self.addSubview(mainCollectionView)
        mainCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainCollectionView.topAnchor.constraint(equalTo: titleImageView.bottomAnchor, constant: 5),
            mainCollectionView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            mainCollectionView.widthAnchor.constraint(equalTo: widthAnchor,  multiplier: 1, constant: 0),
            mainCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
    }
    
    //MARK: - OBJC FUNCTIONS
    @objc func switchChanged(_ sender: UISwitch) {
        if sender.isOn {
            sender.thumbTintColor = .submitButtonColor
            sender.onTintColor = .submitButtonColor.withAlphaComponent(0.3)
        } else {
            sender.thumbTintColor = .lightGray
            sender.onTintColor = .lightGray.withAlphaComponent(0.3)
        }
        delegate?.hideZeroBalance(sender.isOn)
    }
}

extension WalletsCollectionView {
    static func makeInstance() -> WalletsCollectionView {
        .init(viewModel: WalletsCollectionViewModel())
    }
    
    func fillWallets(wallets: [Wallet]) {
        self.viewModel.fillWallets(wallets: wallets)
    }
}


extension WalletsCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.selectedItem(item: viewModel.getWalletWithIndex(indexPath.row))
    }
}

extension WalletsCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getNumberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! WalletsCollectionViewCell
        cell.wallet = viewModel.getWalletWithIndex(indexPath.row)
        return cell
    }
}

extension WalletsCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 10, left: 5, bottom: 0, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        return CGSize(width: width - 10, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 0.3) {
            cell.alpha = 1
        }
    }
}
