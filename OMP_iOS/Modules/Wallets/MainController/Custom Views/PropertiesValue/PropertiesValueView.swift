//
//  PropertiesValueView.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 9/28/21.
//

import UIKit
import Kingfisher

class PropertiesValueView: UIView {
        
    lazy var totalPropertyLabel: UILabel = {
       var label = UILabel()
        label.configure(text: "", fontSize: 14, textColor: .textColor, textAlignment: .right, fontType: .regular)
        return label
    }()
    
    lazy var totalPropertyImageView: UIImageView = {
       var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "iran_flag")
        return imageView
    }()
    
    lazy var totalPropertyValueLabel: UILabel = {
       var label = UILabel()
        label.configure(text: "", fontSize: 16, textColor: .submitButtonColor, textAlignment: .left, fontType: .regular)
        return label
    }()
    
    //MARK: - INITIALIZER    
    let viewModel: PropertiesValueViewModel
    
    init(viewModel: PropertiesValueViewModel ) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        self.backgroundColor = .backgroundColor
        self.layer.cornerRadius = 15
        self.createUI()
        
        self.viewModel.valuesReceived = { [weak self] in
            self?.totalPropertyValueLabel.text = viewModel.value
            self?.totalPropertyImageView.kf.setImage(with: viewModel.iconPath)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - CREATE UI
    fileprivate func createUI() {
        self.addingTotalPropertyLabel()
        self.addingTotalPropertyImageView()
        self.addingTotalPropertyValueLabel()
    }
    
    fileprivate func addingTotalPropertyLabel() {
        self.addSubview(totalPropertyLabel)
        self.totalPropertyLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            totalPropertyLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            totalPropertyLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
        ])
        self.totalPropertyLabel.text = viewModel.title
    }
    
    fileprivate func addingTotalPropertyImageView() {
        self.addSubview(totalPropertyImageView)
        self.totalPropertyImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            totalPropertyImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            totalPropertyImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
            totalPropertyImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.35),
            totalPropertyImageView.widthAnchor.constraint(equalTo: totalPropertyImageView.heightAnchor)
        ])
        self.totalPropertyImageView.layer.cornerRadius = totalPropertyImageView.bounds.width / 2
    }
    
    fileprivate func addingTotalPropertyValueLabel() {
        self.addSubview(totalPropertyValueLabel)
        self.totalPropertyValueLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            totalPropertyValueLabel.centerYAnchor.constraint(equalTo: totalPropertyImageView.centerYAnchor, constant: 4),
            totalPropertyValueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            totalPropertyValueLabel.trailingAnchor.constraint(equalTo: totalPropertyImageView.leadingAnchor, constant: -15)
        ])
        self.totalPropertyValueLabel.text = viewModel.value
    }
    
}

extension PropertiesValueView {
    static func makeInstance(title: String) -> PropertiesValueView {
        .init(viewModel: PropertiesValueViewModel(title: title))
    }
    
    func propertyInfo(value: String, icon: String) {
        viewModel.propertyInfo(value: value, icon: icon)
    }
}
