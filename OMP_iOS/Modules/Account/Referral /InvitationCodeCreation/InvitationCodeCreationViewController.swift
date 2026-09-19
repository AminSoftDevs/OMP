//
//  InvitationCodeCreationViewController.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 11/24/21.
//

import UIKit
import MHLoadingButton

class InvitationCodeCreationViewController: BaseViewController {
    
    private lazy var invitationCodeCreationDescriptionLabel: UILabel = {
        var label = UILabel()
        label.configure(text: "ReferralViewController.invitationCodeCreationDescription".localized, fontSize: 15, textColor: .mediumGrayColor, textAlignment: .natural, fontType: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var mainStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 15
        return stackView
    }()
    
    private lazy var yourShareContainerView: UIView = {
        var view = UIView()
        view.backgroundColor = .backgroundColor
        view.layer.cornerRadius = 15
        return view
    }()
    
    private lazy var yourShareStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 0
        return stackView
    }()
    
    private lazy var yourShareTitleLabel: UILabel = {
        var label = UILabel()
        label.configure(text: "InvitationCodeCreationViewController.yourShareTitle".localized, fontSize: 16, textColor: .textColor, textAlignment: .center, fontType: .regular)
        return label
    }()
    
    private lazy var yourShareValueLabel: UILabel = {
        var label = UILabel()
        label.configure(text: viewModel.getYourShare, fontSize: 15, textColor: .textColor, textAlignment: .center, fontType: .regular)
        return label
    }()
    
    private lazy var friendsShareContainerView: UIView = {
        var view = UIView()
        view.backgroundColor = .backgroundColor
        view.layer.cornerRadius = 15
        return view
    }()
    
    private lazy var friendsShareStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 0
        return stackView
    }()
    
    private lazy var friendsShareTitleLabel: UILabel = {
        var label = UILabel()
        label.configure(text: "InvitationCodeCreationViewController.friendsShareTitle".localized, fontSize: 16, textColor: .textColor, textAlignment: .center, fontType: .regular)
        return label
    }()
    
    private lazy var friendsShareValueLabel: UILabel = {
        var label = UILabel()
        label.configure(text: viewModel.getFriendShare, fontSize: 15, textColor: .textColor, textAlignment: .center, fontType: .regular)
        return label
    }()
    
    private lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .horizontal
        return collectionViewFlowLayout
    }()
    
    private lazy var mainCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.register(CommissionShareCollectionViewCell.self, forCellWithReuseIdentifier: CommissionShareCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.transform = dir == .leftToRight ? CGAffineTransform(scaleX: -1.0, y: 1.0) : CGAffineTransform(scaleX: 1.0, y: 1.0)
        return collectionView
    }()
    
    private lazy var createInvitationCodeButton: LoadingButton = {
       var button = LoadingButton()
        button.configure(fontSize: 14, title: "InvitationCodeCreationViewController.createInvitationCodeButton".localized, fontType: .regular, titleColor: .cardsColor, backgroundColor: .submitButtonColor, borderColor: .clear, cornerRadius: 10)
        button.indicator = BallPulseSyncIndicator(color: .gray)
        button.cornerRadius  = 10
        button.bgColor = .submitButtonColor
        button.indicator.color = .cardsColor
        button.addTarget(self, action: #selector(createInvitationCodeButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let dir = Localization.sharedInstance.getlanguageDirection()
    
    lazy var createCodeTitleView: ReferralTitleView = ReferralTitleView(title: "ReferralViewController.createCodeTitleView".localized)
    
    weak var delegate: ReferralControllerViewModelProtocol?
    
    //MARK: - INITIALIZER
    private let viewModel: InvitationCodeCreationViewModel
    
    init(viewModel: InvitationCodeCreationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - VIEW CONTROLLER LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor(.cardsColor)
        hideNavigationBar(true)
        view.layer.cornerRadius = 20
        createUI()
        
        viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .centeredHorizontally)
    }
    
    //MARK: - CREATE UI
    private func createUI() {
        addingCreateCodeTitleView()
        addingInvitationCodeCreationDescriptionLabel()
        addingMainStackView()
        addingSharePercentsCollectionView()
        addingCreateInvitationCodeButton()
    }
    
    private func addingCreateCodeTitleView() {
        view.addSubview(createCodeTitleView)
        createCodeTitleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            createCodeTitleView.topAnchor.constraint(equalTo: view.topAnchor , constant: 15),
            createCodeTitleView.leadingAnchor.constraint(equalTo: view.leadingAnchor , constant: 20),
            createCodeTitleView.trailingAnchor.constraint(equalTo: view.trailingAnchor , constant: -20),
            createCodeTitleView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func addingInvitationCodeCreationDescriptionLabel() {
        view.addSubview(invitationCodeCreationDescriptionLabel)
        invitationCodeCreationDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            invitationCodeCreationDescriptionLabel.topAnchor.constraint(equalTo: createCodeTitleView.bottomAnchor , constant: 20),
            invitationCodeCreationDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor , constant: 20),
            invitationCodeCreationDescriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor , constant: -20),
        ])
    }
    
    private func addingMainStackView() {
        view.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: invitationCodeCreationDescriptionLabel.bottomAnchor , constant: 20),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor , constant: 12),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor , constant: -12),
            mainStackView.heightAnchor.constraint(equalToConstant: 100)
        ])
        //config
        mainStackViewConfig()
    }
    
    private func mainStackViewConfig() {
        addingFriendsShareStackViewToContainer()
        addingYourShareStackViewToContainer()
        
        mainStackView.addArrangedSubview(friendsShareContainerView)
        mainStackView.addArrangedSubview(yourShareContainerView)
    }
    
    private func addingFriendsShareStackViewToContainer() {
        friendsShareContainerView.addSubview(friendsShareStackView)
        friendsShareStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            friendsShareStackView.topAnchor.constraint(equalTo: friendsShareContainerView.topAnchor, constant: 8),
            friendsShareStackView.leadingAnchor.constraint(equalTo: friendsShareContainerView.leadingAnchor),
            friendsShareStackView.trailingAnchor.constraint(equalTo: friendsShareContainerView.trailingAnchor),
            friendsShareStackView.bottomAnchor.constraint(equalTo: friendsShareContainerView.bottomAnchor, constant: -8),
        ])
        
        friendsShareStackView.addArrangedSubview(friendsShareTitleLabel)
        friendsShareStackView.addArrangedSubview(friendsShareValueLabel)
    }
    
    private func addingYourShareStackViewToContainer() {
        yourShareContainerView.addSubview(yourShareStackView)
        yourShareStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            yourShareStackView.topAnchor.constraint(equalTo: yourShareContainerView.topAnchor, constant: 8),
            yourShareStackView.leadingAnchor.constraint(equalTo: yourShareContainerView.leadingAnchor),
            yourShareStackView.trailingAnchor.constraint(equalTo: yourShareContainerView.trailingAnchor),
            yourShareStackView.bottomAnchor.constraint(equalTo: yourShareContainerView.bottomAnchor, constant: -8)
        ])
        
        yourShareStackView.addArrangedSubview(yourShareTitleLabel)
        yourShareStackView.addArrangedSubview(yourShareValueLabel)
    }
    
    private func addingSharePercentsCollectionView() {
        view.addSubview(mainCollectionView)
        mainCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainCollectionView.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 15),
            mainCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            mainCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            mainCollectionView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func addingCreateInvitationCodeButton() {
        view.addSubview(createInvitationCodeButton)
        createInvitationCodeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            createInvitationCodeButton.topAnchor.constraint(equalTo: mainCollectionView.bottomAnchor, constant: 20),
            createInvitationCodeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            createInvitationCodeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            createInvitationCodeButton.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
    
    //MARK: - OBJC FUNCTION
    @objc func createInvitationCodeButtonPressed() {
        createInvitationCodeButton.showLoader(userInteraction: false)
        viewModel.createNewInvitationCode()
    }
}

