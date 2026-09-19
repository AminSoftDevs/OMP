//
//  MarketNavBarView.swift
//  OMP_iOS
//
//  Created by AminSoft on 8/18/1400 AP.
//

import UIKit


enum MarketPage: Int, CaseIterable {
    case favorites = 0
    case main
    case professional
    
    var title: String {
        switch self {
        case .favorites:
            return "MarketNavBarView.favorites".localized
            
        case .main:
            return "MarketNavBarView.mainMarket".localized
            
        case .professional:
            return "MarketNavBarView.proMarket".localized
        }
    }
}
    protocol MarketCollectionViewDidSelectedProtocol: AnyObject {
        func changeViewControllerDelegate(index: IndexPath)
    }
    
    class MarketNavBarView: UIView {
        
        //    MARK: - PROPERTIES
        private lazy var marketNavBarCollectionViewFlowLayout: UICollectionViewFlowLayout = {
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.scrollDirection = .horizontal
            return flowLayout
        }()
        
        private lazy var marketNavBarCollectionView: UICollectionView = {
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: marketNavBarCollectionViewFlowLayout)
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            collectionView.backgroundColor = .clear
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.isScrollEnabled = false
            collectionView.bounces = false
            collectionView.register(MarketNavBarCollectionViewCell.self, forCellWithReuseIdentifier: MarketNavBarCollectionViewCell.identifier)
            return collectionView
        }()
        
        weak var delegate: MarketCollectionViewDidSelectedProtocol?
        
        private var dataSource: [MarketPage]
        private var isFirstRun = true
        
        //    MARK: - INITILIZERS
        init(dataSource: [MarketPage]) {
            self.dataSource = dataSource
            
            super.init(frame: .zero)
            marketNavBarCollectionView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            
            defaultStyle()
            createUI()
            
            marketNavBarCollectionView.dataSource = self
            marketNavBarCollectionView.delegate = self
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        
        fileprivate func defaultStyle() {
            self.backgroundColor = .cardsColor
            self.layer.cornerRadius = 20
            self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
        
        //    MARK: - CREATE UI
        private func createUI() {
            addingChangeMarketCollectionView()
        }
        private func addingChangeMarketCollectionView() {
            addSubview(marketNavBarCollectionView)
            NSLayoutConstraint.activate([
                marketNavBarCollectionView.centerYAnchor.constraint(equalTo: centerYAnchor),
                marketNavBarCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
                marketNavBarCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
                marketNavBarCollectionView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.65)
            ])
        }
        
        func selectNewCell(with type: MarketPage) {
            for cell in marketNavBarCollectionView.visibleCells {
                deselectCell(cell: cell)
            }
            
            if let index = dataSource.firstIndex(where: { $0 == type}) {
                if let cell = marketNavBarCollectionView.cellForItem(at: IndexPath(row: index, section: 0)) {
                    selectCell(cell: cell)
                }
            }
        }
    }
    
    extension MarketNavBarView: UICollectionViewDataSource {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            dataSource.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MarketNavBarCollectionViewCell.identifier, for: indexPath) as! MarketNavBarCollectionViewCell
            cell.changeMarketLabel.text = dataSource[indexPath.row].title
            cell.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            
            if let index = dataSource.firstIndex(where: { $0 == MarketPage.main}) {
                if isFirstRun && indexPath.row == index {
                    isFirstRun = false
                    selectCell(cell: cell)
                }
            }
            collectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: .centeredHorizontally, animated: false)
            return cell
        }
    }
    
    extension MarketNavBarView: UICollectionViewDelegate {
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            //added Border to Cell When Selected
            selectNewCell(with: dataSource[indexPath.row])
            //Change index PageCollectionView
            delegate?.changeViewControllerDelegate(index: indexPath)
        }
        
        func selectCell(cell: UICollectionViewCell) {
            cell.layer.borderColor = UIColor.submitButtonColor.cgColor
            cell.layer.borderWidth = 0.5
            cell.backgroundColor = .submitButtonColor.withAlphaComponent(0.1)
        }
        
        func deselectCell(cell: UICollectionViewCell) {
            cell.layer.borderColor = UIColor.clear.cgColor
            cell.layer.borderWidth = 0
            cell.backgroundColor = .clear
        }
    }
    
    extension MarketNavBarView: UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let cellHeight: CGFloat = collectionView.frame.height
            let cellWidth: CGFloat = dataSource[indexPath.row].title.widthOfString(usingFont: UIFont.init(type: .regular, fontSize: 14))
            
            return  CGSize(width: cellWidth + 10, height: cellHeight - 5)
        }
    }
    
