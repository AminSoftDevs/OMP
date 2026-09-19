//
//  EditPasswordCollectionViewCell.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 8/22/21.
//

import UIKit

class EditPasswordCollectionViewCell: UICollectionViewCell {

    private lazy var titleLabel: UILabel = {
       var label = UILabel()
        label.configure(text: "EditPasswordCollectionViewCell.title".localized, fontSize: 15, textColor: .textColor, textAlignment: .right, fontType: .regular)
        return label
    }()
    
    private lazy var editButton: UIButton = {
       var button = UIButton()
        button.setImage(UIImage(named: "edit_icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .submitButtonColor
        button.addTarget(self, action: #selector(editButtonPressed), for: .touchUpInside)
        button.imageEdgeInsets = .init(top: 3, left: 3, bottom: 3, right: 3)
        return button
    }()
    
    weak var delegate: ProfileControllerViewModelProtocol?
    
    //MARK: - DEFAULT INITIALIZER
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .cardsColor
        layer.cornerRadius = 15
        clipsToBounds = true
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - CREATE UI
    private func createUI() {
        addingTitleLabel()
        addingEditButton()
    }
    
    private func addingTitleLabel() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func addingEditButton() {
        addSubview(editButton)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            editButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            editButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            editButton.widthAnchor.constraint(equalToConstant: 25),
            editButton.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    //MARK: - OBJC FUNCTIONS
    @objc func editButtonPressed() {
        delegate?.editPasswordButtonPressed()
    }
}
