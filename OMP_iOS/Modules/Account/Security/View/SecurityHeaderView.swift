//
//  SecurityHeaderView.swift
//  OMP_iOS
//
//  Created by AminSoft on 9/4/1400 AP.
//

import UIKit

enum SecurityHeaderType {
    case activeID
    case entryAndExit
}

class SecurityHeaderView: UIView {
    
    //MARK: - PROPERTIES
    private lazy var ipLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configure(text: "", fontSize: 13, textColor: .textColor, textAlignment: .right, fontType: .regular)
        return label
    }()
    
    private lazy var platformLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configure(text: "", fontSize: 13, textColor: .textColor, textAlignment: .right, fontType: .regular)
        return label
    }()
    
    private lazy var entryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configure(text: "", fontSize: 13, textColor: .textColor, textAlignment: .right, fontType: .regular)
        return label
    }()
    
    private lazy var exitLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configure(text: "", fontSize: 13, textColor: .white, textAlignment: .right, fontType: .regular)
        return label
    }()
    
    private lazy var stackLabel: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.axis = .horizontal
        return stackView
    }()
    
    lazy var lineImageView: UIImageView = {
       var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "line")
        return imageView
    }()
    
    private let headerType: SecurityHeaderType
    //MARK: - INITLIZERS
    init(type: SecurityHeaderType) {
        headerType = type
        super.init(frame: .zero)
        defaultStyle()
        createUI()
        updateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func defaultStyle() {
        backgroundColor = .cardsColor
        layer.cornerRadius = 20
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    //MARK: - CREATE UI
    private func createUI() {
        addedIpLabel()
        addedStackLabel()
        addingTitleImageView()
    }
    
    private func addedStackLabel(){
        stackLabel.addArrangedSubview(exitLabel)
        stackLabel.addArrangedSubview(entryLabel)
        stackLabel.addArrangedSubview(platformLabel)
        addSubview(stackLabel)
        NSLayoutConstraint.activate([
            stackLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6),
            stackLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 35),
            stackLabel.heightAnchor.constraint(equalTo: heightAnchor)
        ])
    }
    
    private func addedIpLabel() {
        addSubview(ipLabel)
        NSLayoutConstraint.activate([
            ipLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            ipLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -45),
        ])
    }
    
    private func addingTitleImageView() {
        addSubview(lineImageView)
        NSLayoutConstraint.activate([
            lineImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2),
            lineImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            lineImageView.widthAnchor.constraint(equalTo: widthAnchor,  multiplier: 0.8),
            lineImageView.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
    
    private func updateUI() {
        ipLabel.text = "SecurityViewController.IP".localized
        platformLabel.text = "SecurityViewController.platform".localized
        entryLabel.text = "SecurityViewController.entry".localized
        if headerType == .activeID {
            exitLabel.text = "SecurityViewController.operation".localized
        } else {
            exitLabel.text = "SecurityViewController.exit".localized
        }
    }
}
