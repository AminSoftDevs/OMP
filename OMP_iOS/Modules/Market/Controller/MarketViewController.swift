//
//  MarketViewController.swift
//  OMP_iOS
//
//  Created by AminSoft on 8/24/1400 AP.
//

import UIKit

class MarketViewController: BaseViewController {
    
    private lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        return flowLayout
    }()
    
    private lazy var pageCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = true
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        collectionView.clipsToBounds = true
        collectionView.layer.cornerRadius = 15
        collectionView.register(PageMarketCollectionViewCell.self, forCellWithReuseIdentifier: PageMarketCollectionViewCell.identifier)
        return collectionView
    }()
    
    private var marketNavBarView: MarketNavBarView!
    
    //MARK: - INITIALIZER
    private let viewModel: MarketViewModel
    
    init(viewModel: MarketViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let dir = Localization.sharedInstance.getlanguageDirection()
    
    //MARK: - VIEW CONTROLLER LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBar(true)
        setBackgroundColor()
        pageCollectionView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        createUI()
        viewModel.firstReload = true
        Preloader.sharedInstance.startLoading()
        viewModel.delegate = self
        viewModel.getMarket()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // update Markets With Timer
        viewModel.updateMarketsForTimers()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // Invalid Timer
        viewModel.invalidTimer()
    }
    
    //   MARK: - CREATE UI
    private func createUI() {
        addingMarketNavBarView()
        addingPageCollectionView()
    }
    private func addingMarketNavBarView() {
        marketNavBarView = MarketNavBarView(dataSource: viewModel.marketNavBarItems)
        marketNavBarView?.delegate = self
        view.addSubview(marketNavBarView!)
        marketNavBarView?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            marketNavBarView!.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            marketNavBarView!.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            marketNavBarView!.widthAnchor.constraint(equalTo: view.widthAnchor),
            marketNavBarView!.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func addingPageCollectionView() {
        view.addSubview(pageCollectionView)
        NSLayoutConstraint.activate([
            pageCollectionView.topAnchor.constraint(equalTo: marketNavBarView!.bottomAnchor, constant: 10),
            pageCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            pageCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

//MARK: - MAKE INSTANCE METHOD
extension MarketViewController {
    static func makeInstance() -> MarketViewController {
        .init(viewModel: MarketViewModel())
    }
}

// MARK: - PAGECOLLECTIONVIEW DELEGATE & DATASOURCE
extension MarketViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PageMarketCollectionViewCell.identifier, for: indexPath) as! PageMarketCollectionViewCell
        cell.markets = viewModel.getMarketsForIndexPath(for: indexPath)
        cell.delegate = self
        cell.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.bounds.height)
    }
}

extension MarketViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentOffsetScale = scrollView.contentOffset.x / Constants.screenWidth
        let tab = Int(currentOffsetScale)
        marketNavBarView.selectNewCell(with: viewModel.marketNavBarItems[tab])
    }
}

extension MarketViewController: MarketViewModelProtocol {
    func likeButtonAction(with item: Market) {
        viewModel.addOrRemoveMarketLiked(market: item)
    }
    
    func shouldReloadCollectionView() {
        DispatchQueue.main.async {
            self.pageCollectionView.reloadData()
            self.pageCollectionView.layoutIfNeeded()
            if self.viewModel.firstReload {
                self.pageCollectionView.selectItem(at: .init(item: 1, section: 0), animated: false, scrollPosition: .centeredHorizontally)
                self.viewModel.firstReload = false
            }
        }
    }
}

extension MarketViewController: MarketCollectionViewDidSelectedProtocol {
    func changeViewControllerDelegate(index: IndexPath) {
        pageCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
    }
}



