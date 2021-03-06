//
//  MovieDetailInteractor.swift
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

protocol MovieDetailBusinessLogic
{
    func loadData()
}

protocol MovieDetailDataStore
{
    var selectedMovie: Movie { get set }
    var selectedMovieIndex: Int { get set }
}

class MovieDetailInteractor: MovieDetailBusinessLogic, MovieDetailDataStore
{
    var presenter: MovieDetailPresentationLogic?
    
    
    var selectedMovie: Movie = Movie()
    var selectedMovieIndex: Int = 0
    
    // MARK: Do something
    
    func loadData()
    {
        presenter?.presentMovie(movie: selectedMovie, selectedMovieIndex: selectedMovieIndex)
    }
}
