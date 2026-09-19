//
//  RowView.swift
//  OMP_iOS
//
//  Created by AminSoft on 7/5/1400 AP.
//

import UIKit

class RowView: UIView {
    
    // MARK : - PROPERTIES
    lazy var keyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configure(text: "", fontSize: 14, textColor: .textColor, textAlignment: .right, fontType: .regular)
        return label
    }()
    
    lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configure(text: "", fontSize: 14, textColor: .textColor, textAlignment: .left, fontType: .regular)
        return label
    }()
    
    var setupLabels: ((_ key: UILabel, _ value: UILabel) -> Void)?
    
    private let keyTitle: String
    
    // MARK : - INITIALIZERS
    init(title: String) {
        self.keyTitle = title
        super.init(frame: .zero)
        createUI()
        setupLabels?(keyLabel, valueLabel)
        keyLabel.text = keyTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setValue(_ value: String) {
        valueLabel.text = value
    }
    
    // MARK : - CREATE UI
    private func createUI() {
        addingKeyLabel()
        addingValueLabel()
    }
    
    private func addingKeyLabel() {
        addSubview(keyLabel)
        NSLayoutConstraint.activate([
            keyLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            keyLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            keyLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4)
        ])
    }
    private func addingValueLabel() {
        addSubview(valueLabel)
        NSLayoutConstraint.activate([
            valueLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            valueLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.45)
        ])
    }
}

