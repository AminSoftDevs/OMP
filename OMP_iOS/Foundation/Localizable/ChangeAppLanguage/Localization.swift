//
//  Localization.swift
//  OMP_iOS
//
//  Created by AminSoft on 8/8/1400 AP.
//

import UIKit

enum LanguageDirection : Int {
    case leftToRight = 1
    case rightToLeft = 2
}

class Localization {
    static let sharedInstance = Localization()
    var bundle: Bundle? = nil
    var languageDirection = LanguageDirection(rawValue: 1)
    
    private init() {}
    // Get direction of language
    func getlanguageDirection() -> LanguageDirection {
        if getLanguage() == "fa-IR" {
            return .rightToLeft
        } else if getLanguage() == "fa" {
            return .rightToLeft
        } else if getLanguage() == "ar" {
            return .rightToLeft
        } else {
            return .leftToRight
        }
    }
    
    // get localizedString from bundle of selected language
    func localizedString(forKey key: String, value comment: String) -> String {
        if let localized = bundle?.localizedString(forKey: key, value: comment, table: nil) {
            return localized
        } else {
            return ""
        }
    }
    
    // set language for localization
    func setLanguage(language: String, withRefresh: Bool = false) -> Void {
        
        var selectedLanguage = language
        if language.count == 0 {
            selectedLanguage = "fa-IR"
        }
        
        if AppLanguage(rawValue: selectedLanguage) == nil {
            UserDefaults.standard.selectedLanguage = .persian
        } else {
            UserDefaults.standard.selectedLanguage = AppLanguage(rawValue: selectedLanguage)
        }
        
        let path: String? = Bundle.main.path(forResource: selectedLanguage, ofType: "lproj")
        if path == nil {
            //in case the language does not exists
            resetLocalization()
        } else {
            bundle = Bundle(path: path!)
        }
        
        if withRefresh {
            DispatchQueue.main.async(execute: {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.initRootView()
            })
        }
    }
    
    // reset bundle
    func resetLocalization() {
        bundle = Bundle.main
    }
    
    // get selected language from UserDefaults
    func getLanguage(firstRun isInitialState: Bool = false) -> String? {
        if let language = UserDefaults.standard.selectedLanguage {
            
//            if isInitialState {
//                
//                if let locale = NSLocale.current.languageCode, locale != language.rawValue {
//                    setLanguage(language: (locale == "fa") ? "fa_IR" : locale, withRefresh: false)
//                }
//                
//                return NSLocale.current.languageCode
//            }
            
            return language.rawValue == "fa" ? "fa-IR" : language.rawValue
        }
        return nil
    }
}
