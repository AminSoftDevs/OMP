//
//  ChangeLanguageViewController.swift
//  OMP_iOS
//
//  Created by AminSoft on 1/17/1401 AP.
//

import UIKit
import DropDown

class ChangeLanguageViewController: BaseViewController {
    
    //MARK: - PROPERTIES
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configure(text: "ChangeLanguageViewController.titleLabel".localized, fontSize: 16, textColor: .textColor, textAlignment: .center, fontType: .regular)
        return label
    }()
    
    private lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.image = UIImage(named: "Change_language")
        return imageView
    }()
    
    private lazy var showLanguageListDropDown: DropDown = {
        let dropDown = DropDown()
        dropDown.translatesAutoresizingMaskIntoConstraints = false
        dropDown.backgroundColor = .cardsColor
        dropDown.textFont = UIFont(type: .regular, fontSize: 14)
        dropDown.textColor = .textColor
        dropDown.selectionBackgroundColor = .clear
        dropDown.selectedTextColor = .selectedDropDownItemColor
        dropDown.cornerRadius = 15
        dropDown.cellHeight = 50
        dropDown.width = Constants.screenWidth - 32
        dropDown.cellNib = UINib(nibName: "DropDownCustomTableViewCell", bundle: nil)
        dropDown.dimmedBackgroundColor = UIColor.black.withAlphaComponent(0.3)
        return dropDown
    }()
    
    private lazy var dropDownOpenedView: OpenedSelectedLanguageDropDownView = {
        let view = OpenedSelectedLanguageDropDownView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = UIColor.textColor.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 12
        view.delegate = self
        return view
    }()
    
    private lazy var changeLanguageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configure(fontSize: 14, title: "ChangeLanguageViewController.SelectingLanguageButton".localized, fontType: .regular, titleColor: .textColor, backgroundColor: .cardsColor, borderColor: .clear, cornerRadius: 12)
        button.addTarget(self, action: #selector(changeLanguageButtonDidTapped), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    private var selectedLanguage: Int?
    
    private let viewModel: ChangeLanguageViewModel
    //MARK: - INITILEZERS
    init(viewModel: ChangeLanguageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - VIEW CONTROLLER LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor()
        hideNavigationBar(true)
        createUI()
        
        // Configure DropDown
        configureLanguageListDropDown()
        dropDownActionsHandler()
        
        setupLanguagesInFirstRun()
    }
    
    //MARK: - CREATE UI
    private func createUI() {
        addingTitleLabel()
        addingMainImageView()
        addingChangeLanguageDropDown()
        addingChangeLanguageButton()
    }
    
    private func addingTitleLabel() {
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 48)
        ])
    }
    
    private func addingMainImageView() {
        view.addSubview(mainImageView)
        NSLayoutConstraint.activate([
            mainImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 25),
            mainImageView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -30),
            mainImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4)
        ])
    }
    
    private func addingChangeLanguageDropDown() {
        view.addSubview(dropDownOpenedView)
        NSLayoutConstraint.activate([
            dropDownOpenedView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            dropDownOpenedView.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: 20),
            dropDownOpenedView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            dropDownOpenedView.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func addingChangeLanguageButton() {
        view.addSubview(changeLanguageButton)
        NSLayoutConstraint.activate([
            changeLanguageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            changeLanguageButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -28),
            changeLanguageButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50),
            changeLanguageButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    //MARK: - OBJC FUNC
    @objc private func changeLanguageButtonDidTapped() {
        guard let selectedLanguage = selectedLanguage else {
            return
        }
        viewModel.handleNewLanguageSelection(by: selectedLanguage)
    }

    // MARK: - HANDLE NEW LANGUAGE SELECTION
    private func dropDownActionsHandler() {
        showLanguageListDropDown.cancelAction = { [weak self] in
            self?.dropDownOpenedView.normalField()
            self?.dropDownOpenedView.arrowImageView.tintColor = .textColor
        }

        showLanguageListDropDown.willShowAction = { [weak self] in
            self?.dropDownOpenedView.highlightedField()
            self?.dropDownOpenedView.arrowImageView.tintColor = .submitButtonColor
        }
    }
    
    private func configureLanguageListDropDown() {
        showLanguageListDropDown.dataSource = viewModel.languageDataSource
        showLanguageListDropDown.anchorView = dropDownOpenedView
        showLanguageListDropDown.reloadAllComponents()
        
        showLanguageListDropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? DropDownCustomTableViewCell else { return }
            
            cell.optionLabel.textAlignment = .center
            cell.optionLabel.text = item
            cell.customSeparator()
        }
        
 
        
        showLanguageListDropDown.selectionAction = { [weak self] (index, item) in
            self?.dropDownOpenedView.titleLabel.text = item
            self?.selectedLanguage = index
            self?.changeLanguageButton.isEnabled = true
            self?.dropDownOpenedView.normalField()
            self?.dropDownOpenedView.arrowImageView.tintColor = .textColor
        }
    }
    
    private func setupLanguagesInFirstRun() {
        if self.viewModel.timeZone == "Asia/Tehran" {
            showLanguageListDropDown.selectRow(0, scrollPosition: .none)
            dropDownOpenedView.titleLabel.text = viewModel.languageDataSource[0]
        } else {
            showLanguageListDropDown.selectRow(1, scrollPosition: .none)
            dropDownOpenedView.titleLabel.text = viewModel.languageDataSource[1]
        }
    }
}

//MARK: - CONFIRM SHOW DROPDOWN DELEGATE
extension ChangeLanguageViewController: ShowSelectedLanguageDropDownDelegate {
    func showDropDown() {
        showLanguageListDropDown.show()
    }
}

//MARK: - MAKE INSTANCE METHOD
extension ChangeLanguageViewController {
    static func makeInstance() -> ChangeLanguageViewController {
        .init(viewModel: ChangeLanguageViewModel())
    }
}

