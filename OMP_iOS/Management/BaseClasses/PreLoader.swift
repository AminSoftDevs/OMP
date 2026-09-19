//
//  PreLoader.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 7/28/21.
//

import UIKit
import NVActivityIndicatorView

class Preloader: UIViewController, NVActivityIndicatorViewable{
    static let sharedInstance = Preloader()

    public func startLoading() {
        let size = CGSize(width: 25, height: 25)
        startAnimating(size, type: .lineScalePulseOut, color: .submitButtonColor)
        DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
            self.stopAnimating()
        }
    }
    
    public func stopLoading() {
        if self.isAnimating {
            stopAnimating()
        }
    }
    
}
