//
//  Int.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 8/27/21.
//

import Foundation

extension Int {
    func format(f: String) -> String {
        return String(format: "%\(f)d", self)
    }
}

extension FloatingPoint {
  var isInteger: Bool { rounded() == self }
}
