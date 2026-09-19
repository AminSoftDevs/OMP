//
//  ImagePickerOptionView.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 8/13/21.
//

import UIKit

protocol ImagePickerOptionDelegate: AnyObject {
    func openImagePickingSource(type: ImagePickerOptionType)
}

enum ImagePickerOptionType {
    case camera
    case photos
}

class ImagePickerOptionView: UIView {
    
    lazy var cameraButton: CenteredButton = {
       var button = CenteredButton()
        button.setImage(UIImage(named: "camera_icon"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.configure(fontSize: 14, title: "دوربین", fontType: .bold, titleColor: .textColor, backgroundColor: .clear, borderColor: .clear)
        button.addTarget(self, action: #selector(cameraButtonPressed), for: .touchUpInside)
        button.titleBottomPadding = -10
        return button
    }()
    
    lazy var photosButton: CenteredButton = {
       var button = CenteredButton()
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(UIImage(named: "photos_icon"), for: .normal)
        button.configure(fontSize: 14, title: "تصاویر", fontType: .bold, titleColor: .textColor, backgroundColor: .clear, borderColor: .clear)
        button.addTarget(self, action: #selector(photosButtonPressed), for: .touchUpInside)
        button.titleBottomPadding = -10
        return button
    }()
    
    //MARK: - DEFAULT INITIALIZER
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .cardsColor
        self.layer.cornerRadius = 10
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var delegate: ImagePickerOptionDelegate?
    
    //MARK: - CREATE UI
    fileprivate func createUI() {
        self.addingCameraButton()
        self.addingPhotosButton()
    }
    
    fileprivate func addingCameraButton() {
        self.addSubview(cameraButton)
        self.cameraButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: cameraButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: cameraButton, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 40).isActive = true
        NSLayoutConstraint(item: cameraButton, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 90).isActive = true
        NSLayoutConstraint(item: cameraButton, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0, constant: 90).isActive = true
    }
    
    fileprivate func addingPhotosButton() {
        self.addSubview(photosButton)
        self.photosButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: photosButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: photosButton, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -40).isActive = true
        NSLayoutConstraint(item: photosButton, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 90).isActive = true
        NSLayoutConstraint(item: photosButton, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0, constant: 90).isActive = true
    }
    
    //MARK: - OBJC FUNCTIONS
    @objc func cameraButtonPressed() {
        delegate?.openImagePickingSource(type: .camera)
    }
    
    @objc func photosButtonPressed() {
        delegate?.openImagePickingSource(type: .photos)
    }
}
