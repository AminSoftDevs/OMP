//
//  SecurityTableViewCell.swift
//  OMP_iOS
//
//  Created by AminSoft on 9/3/1400 AP.
//

import UIKit

protocol ActiveOrDeactivateSecuritySwitchProtocol: AnyObject {
    func ActiveOrDeactivateSwitchHandler()
    func editSecurityCodeButton()
    func offSecurityCode()
}

class SecurityTableViewCell: UITableViewCell {
    
    //MARK: - PROPERTIES
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .cardsColor
        view.layer.cornerRadius = 12
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configure(text: "", fontSize: 14, textColor: .textColor, textAlignment: .right, fontType: .regular)
        return label
    }()
    
    lazy var activeSecuritySwitch: UISwitch = {
        let activeSwitch = UISwitch()
        activeSwitch.translatesAutoresizingMaskIntoConstraints = false
        activeSwitch.addTarget(self, action: #selector(activeSwitchTapped), for: .touchUpInside)
        activeSwitch.onTintColor = .switchColor
        activeSwitch.isOn = false
        return activeSwitch
    }()
    
    lazy var editLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configure(text: "SecurityViewController.edit".localized, fontSize: 14, textColor: .textColor, textAlignment: .right, fontType: .regular)
        return label
    }()
    
    lazy var editButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configure(fontSize: 0, title: "", fontType: .regular, titleColor: .clear, backgroundColor: .clear, borderColor: .clear)
        button.setImage(UIImage(named: "edit_icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .submitButtonColor
        button.imageView?.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var editStackLabel: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .equalCentering
        stack.alignment = .fill
        stack.spacing = 20
        return stack
    }()
    
    private lazy var editStackButton: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .equalCentering
        stack.alignment = .fill
        stack.spacing = 20
        return stack
    }()
    
    private lazy var LocalAuthenticationSwitch: UISwitch = {
    let authenticationSwitch = UISwitch()
        authenticationSwitch.translatesAutoresizingMaskIntoConstraints = false
        authenticationSwitch.addTarget(self, action: #selector(authenticationSwitchTapped), for: .touchUpInside)
        authenticationSwitch.onTintColor = .switchColor
        authenticationSwitch.isOn = false
        return authenticationSwitch
    }()
    
    var showEditMode: Bool = false
    
    // Delegate
    weak var delegate: ActiveOrDeactivateSecuritySwitchProtocol?
    
    //MARK: - INITLIZERS
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .backgroundColor
        selectionStyle = .none
        createUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Set The Switch To on/off
        setStateForSecuritySwitch()
        setStateForAuthenticationUserSwitch()
    }
    
    //MARK: - CREATE UI
    private func createUI() {
        addingContainerView()
        addedEditStackLabel()
    }
    
    private func addedEditStackLabel() {
        editStackLabel.addArrangedSubview(titleLabel)
        containerView.addSubview(editStackLabel)
        NSLayoutConstraint.activate([
            editStackLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            editStackLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
    
     func addedEditStackButton() {
        editStackButton.addArrangedSubview(activeSecuritySwitch)
         containerView.addSubview(editStackButton)
        NSLayoutConstraint.activate([
            editStackButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            editStackButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
    
    func addingElementForEditMode() {
        if KeychainData.securityCode != "" {
            editStackButton.addArrangedSubview(editButton)
            editStackLabel.addArrangedSubview(editLabel)
        }
    }
    
    private func addingContainerView() {
        contentView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            containerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            containerView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.95),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }

    func addingLocalAuthenticationSwitch() {
        containerView.addSubview(LocalAuthenticationSwitch)
       NSLayoutConstraint.activate([
        LocalAuthenticationSwitch.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
        LocalAuthenticationSwitch.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
       ])
    }
    
    // Set The Switch To on/off
    private func setStateForSecuritySwitch() {
        KeychainData.securityCode != "" ? activeSecuritySwitch.setOn(true, animated: true) : activeSecuritySwitch.setOn(false, animated: true)
    }
    private func setStateForAuthenticationUserSwitch() {
        UserDefaults.standard.isBiometric ? LocalAuthenticationSwitch.setOn(true, animated: true) : LocalAuthenticationSwitch.setOn(false, animated: true)
    }
    
    //MARK: - OBJC FUNC
    @objc func activeSwitchTapped() {
        activeSecuritySwitch.isOn ? delegate?.ActiveOrDeactivateSwitchHandler() : delegate?.offSecurityCode()
    }
    
    @objc func authenticationSwitchTapped() {
        if LocalAuthenticationSwitch.isOn {
            UserDefaults.standard.isBiometric = true
        } else {
            UserDefaults.standard.isBiometric = false
        }
    }
    
    @objc private func editButtonTapped() {
        delegate?.editSecurityCodeButton()
    }
}
