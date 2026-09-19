//
//  ActiveIpOrEntryExitTableViewCell.swift
//  OMP_iOS
//
//  Created by AminSoft on 9/5/1400 AP.
//

import UIKit

protocol DeleteActiveIpProtocol: AnyObject {
    func deleteActiveIpInCell(ip: Int)
}

class ActiveIpOrEntryExitTableViewCell: UITableViewCell {
    
    //MARK: - PROPERTIES
    enum SecurityTableViewType {
        case activeIP
        case entryAndExit
    }
    
    var cellType: SecurityTableViewType? {
        didSet {
            createUI()
        }
    }
    
    var securityItems: Security? {
        didSet {
            updateUI()
        }
    }
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .backgroundColor
        view.layer.cornerRadius = 12
        return view
    }()
    
    private lazy var ipLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configure(text: "", fontSize: 12, textColor: .textColor, textAlignment: .right, fontType: .regular)
        return label
    }()
    
    private lazy var platformLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configure(text: "", fontSize: 12, textColor: .textColor, textAlignment: .right, fontType: .regular)
        return label
    }()
    
    private lazy var entryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configure(text: "", fontSize: 12, textColor: .textColor, textAlignment: .right, fontType: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var operationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configure(fontSize: 0, title: "", fontType: .regular, titleColor: .clear, backgroundColor: .clear, borderColor: .clear, cornerRadius: 0)
        button.addTarget(self, action: #selector(operationButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(named: "delete_icon"), for: .normal)
        button.tintColor = .rejectOrangeColor
        
        return button
    }()
    
    private lazy var lastExitLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configure(text: "", fontSize: 12, textColor: .rejectOrangeColor, textAlignment: .right, fontType: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var stackElements: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
    }()
    
    // Delegate
    weak var delegate: DeleteActiveIpProtocol?
    //MARK: - INITLIZERS
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .cardsColor
        selectionStyle = .none
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - OBJC FUNC
    @objc private func operationButtonTapped() {
        guard let unwrappedSecurityItems = securityItems else { return }
        delegate?.deleteActiveIpInCell(ip: unwrappedSecurityItems.id)
    }
    
    //MARK: - CREATE UI
    private func createUI() {
        addingContainerView()
        addedIpLabel()
        addedStackElements()
    }
    
    private func addingContainerView() {
        contentView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            containerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            containerView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.96),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    private func addedIpLabel() {
        containerView.addSubview(ipLabel)
        NSLayoutConstraint.activate([
            ipLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            ipLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
        ])
    }
    
    private func addedStackElements() {
        switch cellType {
        case .activeIP:
            stackElements.addArrangedSubview(operationButton)
            
        case .entryAndExit:
            stackElements.addArrangedSubview(lastExitLabel)
            
        case .none:
            break
        }
        stackElements.addArrangedSubview(entryLabel)
        stackElements.addArrangedSubview(platformLabel)
        containerView.addSubview(stackElements)
        NSLayoutConstraint.activate([
            stackElements.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            stackElements.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 40),
            stackElements.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.6),
        ])
    }
    
     func updateUI() {
        guard let unwrappedSecurityItems = securityItems else { return }
        switch cellType {
        case .activeIP:
            ipLabel.text = unwrappedSecurityItems.ip
            platformLabel.text = unwrappedSecurityItems.platform
            entryLabel.text = unwrappedSecurityItems.entryDate
            
        case .entryAndExit:
            ipLabel.text = unwrappedSecurityItems.ip
            platformLabel.text = unwrappedSecurityItems.platform
            entryLabel.text = unwrappedSecurityItems.entryDate
            lastExitLabel.text = unwrappedSecurityItems.exitDate
            
        case .none:
            break
        }
    }
}
