//
//  DetailAnnouncementViewController.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 8/21/21.
//

import UIKit

class DetailAnnouncementViewController: BaseViewController {
    
    private lazy var mainScrollView: UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .cardsColor
        scrollView.layer.cornerRadius = 15
        scrollView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return scrollView
    }()
    
    private lazy var containerView: UIView = {
       var view = UIView()
        view.backgroundColor = .backgroundColor
        view.layer.cornerRadius = 15
        return view
    }()
    
    private lazy var iconImageView: UIImageView = {
       var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "opened_message_icon")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .submitGreenColor
        return imageView
    }()
    
    private lazy var mainStackView: UIStackView = {
       var stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
       var label = UILabel()
        label.configure(text: viewModel.title, fontSize: 16, textColor: .textColor, textAlignment: .center, fontType: .regular)
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
       var label = UILabel()
        label.configure(text: viewModel.createTime, fontSize: 16, textColor: .mediumGrayColor, textAlignment: .center, fontType: .regular)
        return label
    }()
    
    private lazy var messageTextView: UITextView = {
        var textView = UITextView()
        textView.backgroundColor = .clear
        textView.textColor = .textColor
        textView.textAlignment = .right
        textView.font = UIFont(type: .regular, fontSize: 14)
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.text = viewModel.message
        return textView
    }()
    
    //MARK: - INITIALIZER
    private let viewModel: DetailAnnouncementControllerViewModel
    
    init(viewModel: DetailAnnouncementControllerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.readAnnouncement()
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
    }
    
    //MARK: - CREATE UI
    private func createUI() {
        addingDefaultNavBar()
        addingMainScrollView()
        addingContainerView()
        addingIconImageView()
        addingTitleAndDateStackView()
        addingMessageTextView()
    }
    
    private func addingDefaultNavBar() {
        addingDefaultNavigationBarView(title: viewModel.navigationTitle, hasBackButton: true, shouldHaveRadius: true)
        defaultNavigationBarView.delegate = self
    }
    
    private func addingMainScrollView() {
        view.addSubview(mainScrollView)
        mainScrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainScrollView.topAnchor.constraint(equalTo: defaultNavigationBarView.bottomAnchor, constant: 15),
            mainScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func addingContainerView() {
        mainScrollView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        let sizeThatFitsTextView = messageTextView.sizeThatFits(CGSize(width: Constants.screenWidth - 20, height: CGFloat(MAXFLOAT)))
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: mainScrollView.topAnchor, constant: 30),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            containerView.heightAnchor.constraint(equalToConstant: 230 + sizeThatFitsTextView.height)
        ])
        mainScrollView.contentSize.height = 300 + sizeThatFitsTextView.height
    }
    
    private func addingIconImageView() {
        containerView.addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            iconImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: 80),
            iconImageView.widthAnchor.constraint(equalToConstant: 80),
        ])
    }
    
    private func addingTitleAndDateStackView() {
        containerView.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 20),
            mainStackView.centerXAnchor.constraint(equalTo: iconImageView.centerXAnchor),
            mainStackView.heightAnchor.constraint(equalToConstant: 70),
            mainStackView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20),
        ])
        
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(dateLabel)
    }
    
    private func addingMessageTextView() {
        containerView.addSubview(messageTextView)
        messageTextView.translatesAutoresizingMaskIntoConstraints = false
        
        let sizeThatFitsTextView = messageTextView.sizeThatFits(CGSize(width: Constants.screenWidth - 20, height: CGFloat(MAXFLOAT)))
        NSLayoutConstraint.activate([
            messageTextView.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 20),
            messageTextView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            messageTextView.heightAnchor.constraint(equalToConstant: sizeThatFitsTextView.height),
            messageTextView.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: -10),
        ])
    }
}

//MARK: - MAKE INSTANCE
extension DetailAnnouncementViewController {
    static func makeInstance(announcement: Announcement) -> DetailAnnouncementViewController {
        .init(viewModel: DetailAnnouncementControllerViewModel(announcement: announcement))
    }
}

//MARK: - NAVIGATION BAR DELEGATE
extension DetailAnnouncementViewController: DefaultNavigationBarViewProtocol {
    func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
}
