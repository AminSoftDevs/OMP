//
//  Language.swift
//  OMP_iOS
//
//  Created by AminSoft on 8/8/1400 AP.
//

import Foundation

class Language: NSObject {
    
    open var languageCode: String
    open var language: String
    
    public static var emptyLanguage: Language {
        return Language(languageCode: "", language: "")
    }
    
    //     Constructor to initialize a country
    //     countryCode: the country code
    public init(languageCode: String, language: String) {
        
        self.languageCode = languageCode
        self.language = language
    }
    
    open override var description: String{
        return self.languageCode + " " + self.language
    }
}
