//
//  Double.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 8/27/21.
//

import Foundation

extension Double {
    func format(f: String) -> String {
        return String(format: "%.\(f)f", self)
    }
    
    func format(f: Int) -> String {
        //return self < 1 ? self.toString : String(format: "%.\(f)f", self)
        return String(format: "%.\(f)f", self)
    }
    
    var removeZerosFromEnd: String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 16
        return String(formatter.string(from: number) ?? "")
    }
    
    var changeToRial: Double {
        let decimal = Decimal(string: String(self))
        let digitAfterDecimalPoint = decimal?.significantFractionalDecimalDigits
        if digitAfterDecimalPoint != nil {
            let digitDouble = Double(digitAfterDecimalPoint!)
            let powerOfTen: Double = pow(10.0, digitDouble)
            let withoutDecimal = self * powerOfTen
            var convertToInt: Int = Int(withoutDecimal)
            convertToInt = convertToInt / 10
            return Double(convertToInt) / (powerOfTen)
        }
        return 0
    }
    
    var changeToToman: Double {
        return self / 10
    }
    
    var toString: String {
        return "\(self)"
    }
}

extension Decimal {
    var significantFractionalDecimalDigits: Int {
        return max(-exponent, 0)
    }
}