//MARK: - COLLECTION VIEW DATA SOURCE
extension InvitationCodeCreationViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsForCollectionView
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: CommissionShareCollectionViewCell.identifier, for: indexPath) as! CommissionShareCollectionViewCell
        item.valueLabel.text = viewModel.valueForItemAt(indexPath: indexPath)
        item.backgroundView = nil
        return item
    }
}
//MARK: - COLLECTION VIEW DELEGATE
extension InvitationCodeCreationViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: CommissionShareCollectionViewCell.identifier, for: indexPath) as! CommissionShareCollectionViewCell
        item.isSelected = true
        viewModel.selectedItemFromCommissionCollectionView(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: CommissionShareCollectionViewCell.identifier, for: indexPath) as! CommissionShareCollectionViewCell
        item.isSelected = false
    }
}

//MARK: - COLLECTION VIEW FLOW DELEGATE
extension InvitationCodeCreationViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 48, height: 48)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 5, bottom: 0, right: 5)
    }
}

//MARK: - MAKE INSTANCE METHOD
extension InvitationCodeCreationViewController {
    static func makeInstance() -> InvitationCodeCreationViewController {
        .init(viewModel: InvitationCodeCreationViewModel())
    }
}

//MARK: - VIEW MODEL DELEGATE
extension InvitationCodeCreationViewController: InvitationCodeCreationViewModelProtocol {
    func responseReceivedStopLoading() {
        createInvitationCodeButton.hideLoader()
        delegate?.userHasCreatedNewInvitationCode()
    }
    
    func percentsValuesShouldUpdate() {
        yourShareValueLabel.text = viewModel.getYourShare
        friendsShareValueLabel.text = viewModel.getFriendShare
    }
}
