//
//  AppConfig.swift
//  OMP_iOS
//
//  Created by AminSoft on 7/25/1400 AP.
//

import Foundation

class AppConfig: Codable {
    
    let languages: [AppLanguage]
    let themes: [AppTheme]
    
    init(languages: [AppLanguage], themes: [AppTheme]) {
        self.languages = languages
        self.themes = themes
    }
}

enum AppLanguage: String, Codable {
    case persian = "fa"
    case english = "en"
    case arabic  = "ar"
    
    var description: String {
        switch self {
        case .persian:
            return "AccountViewController.persian".localized
        case .english:
            return "AccountViewController.english".localized
        case .arabic:
            return "AccountViewController.arabic".localized
        }
    }
}

enum AppTheme: String, Codable {
    case light = "light"
    case dark = "dark"
    case OMP = "omp"
    
    var description: String {
        switch self {
        case .light:
            return "AccountViewController.themeLight".localized
        case .dark:
            return "AccountViewController.themeDark".localized
        case .OMP:
            return "AccountViewController.themeOMP".localized
        }
    }
}

enum AppMarket: String, Codable {
    case demo = "/demo"
    case real = ""
    
    var description: String {
        switch self {
        case .demo:
            return "AccountViewController.demoMarket".localized
        case .real:
            return "AccountViewController.realMarkert".localized
        }
    }
}
