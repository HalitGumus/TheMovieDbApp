//
//  MovieViewModel.swift
//  TheMovieDbApp
//
//  Created by HalitG on 7.03.2021.
//  Copyright (c) 2021 HalitG. All rights reserved.
//

import UIKit

class MovieViewModel {
    
    var controller: MovieListViewController
    
    var style: Style = Settings.shared.style
    
    var categoryName: String = ""
    var searchKey: String = ""
    
    init(controller: MovieListViewController) {
        self.controller = controller
    }
    
    func load(searchKey: String) {
        loadMovies(searchKey: searchKey)
        controller.load()
    }
    
    func loadMovies(category: String = Settings.shared.category.rawValue, searchKey: String) {
        let url = MovieApi.urlForCategory(page: "1", searchKey: searchKey)
        MovieApi.getMovies(url: url) { [weak self] (movies) in
            guard let movies = movies else { return }
            self?.controller.load(movies: movies)
            self?.controller.load()
        }
        
        categoryName = category.capitalized
    }
    
    func select(category: String, searchKey: String) {
        loadMovies(category: category, searchKey: searchKey)
        
        guard let movieCategory = MovieCategory(rawValue: category) else { return }
        Settings.shared.category = movieCategory
    }
    
    func select(_ aStyle: Style) {
        style = aStyle
        controller.load()
        Settings.shared.style = style
    }
    
    var categoryMenu: UIMenu {
        let menuActions = MovieCategory.allCases.map({ (item) -> UIAction in
            let name = item.rawValue
            return UIAction(title: name.capitalized, image: UIImage(systemName: item.systemName)) { (_) in
                self.select(category: name, searchKey: self.searchKey)
            }
        })
        
        return UIMenu(title: "Change Category", children: menuActions)
    }
    
    var styleMenu: UIMenu {
        let menuActions = MovieViewModel.Style.allCases.map { (style) -> UIAction in
            return UIAction(title: style.display, image: nil) { (_) in
                self.select(style)
            }
        }
        
        return UIMenu(title: "Change Style",children: menuActions)
    }
    
    enum Style: String, CaseIterable, Codable {
        
        case movieList
        case detailList
        
        var display: String {
            switch self {
            case .movieList:
                return "movieList"
            case .detailList:
                return "detailList"
            }
        }
        
        var isTable: Bool {
            switch self {
            case .movieList:
                return false
            case .detailList:
                return false
            }
        }
        
        var identifiers: [String] {
            switch self {
            case .movieList:
                return [MovieListCell.identifier]
            case .detailList:
                return [MovieListCell.identifier]
            }
        }
        
    }
    
}
