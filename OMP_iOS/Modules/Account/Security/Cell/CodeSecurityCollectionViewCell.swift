//
//  CodeSecurityCollectionViewCell.swift
//  OMP_iOS
//
//  Created by AminSoft on 9/8/1400 AP.
//

import UIKit

protocol SendingValueFromSecurityButtonProtocol: AnyObject {
    func sendingButtonValue(value: String)
}

class CodeSecurityCollectionViewCell: UICollectionViewCell {
    
    lazy var numberButton: UIButton = {
       let button  = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configure(fontSize: 16, title: "", fontType: .regular, titleColor: .textColor, backgroundColor: .cardsColor, borderColor: .clear, cornerRadius: 15)
        button.addTarget(self, action: #selector(numberButtonTapped), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = UIColor.textColor
        return button
    }()
    
    // DELEGATE
    weak var delegate: SendingValueFromSecurityButtonProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - OBJC FUNC
    @objc private func numberButtonTapped() {
        delegate?.sendingButtonValue(value: numberButton.titleLabel?.text ?? "")
    }
    
    // MARK: - CREATE UI
    private func createUI() {
        contentView.addSubview(numberButton)
        NSLayoutConstraint.activate([
            numberButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            numberButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            numberButton.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            numberButton.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            
        ])
    }
}
