//
//  Settings.swift
//  TheMovieDbApp
//
//  Created by HalitG on 7.03.2021.
//  Copyright (c) 2021 HalitG. All rights reserved.
//

import Foundation

struct Settings {
    static var shared = Settings()

    static let StyleKey = "style"
    static let CategoryKey = "category"

    static let StyleDefault: MovieViewModel.Style = .movieList
    static let CategoryDefault: MovieCategory = .general

    var category: MovieCategory = UserDefaultsConfig.savedCategory {
        didSet {
            UserDefaultsConfig.savedCategory = category
        }
    }

    var style: MovieViewModel.Style = UserDefaultsConfig.savedStyle {
        didSet {
            UserDefaultsConfig.savedStyle = style
        }
    }
}

struct UserDefaultsConfig {
    @UserDefault(Settings.CategoryKey, defaultValue: Settings.CategoryDefault)
    static var savedCategory: MovieCategory

    @UserDefault(Settings.StyleKey, defaultValue: Settings.StyleDefault)
    static var savedStyle: MovieViewModel.Style
}
