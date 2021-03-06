//
//  MovieListInteractor.swift
//  TheMovieDbApp
//
//  Created by HalitG on 7.03.2021.
//  Copyright (c) 2021 HalitG. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol MovieListBusinessLogic
{
    func fetchData(currentPage: Int, searchKey: String?)
}

protocol MovieListDataStore
{
    //var name: String { get set }
}

class MovieListInteractor: MovieListBusinessLogic, MovieListDataStore
{
    var presenter: MovieListPresentationLogic?
    var movies: [Movie] = []
    
    func fetchData(currentPage: Int,searchKey: String?)
    {
        if searchKey == nil {
            loadData(page: currentPage, searchKey: "")
            return
        }else if searchKey == "" {
            self.presenter?.presentMovie(movies: movies)
            return
        }
        
        let searchMovies = movies.filter {($0.title!.contains(searchKey!))}
        
        self.presenter?.presentMovie(movies: searchMovies)
    }
    
    private func loadData(page: Int, searchKey: String) {
        guard let url = MovieApi.urlForCategory(page: "\(page)", searchKey: searchKey) else {
            print("load data error")
            return
        }
        
        MovieApi.getMovies(url: url) { [weak self] (movies) in
            guard let movies = movies else { return }
            self?.movies = movies
            self?.presenter?.presentMovie(movies: movies)
        }
    }
}
