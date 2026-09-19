//
//  WalletBalanceLabelView.swift
//  OMP_iOS
//
//  Created by AminSoft on 7/5/1400 AP.
//

import UIKit

enum LabelMode {
    case equal
    case approximateValue
    case available
    case inOrder
}

class WalletBalanceLabelView: UIView {
    
    // MARK : - PROPERTIES
    private lazy var keyLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
         return label
    }()
    
    private lazy var valueLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    private lazy var mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 10
        return stack
    }()
    
    // MARK : - INITILIZERS
    private let labelMode: LabelMode
    init(mode: LabelMode) {
        self.labelMode = mode
        super.init(frame: .zero)
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK : - CREATE UI
    private func createUI() {
        addingMainStackView()
    }
    
    private func addingMainStackView() {
        mainStackView.addArrangedSubview(valueLabel)
        mainStackView.addArrangedSubview(keyLabel)
        addSubview(mainStackView)
        NSLayoutConstraint.activate([
            mainStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            mainStackView.widthAnchor.constraint(equalTo: widthAnchor),
            mainStackView.heightAnchor.constraint(equalTo: heightAnchor)
        ])
        switch labelMode {
        case .available:
            keyLabel.configure(text: "OrdersSectionView.available".localized, fontSize: 14, textColor: .white, textAlignment: .right, fontType: .regular)
            valueLabel.configure(text: "", fontSize: 14, textColor: .white, textAlignment: .left, fontType: .regular)
        case .equal:
            keyLabel.configure(text: "معادل", fontSize: 14, textColor: .white, textAlignment: .right, fontType: .regular)
            valueLabel.configure(text: "", fontSize: 14, textColor: .white, textAlignment: .left, fontType: .regular)
        case .approximateValue:
            keyLabel.configure(text: "ارزش تقریبی", fontSize: 14, textColor: .white, textAlignment: .right, fontType: .regular)
            valueLabel.configure(text: "", fontSize: 14, textColor: .white, textAlignment: .left, fontType: .regular)
        case .inOrder:
            keyLabel.configure(text: "در سفارش", fontSize: 14, textColor: .white, textAlignment: .right, fontType: .regular)
            valueLabel.configure(text: "", fontSize: 14, textColor: .white, textAlignment: .left, fontType: .regular)
        }
    }
}
