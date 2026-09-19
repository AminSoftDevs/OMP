//
//  UIApplication.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 9/23/21.
//

import UIKit

extension UIApplication {
    static func changeRootViewController(_ vc: UIViewController, animated: Bool = true) {
        guard let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate, let window = scene.window else {
            return
        }
        window.rootViewController = vc
        
        UIView.transition(with: window,
                          duration: 0.5,
                          options: [.transitionCrossDissolve],
                          animations: nil,
                          completion: nil)
        
    }
}
