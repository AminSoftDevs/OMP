//
//  UITableView.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 8/28/21.
//

import UIKit

extension UITableView {
    func setEmptyImage() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "flat-design")
        self.backgroundView = imageView
    }
    
    func setEmptyMessage() {
        let emptyListView = EmptyListView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        self.backgroundView = emptyListView
    }
    
    func restore() {
        self.backgroundView = nil
    }
}
