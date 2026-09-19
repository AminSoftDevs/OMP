//
//  AddSecurityCodeViewController.swift
//  OMP_iOS
//
//  Created by AminSoft on 9/7/1400 AP.
//

import UIKit

class AddSecurityCodeViewController: BaseViewController {
    
    // MARK: - PROPERTIES
    private lazy var codeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configure(text: viewModel.codeLabelTitle, fontSize: 16, textColor: .textColor, textAlignment: .center, fontType: .regular)
        return label
    }()
    
    private lazy var editSecurityCodeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configure(text: viewModel.editSecurityCodeTitle, fontSize: 16, textColor: .textColor, textAlignment: .center, fontType: .bold)
        return label
    }()
    
    private lazy var firstCodeLabel: UILabel = {
        let label = UILabel()
        label.configure(text: "", fontSize: 14, textColor: .textColor, textAlignment: .center, fontType: .bold)
        label.clipsToBounds = true
        label.layer.cornerRadius = 8
        label.backgroundColor = .cardsColor
        return label
    }()
    
    private lazy var secondCodeLabel: UILabel = {
        let label = UILabel()
        label.configure(text: "", fontSize: 14, textColor: .textColor, textAlignment: .center, fontType: .bold)
        label.clipsToBounds = true
        label.layer.cornerRadius = 8
        label.backgroundColor = .cardsColor
        return label
    }()
    
    private lazy var thirdCodeLabel: UILabel = {
        let label = UILabel()
        label.configure(text: "", fontSize: 14, textColor: .textColor, textAlignment: .center, fontType: .bold)
        label.clipsToBounds = true
        label.layer.cornerRadius = 8
        label.backgroundColor = .cardsColor
        return label
    }()
    
    private lazy var fourthCodeLabel: UILabel = {
        let label = UILabel()
        label.configure(text: "", fontSize: 14, textColor: .textColor, textAlignment: .center, fontType: .bold)
        label.clipsToBounds = true
        label.layer.cornerRadius = 8
        label.backgroundColor = .cardsColor
        return label
    }()
    
    private lazy var stackLabel: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.spacing = 20
        stack.axis = .horizontal
        stack.alignment = .fill
        return stack
    }()
    
    private lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .vertical
        collectionViewFlowLayout.minimumLineSpacing = 10
        collectionViewFlowLayout.minimumInteritemSpacing = 10
        return collectionViewFlowLayout
    }()
    
    private lazy var mainCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CodeSecurityCollectionViewCell.self, forCellWithReuseIdentifier: CodeSecurityCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.bounces = false
        collectionView.semanticContentAttribute = .forceLeftToRight
        return collectionView
    }()
    
    var ofSecurityCode: Bool = false // set on/off
    
    // MARK: - INITLIZERS
    private let viewModel: SecurityCodeViewModel
    
    init(viewModel: SecurityCodeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - CONTROLLER LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBar(true)
        setBackgroundColor()
        createUI()
    }

    // MARK: - CRETE UI
    private func createUI() {
        addingDefaultNavBar()
        addedCodeLabel()
        addedStackLabel()
        addingMainCollectionView()
    }
    
    private func addingDefaultNavBar() {
        addingDefaultNavigationBarView(title: "" , hasBackButton: true, leftSideButtonName: nil, shouldHaveRadius: true)
        defaultNavigationBarView.delegate = self
    }
    
    private func addedCodeLabel() {
        view.addSubview(codeLabel)
        NSLayoutConstraint.activate([
            codeLabel.topAnchor.constraint(equalTo: defaultNavigationBarView.bottomAnchor, constant: 45),
            codeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
        ])
    }
    
    func addedEditSecurityCodeLabel() {
        view.addSubview(editSecurityCodeLabel)
        NSLayoutConstraint.activate([
            editSecurityCodeLabel.topAnchor.constraint(equalTo: defaultNavigationBarView.bottomAnchor, constant: 15),
            editSecurityCodeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
        ])
    }
    private func addedStackLabel() {
        stackLabel.addArrangedSubview(firstCodeLabel)
        stackLabel.addArrangedSubview(secondCodeLabel)
        stackLabel.addArrangedSubview(thirdCodeLabel)
        stackLabel.addArrangedSubview(fourthCodeLabel)
        view.addSubview(stackLabel)
        NSLayoutConstraint.activate([
            stackLabel.topAnchor.constraint(equalTo: codeLabel.bottomAnchor, constant: 14),
            stackLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            stackLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func addingMainCollectionView() {
        view.addSubview(mainCollectionView)
        NSLayoutConstraint.activate([
            mainCollectionView.centerXAnchor.constraint(equalTo: stackLabel.centerXAnchor),
            mainCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            mainCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            mainCollectionView.topAnchor.constraint(equalTo: stackLabel.bottomAnchor, constant: 50)
        ])
    }
    
// MARK: - OBJC FUNC
    @objc private func acceptButtonCodeTapped() {
        
        guard let code1 = firstCodeLabel.text, code1 != "" else { return }
        guard let code2 = secondCodeLabel.text, code2 != "" else { return }
        guard let code3 = thirdCodeLabel.text, code3 != "" else { return }
        guard let code4 = fourthCodeLabel.text, code4 != "" else { return }
        
        if ofSecurityCode == false {
            
            print(code1 + code2 + code3 + code4)
            KeychainData.securityCode = (code1 + code2 + code3 + code4)
            navigationController?.popToRootViewController(animated: true)
            Popup.showSuccess(body: viewModel.operationIsDone)
            print(KeychainData.securityCode)
        } else {
            if KeychainData.securityCode == (code1 + code2 + code3 + code4) {
                KeychainData.deleteSecurityCode()
                Popup.showSuccess(body: viewModel.operationIsDone)
                navigationController?.popViewController(animated: true)
            } else {
                Popup.showError(body: viewModel.correctPasswordTitle)
            }
        }
    }
    
    @objc private func deleteButtonCodeTapped() {
        if fourthCodeLabel.text != "" {
            fourthCodeLabel.text = ""
            mainCollectionView.reloadItems(at: [IndexPath.init(row: 9, section: 0)])
        } else if thirdCodeLabel.text != "" {
            thirdCodeLabel.text = ""
        } else if secondCodeLabel.text != "" {
            secondCodeLabel.text = ""
        } else if firstCodeLabel.text != "" {
            firstCodeLabel.text = ""
        }
    }
}

// MARK: - MAKE INSTANCE
extension AddSecurityCodeViewController {
    static func makeInstance() -> AddSecurityCodeViewController {
        .init(viewModel: SecurityCodeViewModel())
    }
}

//MARK: - COLLECTION VIEW DELEGATE &  DATA SOURCE
extension AddSecurityCodeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CodeSecurityCollectionViewCell.identifier, for: indexPath) as! CodeSecurityCollectionViewCell
        cell.delegate = self
        cell.numberButton.setTitle(viewModel.numberArrayData[indexPath.row])
        
        if fourthCodeLabel.text == "" && indexPath.row == 9 {
            cell.numberButton.isHidden = true
        } else if fourthCodeLabel.text != "" && indexPath.row == 9 {
            let image = UIImage(named: "is_done_white")?.withRenderingMode(.alwaysTemplate)
            cell.numberButton.setImage(image, for: .normal)
            cell.numberButton.addTarget(self, action: #selector(acceptButtonCodeTapped), for: .touchUpInside)
            cell.numberButton.isHidden = false
        }

        if indexPath.row == 11 {
            let image = UIImage(named: "clear-symbol-30")?.withRenderingMode(.alwaysTemplate)
            cell.numberButton.setImage(image, for: .normal)
            cell.numberButton.addTarget(self, action: #selector(deleteButtonCodeTapped), for: .touchUpInside)
        }
        return cell
    }
}

extension AddSecurityCodeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth: CGFloat = (collectionView.bounds.width / 3) - 10
        let cellHeight: CGFloat = cellWidth
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
// MARK: - SENDING VALUE FORM SECURITYBUTTON DELEGATE
extension AddSecurityCodeViewController: SendingValueFromSecurityButtonProtocol {
    func sendingButtonValue(value: String) {
        if firstCodeLabel.text == "" {
            firstCodeLabel.text = value
        } else if firstCodeLabel.text != "" && secondCodeLabel.text == "" {
            secondCodeLabel.text = value
        } else if secondCodeLabel.text != "" && thirdCodeLabel.text == "" {
            thirdCodeLabel.text = value
        } else if thirdCodeLabel.text != "" && fourthCodeLabel.text == "" {
            fourthCodeLabel.text = value
            mainCollectionView.reloadItems(at: [IndexPath.init(row: 9, section: 0)])
        }
    }
}

extension AddSecurityCodeViewController: UITextFieldDelegate {

}
// MARK: - DefaultNavigationBarViewProtocol
extension AddSecurityCodeViewController: DefaultNavigationBarViewProtocol {
    func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
}
