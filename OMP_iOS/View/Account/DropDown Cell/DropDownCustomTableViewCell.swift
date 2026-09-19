//
//  DropDownCustomCellTableViewCell.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 8/11/21.
//

import UIKit
import DropDown

class DropDownCustomTableViewCell: DropDownCell {

    
    lazy var selectionContainerView: UIView = {
       var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .selectedDropDownItemColor
        view.layer.cornerRadius = 8
        view.isHidden = true
        return view
    }()
    
    lazy var separatorView: UIView = {
       var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .mediumGrayColor.withAlphaComponent(0.5)
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupViews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        selectionContainerView.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func customSeparator() {
        self.addSubview(separatorView)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorView.widthAnchor.constraint(equalTo: widthAnchor, constant: -50),
            separatorView.heightAnchor.constraint(equalToConstant: 0.3),
        ])
    }
    
    func setupViews() {
        addSubview(selectionContainerView)
        NSLayoutConstraint.activate([
            selectionContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            selectionContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            selectionContainerView.centerYAnchor.constraint(equalTo: optionLabel.centerYAnchor),
            selectionContainerView.heightAnchor.constraint(equalTo: optionLabel.heightAnchor, constant: 16)
        ])
        sendSubviewToBack(selectionContainerView)
    }
    
}
