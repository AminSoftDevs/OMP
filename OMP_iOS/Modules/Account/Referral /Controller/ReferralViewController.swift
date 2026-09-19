//
//  ReferralViewController.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 11/23/21.
//

import UIKit

class ReferralViewController: BaseViewController {
    
    var referralInformationTableViewHeight = NSLayoutConstraint()
    
    private lazy var mainScrollView: UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    private lazy var referralInformationTableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 20
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .cardsColor
        tableView.register(ReferralTableViewCell.self, forCellReuseIdentifier: ReferralTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var referralDescriptionContainerView: UIView = {
       var view = UIView()
        view.backgroundColor = .cardsColor
        view.layer.cornerRadius = 20
        return view
    }()
    
    private lazy var secondContainerView: UIView = {
       var view = UIView()
        view.backgroundColor = .cardsColor
        view.layer.cornerRadius = 20
        return view
    }()
    
    private lazy var referredDescriptionTextView: UITextView = {
        var textView = UITextView()
        textView.text = "ReferralViewController.referredDescription".localized
        textView.isEditable  = false
        textView.font = UIFont(type: .regular, fontSize: 13)
        textView.textColor = .textColor
        textView.textAlignment = .right
        textView.backgroundColor = .clear
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = UIEdgeInsets.zero
        textView.isScrollEnabled = false
        return textView
    }()
    
    private lazy var referredByCodeTitleLabel: UILabel = {
       var label = UILabel()
        label.configure(text: "ReferralViewController.enterReferralCode".localized, fontSize: 14, textColor: .mediumGrayColor, textAlignment: .right, fontType: .regular)
        return label
    }()
    private lazy var referredByCodeTextField: UITextField = {
       var textField = UITextField()
        textField.configure(placeholder: "", borderColor: .clear, fontSize: 13, fontType: .regular, keyboardType: .default, textAlignment: .center, radius: 15, backgroundColor: .backgroundColor, textColor: .textColor)
        return textField
    }()
    
    private lazy var submitReferralCodeButton: UIButton = {
       var button = UIButton()
        button.configure(fontSize: 13, title: "keyboard.done".localized, fontType: .regular, titleColor: .backgroundColor, backgroundColor: .submitButtonColor, borderColor: .clear, cornerRadius: 15)
        button.addTarget(self, action: #selector(submitReferralCodeButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var invitationCodeCreationViewController = InvitationCodeCreationViewController.makeInstance()
    lazy var referralStatsView: ReferralStatsView = ReferralStatsView()
    lazy var yourReferralCodeView: YourReferralCodeView = YourReferralCodeView(referred: viewModel.isThereReferralCode)
    lazy var referredByTitleView: ReferralTitleView = ReferralTitleView(title: "ReferralViewController.referredByTitleView".localized)
    
    //MARK: - INITIALIZER
    private let viewModel: ReferralControllerViewModel
    
    init(viewModel: ReferralControllerViewModel) {
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
        addingDefaultNavBar()
        viewModel.delegate = self
        invitationCodeCreationViewController.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getReferralsDetails()
    }
    
    //MARK: - CREATE UI
    private func createUI() {
        addingMainScrollView()
        //1
        addingInvitationCodeCreationViewController()
        //2
        addingSecondContainerView()
        addingYourReferralCodeView()
        //3
        addingReferralStatsView()
        //4
        addingReferralInformationTableView()
        
        //5
        addingReferralDescriptionContainerView()
        addingReferralDescriptionContainerViewTitleView()
        
        if viewModel.isUserReferred {
            addingWalletAddressTextView()
        } else {
            addingReferredByCodeTitleLabel()
            addingReferredByCodeTextField()
            addingSubmitReferralCodeButton()
        }
    }
    
    private func addingDefaultNavBar() {
        addingDefaultNavigationBarView(title: viewModel.navTitle, hasBackButton: true, leftSideButtonName: "info_icon", shouldHaveRadius: true)
        defaultNavigationBarView.delegate = self
    }
    
    private func addingMainScrollView() {
        view.addSubview(mainScrollView)
        mainScrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainScrollView.topAnchor.constraint(equalTo: defaultNavigationBarView.bottomAnchor, constant: 10),
            mainScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    //MARK: - invitation Code Creation Container View
    private func addingInvitationCodeCreationViewController() {
        add(invitationCodeCreationViewController, into: mainScrollView)
        invitationCodeCreationViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            invitationCodeCreationViewController.view.topAnchor.constraint(equalTo: mainScrollView.topAnchor),
            invitationCodeCreationViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            invitationCodeCreationViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            invitationCodeCreationViewController.view.heightAnchor.constraint(equalToConstant: 395)
        ])
    }
    
    //MARK: - created Code Container View
    private func addingSecondContainerView() {
        mainScrollView.addSubview(secondContainerView)
        secondContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            secondContainerView.topAnchor.constraint(equalTo: invitationCodeCreationViewController.view.bottomAnchor, constant: 10),
            secondContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            secondContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func addingYourReferralCodeView() {
        secondContainerView.addSubview(yourReferralCodeView)
        yourReferralCodeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            yourReferralCodeView.topAnchor.constraint(equalTo: secondContainerView.topAnchor),
            yourReferralCodeView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            yourReferralCodeView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            secondContainerView.heightAnchor.constraint(equalTo: yourReferralCodeView.heightAnchor)
        ])
    }
    
    //MARK: - referred Users Statistics ContainerView
    private func addingReferralStatsView() {
        mainScrollView.addSubview(referralStatsView)
        referralStatsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            referralStatsView.topAnchor.constraint(equalTo: secondContainerView.bottomAnchor, constant: 10),
            referralStatsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            referralStatsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            referralStatsView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    //MARK: - Referral Table View
    private func addingReferralInformationTableView() {
        mainScrollView.addSubview(referralInformationTableView)
        referralInformationTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            referralInformationTableView.topAnchor.constraint(equalTo: referralStatsView.bottomAnchor, constant: 10),
            referralInformationTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            referralInformationTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        referralInformationTableViewHeight = referralInformationTableView.heightAnchor.constraint(equalToConstant: 100)
        referralInformationTableViewHeight.isActive = true
    }
    
    //MARK: - Referral Description Container View
    private func addingReferralDescriptionContainerView() {
        mainScrollView.addSubview(referralDescriptionContainerView)
        referralDescriptionContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            referralDescriptionContainerView.topAnchor.constraint(equalTo: referralInformationTableView.bottomAnchor, constant: 10),
            referralDescriptionContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            referralDescriptionContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            referralDescriptionContainerView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor)
        ])
    }
    
    private func addingReferralDescriptionContainerViewTitleView() {
        referralDescriptionContainerView.addSubview(referredByTitleView)
        referredByTitleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            referredByTitleView.topAnchor.constraint(equalTo: referralDescriptionContainerView.topAnchor , constant: 15),
            referredByTitleView.leadingAnchor.constraint(equalTo: referralDescriptionContainerView.leadingAnchor , constant: 20),
            referredByTitleView.trailingAnchor.constraint(equalTo: referralDescriptionContainerView.trailingAnchor , constant: -20),
            referredByTitleView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func addingWalletAddressTextView() {
        referralDescriptionContainerView.addSubview(referredDescriptionTextView)
        referredDescriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            referredDescriptionTextView.topAnchor.constraint(equalTo: referredByTitleView.bottomAnchor, constant: -10),
            referredDescriptionTextView.leadingAnchor.constraint(equalTo: referralDescriptionContainerView.leadingAnchor, constant: 20),
            referredDescriptionTextView.trailingAnchor.constraint(equalTo: referralDescriptionContainerView.trailingAnchor, constant: -20),
            referredDescriptionTextView.bottomAnchor.constraint(equalTo: referralDescriptionContainerView.bottomAnchor, constant: -10),
        ])
        
        let sizeThatFitsTextView = referredDescriptionTextView.sizeThatFits(CGSize(width: Constants.screenWidth - 40, height: CGFloat(MAXFLOAT)))
        
        let height = referralDescriptionContainerView.heightAnchor.constraint(equalToConstant: sizeThatFitsTextView.height +  80)
        height.priority = UILayoutPriority(750)
        height.isActive = true
    }
    
    private func addingReferredByCodeTitleLabel() {
        referralDescriptionContainerView.addSubview(referredByCodeTitleLabel)
        referredByCodeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            referredByCodeTitleLabel.topAnchor.constraint(equalTo: referredByTitleView.bottomAnchor, constant: 10),
            referredByCodeTitleLabel.trailingAnchor.constraint(equalTo: referredByTitleView.trailingAnchor, constant: 0),
        ])
    }
    
    private func addingReferredByCodeTextField() {
        referralDescriptionContainerView.addSubview(referredByCodeTextField)
        referredByCodeTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            referredByCodeTextField.topAnchor.constraint(equalTo: referredByCodeTitleLabel.bottomAnchor, constant: 10),
            referredByCodeTextField.trailingAnchor.constraint(equalTo: referredByCodeTitleLabel.trailingAnchor, constant: 0),
            referredByCodeTextField.heightAnchor.constraint(equalToConstant: 60),
            referredByCodeTextField.widthAnchor.constraint(equalTo: referralDescriptionContainerView.widthAnchor, multiplier: 0.7)
        ])
    }
    
    private func addingSubmitReferralCodeButton() {
        referralDescriptionContainerView.addSubview(submitReferralCodeButton)
        submitReferralCodeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            submitReferralCodeButton.centerYAnchor.constraint(equalTo: referredByCodeTextField.centerYAnchor),
            submitReferralCodeButton.trailingAnchor.constraint(equalTo: referredByCodeTextField.leadingAnchor, constant: -20),
            submitReferralCodeButton.heightAnchor.constraint(equalToConstant: 48),
            submitReferralCodeButton.leadingAnchor.constraint(equalTo: referralDescriptionContainerView.leadingAnchor, constant: 10)
        ])
        
        let height = referralDescriptionContainerView.heightAnchor.constraint(equalToConstant: 200)
        height.priority = UILayoutPriority(750)
        height.isActive = true
    }
    
    private func changeReferralDescriptionContainerView() {
        let views = [referredByCodeTitleLabel, referredByCodeTextField, submitReferralCodeButton]
        UIView.animate(withDuration: 0.3) {
            views.forEach{($0.alpha = 0)}
        } completion: { _ in
            views.forEach({$0.removeFromSuperview()})
            self.addingWalletAddressTextView()
        }
    }
    
    private func changeInvitationCodeCreationViewController() {
        UIView.animate(withDuration: 0.3) {
            self.yourReferralCodeView.alpha = 0
        } completion: { _ in
            self.yourReferralCodeView.removeFromSuperview()
            self.addingYourReferralCodeView()
            self.yourReferralCodeView.alpha = 1
        }
    }
    
    //MARK: - OBJC FUNCTIONS
    @objc func submitReferralCodeButtonPressed() {
        guard let text = referredByCodeTextField.text, text.isEmpty == false  else { return }
        viewModel.referredByCode = text
        viewModel.addReferredByCode()
    }
}

