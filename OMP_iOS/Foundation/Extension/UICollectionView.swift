//
//  UICollectionView.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 8/28/21.
//

import UIKit

extension UICollectionView {
    
    func setEmptyMessage() {
        let emptyListView = EmptyListView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        self.backgroundView = emptyListView;
    }
    
    func restore() {
        self.backgroundView = nil
    }
}

extension UICollectionViewFlowLayout {

    open override var flipsHorizontallyInOppositeLayoutDirection: Bool {
        return true
    }
}

