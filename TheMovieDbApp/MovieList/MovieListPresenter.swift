//
//  MovieListPresenter.swift
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

protocol MovieListPresentationLogic
{
  func presentSomething(response: MovieList.Something.Response)
}

class MovieListPresenter: MovieListPresentationLogic
{
  weak var viewController: MovieListDisplayLogic?
  
  // MARK: Do something
  
  func presentSomething(response: MovieList.Something.Response)
  {
    let viewModel = MovieList.Something.ViewModel()
    viewController?.displaySomething(viewModel: viewModel)
  }
}