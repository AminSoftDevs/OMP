//
//  SettingViewModel.swift
//  OMP_iOS
//
//  Created by AminSoft on 7/25/1400 AP.
//

import Foundation

class SettingViewModel {
    
    var languages: [AppLanguage] = []
    var selectedLanguage: AppLanguage?
    
    var themes: [AppTheme] = []
    var selectedTheme: AppTheme?
    
    let dataForCellType: [String] = ["AccountViewController.language".localized,
                                 "AccountViewController.displayMode".localized,
                                 "AccountViewController.marketType".localized]
    
    let markets: [AppMarket] = [.real, .demo]
    var selectedMarket: AppMarket?
    
    init() {
        guard let appConfig = UserDefaults.standard.appConfig else { return }
        self.languages = appConfig.languages
        self.themes = appConfig.themes
        
        self.selectedLanguage = UserDefaults.standard.selectedLanguage
        self.selectedTheme = UserDefaults.standard.selectedTheme
        self.selectedMarket = UserDefaults.standard.selectedMarket
    }
    
    var languageDataSource: [String] {
        self.languages.map({$0.description})
    }
    
    var themeDataSource: [String] {
        self.themes.map({$0.description})
    }
    
    var marketDataSource: [String] {
        self.markets.map({$0.description})
    }
    
    func dropDownLanguageItemDidSelect(at index: Int) {
        if selectedLanguage == nil {
            selectedLanguage = languages[index]
        }
    }
    
    func dropDownThemeItemDidSelect(at index: Int) {
        if selectedTheme == nil {
            selectedTheme = themes[index]
        }
    }
    
    func dropDownMarketItemDidSelect(at index: Int) {
        if selectedMarket == nil {
            selectedMarket = markets[index]
        }
    }
    
    func isSelectedItem(for index: Int, dropDownType: SettingViewController.DropDownType) -> Bool {
        switch dropDownType {
        case .language:
            return languages[index] == selectedLanguage
            
        case .theme:
            return themes[index] == selectedTheme
            
        case .marketType:
            return markets[index] == selectedMarket
        }
    }
    
    func handleNewItemSelection(_ index: Int, type: SettingViewController.DropDownType) {
        switch type {
        case .language:
            UserDefaults.standard.selectedLanguage = languages[index]
            
        case .theme:
            UserDefaults.standard.selectedTheme = themes[index]
            
        case .marketType:
            UserDefaults.standard.selectedMarket = markets[index]
        }
    }
    
    func handleNewLanguageSelection(by index: Int) {
        
        let selectedLanguage = languages[index].rawValue
        if languages[index].rawValue == "fa"  {
            Localization.sharedInstance.setLanguage(language: "fa-IR", withRefresh: true)
        } else {
            Localization.sharedInstance.setLanguage(language: selectedLanguage, withRefresh: true)
        }
        
    }
}
