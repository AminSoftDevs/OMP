//
//  Identifier+Extension.swift
//  OMP_iOS
//
//  Created by AminSoft on 7/6/1400 AP.
//

import UIKit

protocol ReuseIdentifible {
    var identifier: String { get }
    static var identifier : String { get }
}

extension ReuseIdentifible {
    var identifier: String {
        return String(describing: type(of: self))
    }
    
    static var identifier : String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReuseIdentifible {}
extension UICollectionViewCell: ReuseIdentifible {}
