//
//  GuideViewController.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 11/8/21.
//

import UIKit

class GuideViewController: BaseViewController {
    
    private lazy var mainTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.bounces = false
        tableView.layer.cornerRadius = 15
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tableView.register(GuideTableViewCell.self, forCellReuseIdentifier: GuideTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    //MARK: - INITIALIZER
    private let viewModel: GuideViewControllerViewModel
    
    init(viewModel: GuideViewControllerViewModel) {
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
    }
    
    private func createUI() {
        addingDefaultNavBar()
        addingTableView()
    }
    
    private func addingDefaultNavBar() {
        addingDefaultNavigationBarView(title: viewModel.controllerTitle , hasBackButton: true, leftSideButtonName: nil, shouldHaveRadius: true)
        defaultNavigationBarView.delegate = self
    }
    
    private func addingTableView() {
        view.addSubview(mainTableView)
        mainTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainTableView.topAnchor.constraint(equalTo: defaultNavigationBarView.bottomAnchor, constant: 15),
            mainTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

//MARK: - Table VIEW DELEGATE
extension GuideViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = URL(string: viewModel.getSelectedItemPath(index: indexPath.row)), !url.absoluteString.isEmpty else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

//MARK: - Table VIEW DATA SOURCE
extension GuideViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GuideTableViewCell.identifier, for: indexPath) as! GuideTableViewCell
        cell.guidOption = viewModel.getItemForRow(index: indexPath.row)
        return cell
    }
}

// MARK: - DefaultNavigationBarViewProtocol
extension GuideViewController: DefaultNavigationBarViewProtocol {
    func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - MAKE INSTANCE METHOD
extension GuideViewController {
    static func makeInstance() -> GuideViewController {
        .init(viewModel: GuideViewControllerViewModel())
    }
}
