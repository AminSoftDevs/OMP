//
//  SettingViewController.swift
//  OMP_iOS
//
//  Created by AminSoft on 7/24/1400 AP.
//

import UIKit
import DropDown

class SettingViewController: BaseViewController {

    enum DropDownType: Int {
        case language = 0
        case theme = 1
        case marketType = 2
    }
    
    // MARK: - PROPERTIES
    private lazy var userInfoTableView: UITableView = {
       let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UserInfoTableViewCell.self, forCellReuseIdentifier: UserInfoTableViewCell.identifier)
        tableView.bounces = false
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var userInfoDropDown: DropDown = {
        let dropDown = DropDown()
        dropDown.backgroundColor = .cardsColor
        dropDown.textFont = UIFont(type: .regular, fontSize: 14)
        dropDown.textColor = .textColor
        dropDown.selectionBackgroundColor = .clear
        dropDown.selectedTextColor = .selectedDropDownItemColor
        dropDown.cornerRadius = 15
        dropDown.cellHeight = 50
        dropDown.width = Constants.screenWidth * 0.8
        dropDown.cellNib = UINib(nibName: "DropDownCustomTableViewCell", bundle: nil)
        dropDown.direction = .bottom
        dropDown.dimmedBackgroundColor = UIColor.black.withAlphaComponent(0.3)
        dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? DropDownCustomTableViewCell else { return }
            cell.optionLabel.textAlignment = .center
            cell.layer.cornerRadius = 16
            self.dropDownHandleSelectedItem?(cell, index)
        }
        dropDown.selectionAction = { (index: Int, item: String) in
            self.dropDownTapActionHandler?(index, item)
        }
        return dropDown
    }()
    
    private var selectedDropDownType: DropDownType?
    private var dropDownHandleSelectedItem: ((_ cell: DropDownCell, _ index: Int) -> ())?
    private var dropDownTapActionHandler: ((Int, String) -> ())?
    
    private let viewModel: SettingViewModel
    
    // MARK: - INITIALIZERS
    init(viewModel: SettingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - VIEW CONTROLLER LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBar(true)
        setBackgroundColor()
        createUI()
        
        dropDownTapActionHandler = { [weak self] (selectedIndex, selectedItem) in
            
            guard let self = self else { return }
            
            var indexToReload: IndexPath = IndexPath(row: 0, section: 0)
            
            switch self.selectedDropDownType {
            case .language:
                indexToReload = IndexPath(row: 0, section: 0)
                self.handleChangeLanguge(by: selectedIndex)
                
            case .theme:
                indexToReload = IndexPath(row: 1, section: 0)
                self.handleChangeTheme(by: selectedIndex)
                
            case .marketType:
                indexToReload = IndexPath(row: 2, section: 0)
                self.handleChangeMarketType(by: selectedIndex)
                
            default:
                break
            }
            
            guard let cell = self.userInfoTableView.cellForRow(at: indexToReload) as? UserInfoTableViewCell else { return }
            cell.changeModeLabel.text = selectedItem
            
            if let type = self.selectedDropDownType {
                self.viewModel.handleNewItemSelection(selectedIndex, type: type)
            }
        }
        
        dropDownHandleSelectedItem = { [weak self] (cell, index) in
            guard let self = self else { return }
            guard let cell = cell as? DropDownCustomTableViewCell else { return }
            
            if let type = self.selectedDropDownType {
                if self.viewModel.isSelectedItem(for: index, dropDownType: type) {
                    cell.selectionContainerView.isHidden = false
                }
            }
        }
    }
    
    // MARK: - CREATE UI
    private func createUI() {
        addingNavBar()
        addedUserInfoTableView()
    }
    
    private func addingNavBar() {
        addingDefaultNavigationBarView(title: "AccountViewController.setting".localized , hasBackButton: true, leftSideButtonName: nil, shouldHaveRadius: true)
        defaultNavigationBarView.delegate = self
    }
    
    private func addedUserInfoTableView() {
        view.addSubview(userInfoTableView)
        NSLayoutConstraint.activate([
            userInfoTableView.topAnchor.constraint(equalTo: defaultNavigationBarView.bottomAnchor, constant: 10),
            userInfoTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userInfoTableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95),
            userInfoTableView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
    }
    
    // MARK: - handle new language selection
    private func handleChangeLanguge(by index: Int) {
        viewModel.handleNewLanguageSelection(by: index)
    }
    
    private func handleChangeTheme(by index: Int) {
        viewModel.dropDownThemeItemDidSelect(at: index)
        DispatchQueue.main.async(execute: {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.initRootView()
        })
    }
    
    private func handleChangeMarketType(by index: Int) {
        viewModel.dropDownMarketItemDidSelect(at: index)
        DispatchQueue.main.async(execute: {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.initRootView()
        })
    }
}

// MARK: - UITABLEVIEW DELEGATE & DATASOURCE
extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataForCellType.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: UserInfoTableViewCell.identifier, for: indexPath) as? UserInfoTableViewCell {
            cell.typeCellLabel.text = viewModel.dataForCellType[indexPath.row]
            
            switch DropDownType(rawValue: indexPath.row) {
            case .language:
                cell.changeModeLabel.text = viewModel.selectedLanguage?.description

            case .theme:
                cell.changeModeLabel.text = viewModel.selectedTheme?.description
                
            case .marketType:
                cell.changeModeLabel.text = viewModel.selectedMarket?.description
                
            default:
                break
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch DropDownType(rawValue: indexPath.row) {
        case .language:
            userInfoDropDown.dataSource = viewModel.languageDataSource
            
        case .theme:
            userInfoDropDown.dataSource = viewModel.themeDataSource
            
        case .marketType:
            userInfoDropDown.dataSource = viewModel.marketDataSource
            
        default:
            break
        }
        
        selectedDropDownType = DropDownType(rawValue: indexPath.row)
        userInfoDropDown.show()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellHeight: CGFloat = tableView.bounds.height / 10
        return cellHeight
    }
}

// MARK: - DefaultNavigationBarViewProtocol
extension SettingViewController: DefaultNavigationBarViewProtocol {
    func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - Make Instanse
extension SettingViewController {
    static func makeInstance() -> SettingViewController {
        .init(viewModel: .init())
    }
}