//MARK: - Referral Information Table View
extension ReferralViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInReferralTable
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReferralTableViewCell.identifier, for: indexPath) as! ReferralTableViewCell
        cell.referral = viewModel.getReferralForRowAt(indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ReferralTableHeaderView()
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

extension ReferralViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

//MARK: - MAKE INSTANCE METHOD
extension ReferralViewController {
    static func makeInstance(userInfo: UserInfo) -> ReferralViewController {
        .init(viewModel: ReferralControllerViewModel(userInfo: userInfo))
    }
}

// MARK: - DefaultNavigationBarViewProtocol
extension ReferralViewController: DefaultNavigationBarViewProtocol {
    func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    func leftSideButtonPressed() {
        let noticePopup = ReferralNoticeViewController()
        noticePopup.modalTransitionStyle = .crossDissolve
        noticePopup.modalPresentationStyle = .overFullScreen
        present(noticePopup, animated: true, completion: nil)
    }
}

// MARK: - Referral Controller ViewModel Protocol
extension ReferralViewController: ReferralControllerViewModelProtocol {
    func userHasCreatedNewInvitationCode() {
        //changeInvitationCodeCreationViewController()
        viewModel.getReferralsDetails()
    }
    
    func youHaveSubmittedReferralCode() {
        changeReferralDescriptionContainerView()
    }
    
    func NowWeCanCreateUI() {
        if viewModel.uiCreated == false {
            createUI()
            viewModel.uiCreated = true
        } else {
            changeInvitationCodeCreationViewController()
        }
    }
    
    func updateInvitationCodeAndLink(code: String, link: String) {
        yourReferralCodeView.updateInvitationCodeAndLink(code: code, link: link)
    }
    
    func updateReferralsTable() {
        referralInformationTableView.reloadData()
        UIView.animate(withDuration: 0.3) {
            self.referralInformationTableViewHeight.constant = 80 + CGFloat(self.viewModel.numberOfRowsInReferralTable * 50)
            self.mainScrollView.layoutIfNeeded()
        }
    }
    
    func statsReceived(friends: String, benefits: String) {
        referralStatsView.updateValues(numberOfFriends: friends, totalBenefits: benefits)
    }
}
