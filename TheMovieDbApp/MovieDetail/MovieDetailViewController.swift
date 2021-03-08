//
//  MovieDetailViewController.swift
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

protocol MovieDetailDisplayLogic: class
{
    func load(movie: Movie?, selectedMovieIndex: Int)
}

class MovieDetailViewController: UIViewController, MovieDetailDisplayLogic
{
    var interactor: MovieDetailBusinessLogic?
    var router: (NSObjectProtocol & MovieDetailRoutingLogic & MovieDetailDataPassing)?
    
    @IBOutlet var viewCollection: UICollectionView!
    
    var handlerMovieList: MovieListHandler = MovieListHandler()
    
    var selectedMovieIndex: Int = 0
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup()
    {
        let viewController = self
        let interactor = MovieDetailInteractor()
        let presenter = MovieDetailPresenter()
        let router = MovieDetailRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        configure()
        interactor?.loadData()
    }
    
    func load(movie: Movie?, selectedMovieIndex: Int) {
        updateVisibility()
        handlerMovieList.items = [movie!]
        handlerMovieList.pageType = .detail
        handlerMovieList.movieListDataDelegate = self
        
        self.title = movie?.title ?? ""
        
        viewCollection.dataSource = handlerMovieList
        viewCollection.delegate = handlerMovieList
        
        self.selectedMovieIndex = selectedMovieIndex
        
        viewCollection.reloadData()
    }
    
    func updateVisibility() {
        viewCollection.isHidden = false
        
        viewCollection.isPagingEnabled = true
    }
}

private extension MovieDetailViewController {
    
    private func configure() {
        view.backgroundColor = .systemGray6
        self.navigationController?.navigationBar.tintColor = .systemGray
        configureViewCollection()
    }
    
    private func configureViewCollection() {
        let identifiers = MovieViewModel.Style.allCases
            .filter { !$0.isTable }
            .flatMap { $0.identifiers }
        viewCollection = UICollectionView(frame: .zero, direction: .vertical, identifiers: identifiers)
        viewCollection.register(MovieListCell.self, forCellWithReuseIdentifier: "MovieListCell")
        viewCollection.isHidden = true
        viewCollection.isScrollEnabled = false
        
        view.addSubviewForAutoLayout(viewCollection)
        NSLayoutConstraint.activate([
            viewCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            viewCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            viewCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension MovieDetailViewController: MovieListDataDelegate {
    func didSelectRow(movie: Movie, index: Int) { }
    
    func didSelectStar(movie: Movie) {
        if let id = movie.id {
            FavoriteMovies.shared.setFavoriteMovie(id)
            ApplicationStorageManager.shared.setRefreshMovie(selectedMovieIndex)
            viewCollection.reloadData()
        }
    }
}
