//
//  ProfileViewController.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 8/22/21.
//

import UIKit

class ProfileViewController: BaseViewController {

    private lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .vertical
        return collectionViewFlowLayout
    }()
    
    private lazy var profileCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.register(PersonalInfoCollectionViewCell.self, forCellWithReuseIdentifier: PersonalInfoCollectionViewCell.identifier)
        collectionView.register(EditPasswordCollectionViewCell.self, forCellWithReuseIdentifier: EditPasswordCollectionViewCell.identifier)
        collectionView.register(AccountStateCollectionViewCell.self, forCellWithReuseIdentifier: AccountStateCollectionViewCell.identifier)
        collectionView.register(BankInformationCollectionViewCell.self, forCellWithReuseIdentifier: BankInformationCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.bounces = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    //MARK: - INITIALIZER
    private let viewModel: ProfileControllerViewModel
    
    init(viewModel: ProfileControllerViewModel) {
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
        
        viewModel.getCreditCardsList()
        viewModel.getBankAccountList()
        
        viewModel.delegate = self
    }
    
    //MARK: - CREATE UI
    private func createUI() {
        addingDefaultNavBar()
        addingProfileCollectionView()
    }
    
    private func addingDefaultNavBar() {
        addingDefaultNavigationBarView(title: viewModel.navigationTitle, hasBackButton: true, shouldHaveRadius: true)
        defaultNavigationBarView.delegate = self
    }
    
    private func addingProfileCollectionView() {
        view.addSubview(profileCollectionView)
        profileCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileCollectionView.topAnchor.constraint(equalTo: defaultNavigationBarView.bottomAnchor, constant: 15),
            profileCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

//MARK: - COLLECTION VIEW DELEGATE
extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 10, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.getItemSizeFor(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 0.3) {
            cell.alpha = 1
        }
    }
}

//MARK: - COLLECTION VIEW DATA SOURCE
extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PersonalInfoCollectionViewCell.identifier, for: indexPath) as! PersonalInfoCollectionViewCell
            cell.userInfo = viewModel.getUserInfo
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EditPasswordCollectionViewCell.identifier, for: indexPath) as! EditPasswordCollectionViewCell
            cell.delegate = self
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AccountStateCollectionViewCell.identifier, for: indexPath) as! AccountStateCollectionViewCell
            cell.userInfo = viewModel.getUserInfo
            return cell
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BankInformationCollectionViewCell.identifier, for: indexPath) as! BankInformationCollectionViewCell
            cell.delegate = self
            cell.creditCardList = viewModel.getCreditCards
            cell.bankAccountList = viewModel.getBankAccounts
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

extension ProfileViewController: ProfileControllerViewModelProtocol {
    func bankAccountListReceived() {
        let indexPath = IndexPath(item: 3, section: 0)
        profileCollectionView.reloadItems(at: [indexPath])
    }
    
    func creditCardsListReceived() {
        let indexPath = IndexPath(item: 3, section: 0)
        profileCollectionView.reloadItems(at: [indexPath])
    }
    
    func creditCardTemplateOnScreen(status: Bool) {
        if status {
            viewModel.bankInfoHeight += 180
        } else {
            viewModel.bankInfoHeight -= 180
            
        }
        profileCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    func storedCreditCardsTableHeight(height: CGFloat) {
        viewModel.bankInfoHeight = height
        profileCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    func newBankInfoAdded(type: BankInformationType, number: String) {
        if type == .profileCredit {
            viewModel.addNewCreditCard(with: number)
        } else if type == .profileAccount {
            viewModel.addNewBankAccount(with: number)
        }
    }
    
    func deleteBankInfo(type: BankInformationType, item: BankInfoAdapter) {
        if type == .profileCredit {
            viewModel.deleteCreditCard(with: String(item.id))
        } else if type == .profileAccount {
            viewModel.deleteBankAccount(with: String(item.id))
        }
    }
    
    func editPasswordButtonPressed() {
        let vc = ChangePasswordViewController.makeInstance()
        show(vc, sender: self)
    }
}

//MARK: - NAVIGATION BAR DELEGATE
extension ProfileViewController: DefaultNavigationBarViewProtocol {
    func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - MAKE INSTANCE
extension ProfileViewController {
    static func makeInstance(userInfo: UserInfo?) -> ProfileViewController {
        .init(viewModel: ProfileControllerViewModel(userInfo: userInfo))
    }
}
