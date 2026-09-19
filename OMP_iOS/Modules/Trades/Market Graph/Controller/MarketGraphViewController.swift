//
//  NewMarketGraphViewController.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 11/8/21.
//

import UIKit

class MarketGraphViewController: BaseViewController {
    
    private var collectionViewTopAnchorPortrait = NSLayoutConstraint()
    private var collectionViewTopAnchorLandscape = NSLayoutConstraint()
    
    private lazy var navigationBarContainerView: UIView = {
        var view = UIView()
        view.backgroundColor = .cardsColor
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.configure(text: viewModel.navigationTitle, fontSize: Constants.navFontSize , textColor: .textColor, textAlignment: .center, fontType: .regular)
        return label
    }()
    
    private lazy var backButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(named: "back_arrow_icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        button.tintColor = .textColor
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 0.8
        button.layer.borderColor = UIColor.mediumGrayColor.cgColor
        button.imageView?.transform = dir == .leftToRight ? CGAffineTransform(scaleX: -1, y: 1) : CGAffineTransform(scaleX: 1, y: 1)
        return button
    }()
    
    private lazy var landscapeButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(named: "to_ fullScree_icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.setImage(UIImage(named: "from_landscape_icon")?.withRenderingMode(.alwaysTemplate), for: .selected)
        button.addTarget(self, action: #selector(landscapeButtonPressed), for: .touchUpInside)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 0.8
        button.tintColor = .textColor
        button.layer.borderColor = UIColor.mediumGrayColor.cgColor
        button.imageView?.layer.transform = CATransform3DMakeScale(0.7, 0.7, 0.7)
        return button
    }()
    
    lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .horizontal
        collectionViewFlowLayout.sectionInset = .zero
        collectionViewFlowLayout.minimumLineSpacing = 0
        collectionViewFlowLayout.minimumInteritemSpacing = 0
        return collectionViewFlowLayout
    }()
    
    lazy var mainCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.register(MarketGraphCollectionViewCell.self, forCellWithReuseIdentifier: MarketGraphCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.bounces = false
        collectionView.layer.cornerRadius = 10
        collectionView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = false
        collectionView.semanticContentAttribute = .forceLeftToRight
        return collectionView
    }()
    
    let dir = Localization.sharedInstance.getlanguageDirection()
    
    lazy var marketGraphSelectableTitlesView: SecondaryMarketNavBarView = .init(type: .marketGraph)
    
    //MARK: - INITIALIZER
    private let viewModel: MarketGraphViewModel
    
    init(viewModel: MarketGraphViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - VIEW CONTROLLER LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = viewModel.backgroundSyncWithTheme()
        hideNavigationBar(true)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        createUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        RotationHandler.lockOrientation(.portrait)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        RotationHandler.lockOrientation(.allButUpsideDown)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate { _ in
            self.mainCollectionView.collectionViewLayout.invalidateLayout()
            self.mainCollectionView.scrollToItem(at: self.viewModel.currentPage, at: .centeredHorizontally, animated: true)
        }
        
        if UIDevice.current.orientation.isPortrait {
            showStatusBarAddedView()
            addingDefaultNavBar()
            collectionViewTopAnchorLandscape.isActive = false
            collectionViewTopAnchorPortrait.isActive = true
        } else {
            hideStatusBarAddedView()
            navigationBarContainerView.removeFromSuperview()
            marketGraphSelectableTitlesView.removeFromSuperview()
            collectionViewTopAnchorLandscape.isActive = true
            collectionViewTopAnchorPortrait.isActive = false
        }
    }
    
    //MARK: - CREATE UI
    private func createUI() {
        addingDefaultNavBar()
        addingMainCollectionView()
    }
    
    private func addingDefaultNavBar() {
        addingNavigationBarContainerView()
        addingBackButton()
        addingTitleLabel()
        addingLandscapeButtonPressed()
        addingSelectableNavigationTitles()
    }
    
