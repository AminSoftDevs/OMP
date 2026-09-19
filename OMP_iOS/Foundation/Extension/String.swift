//
//  String.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 7/28/21.
//

import Foundation
import UIKit
//import CryptoSwift

extension String {
    
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            // it is a link, if the match covers the whole string
            return (match.range.length == self.utf16.count) && (self.contains(".jpg") || self.contains(".jpeg") || self.contains(".png"))
        } else {
            return false
        }
    }
    
    public func removeSpaceFromPath() -> String {
        return self.replacingOccurrences(of: " ", with: "%20")
    }
    
    public func insertSpaceToPath() -> String {
        return self.replacingOccurrences(of: "%20", with: " ")
    }
    
    public var convertPersianNumToEngNum: String {
        var str = self
        let map = ["٠": "0",
                   "١": "1",
                   "٢": "2",
                   "٣": "3",
                   "٤": "4",
                   "٥": "5",
                   "٦": "6",
                   "٧": "7",
                   "٨": "8",
                   "٩": "9",
                   "ك" : "ک",
                   "ي" : "ی",
                   "ة" : "ه"
        ]
        map.forEach { str = str.replacingOccurrences(of: $0, with: $1) }
        return str
    }
    
    func persianToEng() -> String {
        let numbersDictionary : Dictionary = ["۰" : "0", "۱" : "1", "۲" : "2", "۳" : "3", "۴" : "4", "۵" : "5", "۶" : "6", "۷" : "7", "۸" : "8", "۹" : "9"]
        var str : String = self
        
        for (key,value) in numbersDictionary {
            str =  str.replacingOccurrences(of: key, with: value)
        }
        
        return str
    }
    
    
    func convertEngNumToPersianNum() -> String {
        if Localization.sharedInstance.getLanguage() == "en" {
            let numbersDictionary : Dictionary = ["0" : "0","1" : "1", "2" : "2", "3" : "3", "4" : "4", "5" : "5", "6" : "6", "7" : "7", "8" : "8", "9" : "9"]
            var str : String = self
            
            for (key,value) in numbersDictionary {
                str =  str.replacingOccurrences(of: key, with: value)
            }
            
            return str
        } else {
        let numbersDictionary : Dictionary = ["0" : "۰","1" : "۱", "2" : "۲", "3" : "۳", "4" : "۴", "5" : "۵", "6" : "۶", "7" : "۷", "8" : "۸", "9" : "۹"]
        var str : String = self
        
        for (key,value) in numbersDictionary {
            str =  str.replacingOccurrences(of: key, with: value)
        }
        
        return str
        }
    }
    
    func convertToDecimal() -> NSNumber {
        let Formatter: NumberFormatter = NumberFormatter()
        Formatter.locale = Locale(identifier: "EN")
        if let final = Formatter.number(from: self) {
            return final
        } else {
            return 0
        }
    }
    
    func addCurrency() -> String {
        let st = self
        return st + "toman".localized
    }
    
    func addPercent() -> String {
        let st = self
        return "٪" + st
    }
    
    func keepNumbers() -> String {
        let okayChars : Set<Character> =
            Set("۱۲۳۴۵۶۷۸۹۰1234567890")
        return String(self.filter {okayChars.contains($0)})
    }
    
    func removeSpecialCharsFromDate() -> String {
        let okayChars : Set<Character> =
            Set("AVATARavatar1234567890_")
        return String(self.filter {okayChars.contains($0)})
    }
    
    func strToBool() -> Bool {
        if self == "0" || self == "False" || self == "false" {
            return false
        }
        return true
    }
    
    func boldSomeText(boldText: String, fontSize: CGFloat) -> NSAttributedString {
        let string = self as NSString
        let attributedString = NSMutableAttributedString(string: string as String, attributes: [NSAttributedString.Key.font: UIFont.init(type: .regular, fontSize: fontSize)])
        let boldFontAttribute = [NSAttributedString.Key.font: UIFont.init(type: .bold, fontSize: fontSize + 2.0)]
        attributedString.addAttributes(boldFontAttribute, range: string.range(of: boldText))
        return attributedString
    }
    
    func CGFloatValue() -> CGFloat? {
        guard let doubleValue = Double(self) else {
            return nil
        }
        return CGFloat(doubleValue)
    }
    
    func indexInt(of char: Character) -> Int? {
        return firstIndex(of: char)?.utf16Offset(in: self)
    }
    
    func strikeThrough() -> NSAttributedString {
        let attributeString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0,attributeString.length))
        return attributeString
    }
    
}

extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

extension String {
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
    
    var isReallyEmpty: Bool {
        return self.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var isValidEmail: Bool {
        NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: self)
    }
}

