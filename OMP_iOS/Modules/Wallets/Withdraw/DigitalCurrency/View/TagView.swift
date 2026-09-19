//
//  TagView.swift
//  OMP_iOS
//
//  Created by AminSoft on 7/18/1400 AP.
//

import UIKit

protocol SendingTagText: AnyObject {
    func sendingTagValue(value: String)
}

class TagView: UIView {
    
    // MARK: - PROPERTIES
   private var switchBottomConstraint: NSLayoutConstraint!
    
    private lazy var tagLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configure(text: "Withdraw.tagOrMemo".localized, fontSize: 14, textColor: .textColor, textAlignment: .right, fontType: .regular)
        return label
    }()
    
    private lazy var tagSwitch: UISwitch = {
        let tagSwitch = UISwitch()
        tagSwitch.translatesAutoresizingMaskIntoConstraints = false
        tagSwitch.onTintColor = .switchColor
        tagSwitch.isOn = true
        tagSwitch.setOn(true, animated: false)
        tagSwitch.addTarget(self, action: #selector(tagSwitchTapped), for: .valueChanged)
        return tagSwitch
    }()
    
    private lazy var activeTagLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configure(text: "Withdraw.activeTag".localized, fontSize: 14, textColor: .textColor, textAlignment: .right, fontType: .regular)
        return label
    }()
    
    lazy var tagTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.configure(placeholder: "", borderColor: .clear, fontSize: 14, fontType: .regular, keyboardType: .default, textAlignment: .right, radius: 14, backgroundColor: .backgroundColor, textColor: .textColor)
        textField.delegate = self
        return textField
    }()
    
    lazy var tagDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configure(text: "Withdraw.descriptionTag".localized, fontSize: 13, textColor: .textFieldPlaceholderColor, textAlignment: .right, fontType: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    weak var delegate: SendingTagText?
    
    // MARK: - INITILIZER
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    // MARK: - CREATE UI
    private func createUI() {
        addingTagLabel()
        addingTagSwitch()
        addedActiveTagLabel()
        addingTagTextField()
        addingTagDescriptionLabel()
    }
    
    private func addingTagLabel() {
        addSubview(tagLabel)
        NSLayoutConstraint.activate([
            tagLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            tagLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0)
        ])
    }
    private func addingTagSwitch() {
        addSubview(tagSwitch)
        NSLayoutConstraint.activate([
            tagSwitch.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            tagSwitch.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            tagSwitch.centerYAnchor.constraint(equalTo: tagLabel.centerYAnchor),
        ])
    }
    private func addedActiveTagLabel() {
        addSubview(activeTagLabel)
        NSLayoutConstraint.activate([
            activeTagLabel.leadingAnchor.constraint(equalTo: tagSwitch.trailingAnchor, constant: 10),
            activeTagLabel.centerYAnchor.constraint(equalTo: tagSwitch.centerYAnchor)
        ])
    }
    private func addingTagTextField() {
        addSubview(tagTextField)
        NSLayoutConstraint.activate([
            tagTextField.topAnchor.constraint(equalTo: tagLabel.bottomAnchor, constant: 5),
            tagTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            tagTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            tagTextField.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    private func addingTagDescriptionLabel() {
        addSubview(tagDescriptionLabel)
        NSLayoutConstraint.activate([
            tagDescriptionLabel.topAnchor.constraint(equalTo: tagTextField.bottomAnchor, constant: 10),
            tagDescriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            tagDescriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            tagDescriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
    }
    //    MARK: - OBJC FUNC
    @objc private func tagSwitchTapped() {
        if tagSwitch.isOn {
            activeTagLabel.text = "Withdraw.activeTag".localized
            switchBottomConstraint.isActive = false
            addingTagTextField()
            addingTagDescriptionLabel()
        } else {
            activeTagLabel.text = "Withdraw.notActiveTag".localized
            tagTextField.removeFromSuperview()
            tagDescriptionLabel.removeFromSuperview()
            switchBottomConstraint = tagSwitch.bottomAnchor.constraint(equalTo: bottomAnchor)
            switchBottomConstraint.isActive = true
        }
    }
}
// MARK: - TEXTFIELD DELEGATE
extension TagView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        tagTextField.layer.borderColor = UIColor.submitButtonColor.cgColor
        tagTextField.layer.borderWidth = 2.5
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        tagTextField.layer.borderColor = UIColor.clear.cgColor
        tagTextField.layer.borderWidth = 0
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let unwrappedText = textField.text else { return }
        delegate?.sendingTagValue(value: unwrappedText)
    }
}
