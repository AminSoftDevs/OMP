//
//  ChangeLanguageViewModel.swift
//  OMP_iOS
//
//  Created by AminSoft on 1/17/1401 AP.
//

import Foundation

class ChangeLanguageViewModel {
    
    //MARK: - PROPERTIES
    var languages: [AppLanguage] = []
    
    var selectedLanguage: AppLanguage?
    
    var languageDataSource: [String] {
        return self.languages.map({$0.description})
    }
    
    //MARK: - INITILIZER
    init() {
        guard let appConfiguration = UserDefaults.standard.appConfig else { return }
        self.languages = appConfiguration.languages
        self.selectedLanguage = UserDefaults.standard.selectedLanguage
    }
    
    //MARK: - FUNCTIONALS
        func handleNewLanguageSelection(by index: Int) {
        let selectedLanguage = languages[index].rawValue
        if languages[index].rawValue == "fa" {
            Localization.sharedInstance.setLanguage(language: "fa-IR")
        } else {
            Localization.sharedInstance.setLanguage(language: selectedLanguage)
        }
    }
    
    var timeZone: String {
        return TimeZone.current.identifier
    }
}