    private func addingNavigationBarContainerView() {
        view.addSubview(navigationBarContainerView)
        navigationBarContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            navigationBarContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBarContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBarContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBarContainerView.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    private func addingBackButton() {
        navigationBarContainerView.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.centerYAnchor.constraint(equalTo: navigationBarContainerView.centerYAnchor),
            backButton.trailingAnchor.constraint(equalTo: navigationBarContainerView.trailingAnchor, constant: -10),
            backButton.widthAnchor.constraint(equalToConstant: 35),
            backButton.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    private func addingTitleLabel() {
        navigationBarContainerView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: navigationBarContainerView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor, constant: 4)
        ])
    }
    
    private func addingLandscapeButtonPressed() {
        navigationBarContainerView.addSubview(landscapeButton)
        landscapeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            landscapeButton.centerYAnchor.constraint(equalTo: navigationBarContainerView.centerYAnchor),
            landscapeButton.leadingAnchor.constraint(equalTo: navigationBarContainerView.leadingAnchor, constant: 15),
            landscapeButton.widthAnchor.constraint(equalToConstant: 30),
            landscapeButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func addingSelectableNavigationTitles() {
        view.addSubview(marketGraphSelectableTitlesView)
        marketGraphSelectableTitlesView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            marketGraphSelectableTitlesView.topAnchor.constraint(equalTo: navigationBarContainerView.bottomAnchor),
            marketGraphSelectableTitlesView.leadingAnchor.constraint(equalTo: navigationBarContainerView.leadingAnchor),
            marketGraphSelectableTitlesView.trailingAnchor.constraint(equalTo: navigationBarContainerView.trailingAnchor),
            marketGraphSelectableTitlesView.heightAnchor.constraint(equalToConstant: 50)
        ])
        marketGraphSelectableTitlesView.delegate = self
    }
    
    private func addingMainCollectionView() {
        view.addSubview(mainCollectionView)
        mainCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        collectionViewTopAnchorPortrait = mainCollectionView.topAnchor.constraint(equalTo: marketGraphSelectableTitlesView.bottomAnchor, constant: 10)
        collectionViewTopAnchorPortrait.isActive = true
        
        collectionViewTopAnchorLandscape = mainCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        collectionViewTopAnchorLandscape.priority = UILayoutPriority(750)
        collectionViewTopAnchorLandscape.isActive = true
    }
    
    private func hideStatusBarAddedView() {
        let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        if let statusBarView = keyWindow?.subviews.first(where: { $0.tag == 1000 }) {
            statusBarView.isHidden = true
        }
    }

    private func showStatusBarAddedView() {
        let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        if let statusBarView = keyWindow?.subviews.first(where: { $0.tag == 1000 }) {
            statusBarView.isHidden = false
        }
    }
    
    //MARK: - OBJC FUNCTIONS
    @objc func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func landscapeButtonPressed() {
        landscapeButton.isSelected = !landscapeButton.isSelected
        if landscapeButton.isSelected {
            let value = UIInterfaceOrientation.landscapeRight.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
            hideStatusBarAddedView()
        } else {
            let value = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
            showStatusBarAddedView()
        }
    }
}


//MARK: - MAKE INSTANCE METHOD
extension MarketGraphViewController {
    static func makeInstance(marketSymbol: String, marketName: String) -> MarketGraphViewController {
        .init(viewModel: MarketGraphViewModel(symbol: marketSymbol, name: marketName))
    }
}

//MARK: - COLLECTION VIEW DELEGATE &  DATA SOURCE
extension MarketGraphViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

extension MarketGraphViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfMarkets
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MarketGraphCollectionViewCell.identifier, for: indexPath) as! MarketGraphCollectionViewCell
        cell.marketGraph = viewModel.getItemForRowAt(index: indexPath.row)
        return cell
    }
}

extension MarketGraphViewController: MarketDelegate {
    func selectedNavItem(type: MarketsType) {
        viewModel.currentTab = type
        mainCollectionView.scrollToItem(at: viewModel.currentPage, at: .centeredHorizontally, animated: true)
    }
}