extension String {
    func split(by length: Int) -> [String] {
        var startIndex = self.startIndex
        var results = [Substring]()
        
        while startIndex < self.endIndex {
            let endIndex = self.index(startIndex, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            results.append(self[startIndex..<endIndex])
            startIndex = endIndex
        }
        return results.map { String($0) }
    }
}


extension String {
    // MARK: localized
    /// Return localized string
    var localized: String {
        return Localization.sharedInstance.localizedString(forKey: self, value: "")
//        return NSLocalizedString(self, comment: "")
    }
    
    var removeZeroFromEnd: String {
        var number = self
        if !number.contains(".") {
            return self
        }
        while number.last == "0" {
            number.removeLast()
        }
        if number.last == "." {
            number.removeLast()
        }
        return "\(number)"
    }
    
    var removeComma: String {
        return self.replacingOccurrences(of: ",", with: "")
    }
    
    var toDouble: Double {
        return Double(self) ?? 0.0
    }
    
    var toInt: Int {
        Int(self) ?? 0
    }
    
    var formattedBalance: String {
        let doubleValue = self.toDouble
        return doubleValue >= 1 ? doubleValue.formattedWithSeparator.convertEngNumToPersianNum() : String(doubleValue).convertEngNumToPersianNum()
    }
    
    var addDollar: String {
        let st = self
        return st + "dollar".localized
    }
    
    var stringToURL: URL? {
        guard let url = URL(string: self) else { return nil }
        return url
    }
    
    var QRCodeURL: URL? {
        let newString = "https://chart.apis.google.com/chart?cht=qr&chs=150x150&chld=L|0&chl=\(self)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let url = URL(string: newString ?? "") else { return nil }
        return url
    }
}

extension String {
    
    func stringToDate(withFormat format: String = "yyyy-MM-dd", identifier: Calendar.Identifier = .persian) -> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tehran")
        dateFormatter.locale = Locale(identifier: "fa-IR")
        dateFormatter.calendar = Calendar(identifier: identifier)
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        
        return date
    }
}
extension Date {
    func dateToString(withFormat format: String = "yyyy-MM-dd", identifier: Calendar.Identifier = .gregorian) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: identifier)
        dateFormatter.dateFormat = format
        let str = dateFormatter.string(from: self)
        return str
    }
}

extension String {
    var UTCLocal: String {
        var identifier: Calendar.Identifier = .persian
        var manualLocale: String = "fa_IR"
        switch Localization.sharedInstance.getLanguage() {
        case "ar":
            identifier = .islamic
            manualLocale = "ar"
        case "fa-IR":
            identifier = .persian
            manualLocale = "fa_IR"
        default:
            identifier = .gregorian
            manualLocale = "en-us"
        }
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSS"
        
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "dd MMM - HH:mm"
            dateFormatter.timeZone = TimeZone(identifier: "Asia/Tehran")
            dateFormatter.calendar = Calendar(identifier: identifier)
            dateFormatter.locale = Locale(identifier: manualLocale)
            return dateFormatter.string(from: date)
        } else {
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let date = dateFormatter.date(from: self) {
                dateFormatter.dateFormat = "dd MMM - HH:mm"
                dateFormatter.timeZone = TimeZone(identifier: "Asia/Tehran")
                dateFormatter.calendar = Calendar(identifier: identifier)
                dateFormatter.locale = Locale(identifier: manualLocale)
                return dateFormatter.string(from: date)
            }
        }
        return ""
    }
    
    func UTCLocalWithFormat(inputFormat: String = "yyyy-MM-dd HH:mm:ss", outputFormat: String = "yyyy-MM-dd HH:mm") -> String {
        var identifier: Calendar.Identifier = .persian
        var manualLocale: String = "fa_IR"
        switch Localization.sharedInstance.getLanguage() {
        case "ar":
            identifier = .islamicTabular
            manualLocale = "ar"
        case "fa-IR":
            identifier = .persian
            manualLocale = "fa_IR"
        default:
            identifier = .gregorian
            manualLocale = "en-us"
        }
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = inputFormat
        
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = outputFormat
            dateFormatter.timeZone = TimeZone(identifier: "Asia/Tehran")
            dateFormatter.calendar = Calendar(identifier: identifier)
            dateFormatter.locale = Locale(identifier: manualLocale)
            return dateFormatter.string(from: date)
        }
        return ""
    }
    
    var addLineBreaker: String {
        return self.replacingOccurrences(of: "-", with: "\n")
    }
}

extension String {
    func toDoubleNumber() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}

extension String {
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }

    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }

    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }
}
