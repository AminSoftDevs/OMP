//
//  AnnouncementViewController.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 8/20/21.
//

import UIKit

class AnnouncementViewController: BaseViewController {

    private lazy var refreshControl = UIRefreshControl()
    
    private lazy var announcementTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = true
        tableView.allowsMultipleSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .cardsColor
        tableView.refreshControl = refreshControl
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 15
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tableView.backgroundColor = .cardsColor
        tableView.register(AnnouncementTableViewCell.self, forCellReuseIdentifier: AnnouncementTableViewCell.identifier)
        return tableView
    }()
    
    
    //MARK: - INITIALIZER
    private let viewModel: AnnouncementControllerViewModel
    
    init(viewModel: AnnouncementControllerViewModel) {
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
        createUI()
        viewModel.getAnnouncementList(newRefresh: true)
        Preloader.sharedInstance.startLoading()
        
        //delegate
        viewModel.delegate = self
        
        refreshControl.addTarget(self, action: #selector(refreshTableData(_:)), for: .valueChanged)
        refreshControl.tintColor = .textColor
    }
    
    //MARK: - CREATE UI
    private func createUI() {
        addingDefaultNavBar()
        addingAnnouncementTableView()
    }
    
    private func addingDefaultNavBar() {
        addingDefaultNavigationBarView(title: viewModel.navigationTitle, hasBackButton: true, shouldHaveRadius: true)
        defaultNavigationBarView.delegate = self
    }
    
    private func addingAnnouncementTableView() {
        view.addSubview(announcementTableView)
        announcementTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            announcementTableView.topAnchor.constraint(equalTo: defaultNavigationBarView.bottomAnchor, constant: 15),
            announcementTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            announcementTableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            announcementTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    //MARK: - OBJC FUNCTIONS
    @objc func refreshTableData(_ sender: UIRefreshControl) {
        viewModel.refreshForNewData()
    }
}

//MARK: - NAVIGATION BAR DELEGATE
extension AnnouncementViewController: DefaultNavigationBarViewProtocol {
    func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - MAKE INSTANCE
extension AnnouncementViewController {
    static func makeInstance() -> AnnouncementViewController {
        .init(viewModel: AnnouncementControllerViewModel())
    }
}

//MARK: - TABLE VIEW DELEGATE AND DATA SOURCE
extension AnnouncementViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.getItemForRowAt(indexPath: indexPath)
        viewModel.updateItemWithSelectedImage(with: item, at: indexPath)
        let vc = DetailAnnouncementViewController.makeInstance(announcement: item)
        show(vc, sender: self)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.getNumberOfRows - 1 {
            viewModel.loadMore()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.rowHeight
    }
}

extension AnnouncementViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AnnouncementTableViewCell.identifier, for: indexPath) as! AnnouncementTableViewCell
        cell.announcement = viewModel.getItemForRowAt(indexPath: indexPath)
        cell.selectionStyle = .none
        return cell
    }
}

//MARK: - VIEW MODEL DELEGATE
extension AnnouncementViewController: AnnouncementControllerViewModelProtocol {
    func updateItemAt(index: IndexPath) {
        announcementTableView.reloadRows(at: [index], with: .fade)
    }
    
    func newDataReceived() {
        if viewModel.getNumberOfRows == 0 {
            announcementTableView.setEmptyMessage()
        } else {
            announcementTableView.restore()
        }
        refreshControl.endRefreshing()
        announcementTableView.reloadData()
    }
}
