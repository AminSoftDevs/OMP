//
//  PageMarketCollectionViewCell.swift
//  OMP_iOS
//
//  Created by AminSoft on 8/24/1400 AP.
//

import UIKit

//protocol MarketTableViewProtocol: AnyObject {
//    func selectedMarket(market: Market)
//    func likeMarketHandler(market: Market)
//}
//
//extension MarketTableViewProtocol {
//    func selectedMarket(market: Market) {}
//    func likeMarketHandler(market: Market) {}
//}

class PageMarketCollectionViewCell: UICollectionViewCell {
    
    var markets: [Market] = [] {
        didSet {
            marketPageTableView.reloadData()
        }
    }
    
    weak var delegate: MarketViewModelProtocol?
    
    //    MARK: - PROPERTIES
    private lazy var marketHeaderView: MarketHeaderView = {
        let header = MarketHeaderView()
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()
    
    private lazy var marketPageTableView: UITableView = {
        let tableView =  UITableView()
        tableView.bounces = false
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(MarketTableViewCell.self, forCellReuseIdentifier: MarketTableViewCell.identifier)
        return tableView
    }()
    
    //    MARK: - INITILEZERS
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .cardsColor
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    //    MARK: - CREATE UI
    private func createUI() {
        addingMarketHeaderView()
        addingMarketPageTableView()
    }
    private func addingMarketHeaderView() {
        contentView.addSubview(marketHeaderView)
        NSLayoutConstraint.activate([
            marketHeaderView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            marketHeaderView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            marketHeaderView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.98),
            marketHeaderView.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    private func addingMarketPageTableView() {
        contentView.addSubview(marketPageTableView)
        NSLayoutConstraint.activate([
            marketPageTableView.topAnchor.constraint(equalTo: marketHeaderView.bottomAnchor, constant: 5),
            marketPageTableView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            marketPageTableView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.98),
            marketPageTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

extension PageMarketCollectionViewCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return markets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MarketTableViewCell.identifier, for: indexPath) as! MarketTableViewCell
        cell.market = markets[indexPath.row]
        cell.delegate = self
        return cell
    }
}

extension PageMarketCollectionViewCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellHeight: CGFloat = 90
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}


//extension PageMarketCollectionViewCell: MarketTableViewProtocol {
//    func likeMarketHandler(market: Market) {
//        delegate?.likeMarketHandler(market: market)
//    }
//}

extension PageMarketCollectionViewCell: MarketViewModelProtocol {
    func likeButtonAction(with item: Market) {
        delegate?.likeButtonAction(with: item)
    }
}
