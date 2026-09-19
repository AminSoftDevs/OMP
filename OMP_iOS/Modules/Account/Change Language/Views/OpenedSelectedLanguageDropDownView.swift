//
//  OpenedSelectedLanguageDropDownView.swift
//  OMP_iOS
//
//  Created by AminSoft on 1/17/1401 AP.
//

import UIKit

protocol ShowSelectedLanguageDropDownDelegate: AnyObject {
    func showDropDown()
}

class OpenedSelectedLanguageDropDownView: UIView {
    
//MARK: - PROPERTIES
     lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
         label.configure(text: "", fontSize: 14, textColor: .textColor, textAlignment: .left, fontType: .regular)
        return label
    }()
    
     lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
         imageView.translatesAutoresizingMaskIntoConstraints = false
         imageView.contentMode = .scaleAspectFit
         imageView.image = UIImage(named: "arrow_down_icon")
         return imageView
    }()

     lazy var mainButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(showDropDownDidTapped), for: .touchUpInside)
        button.backgroundColor = .clear
        return button
    }()
    
    // Delegate
    weak var delegate: ShowSelectedLanguageDropDownDelegate?
    
    //MARK: - NITILIZERS
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - CRREATE UI
    private func createUI() {
        addingTitleLabel()
        addingArrowImageView()
        addingMainButton()
    }
    
    private func addingTitleLabel() {
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func addingArrowImageView() {
        addSubview(arrowImageView)
        NSLayoutConstraint.activate([
            arrowImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            arrowImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            arrowImageView.widthAnchor.constraint(equalToConstant: 12),
            arrowImageView.heightAnchor.constraint(equalToConstant: 12)
        ])
    }
    
    private func addingMainButton() {
        addSubview(mainButton)
        NSLayoutConstraint.activate([
            mainButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            mainButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainButton.widthAnchor.constraint(equalTo: widthAnchor),
            mainButton.heightAnchor.constraint(equalTo: heightAnchor)
        ])
    }
    
    //MARK: - OBJC FUNC
    @objc private func showDropDownDidTapped() {
        delegate?.showDropDown()
    }
}
