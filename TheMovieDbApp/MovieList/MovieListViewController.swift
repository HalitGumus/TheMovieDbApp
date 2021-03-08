//
//  MovieListViewController.swift
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

protocol MovieListDisplayLogic: class
{
    func load(movies: [Movie])
}

class MovieListViewController: UIViewController, MovieListDisplayLogic
{
    var interactor: MovieListBusinessLogic?
    var router: (NSObjectProtocol & MovieListRoutingLogic & MovieListDataPassing)?
    
    var viewCollection: UICollectionView!
    
    var handlerMovieList: MovieListHandler = MovieListHandler()
    
    private var searchText: String = ""
    private var currentPage: Int = 1
    
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
        let interactor = MovieListInteractor()
        let presenter = MovieListPresenter()
        let router = MovieListRouter()
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
        load()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if ApplicationStorageManager.shared.shouldRefreshMovie {
            let indexPath = IndexPath(item: ApplicationStorageManager.shared.movieIndex, section: 0)
            viewCollection.reloadItems(at: [indexPath])
            ApplicationStorageManager.shared.resetRefreshMovie()
        }
    }
    
    func load()
    {
        interactor?.fetchData(currentPage: currentPage, searchKey: nil)
    }
    
    func load(movies: [Movie]) {
        updateVisibility()
        handlerMovieList.items = movies
        handlerMovieList.movieListDataDelegate = self
        
        viewCollection.dataSource = handlerMovieList
        viewCollection.delegate = handlerMovieList
        
        viewCollection.reloadData()
        
        self.viewCollection.setContentOffset(CGPoint(x:0,y:0), animated: true)
    }
    
    func updateVisibility() {
        viewCollection.isHidden = false
        
        viewCollection.isPagingEnabled = true
    }
    
    @objc func nextPageButton() {
        currentPage += 1
        load()
    }
    
    @objc func backPageButton() {
        if currentPage != 1 {
            currentPage -= 1
            load()
        }
    }
}

private extension MovieListViewController {
    
    private func configure() {
        view.backgroundColor = .systemGray6
        configureNavigation()
        configureViewCollection()
    }
    
    private func configureNavigation() {
        let backBarButton = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(backPageButton))
        backBarButton.title = "Page Back /"
        backBarButton.tintColor = .systemGray
        
        let nextBarButton = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(nextPageButton))
        nextBarButton.title = " Next"
        nextBarButton.tintColor = .darkGray
        
        navigationItem.leftBarButtonItems = [backBarButton, nextBarButton]
        
        let searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width/2, height: 20))
        searchBar.placeholder = "Search Movie"
        searchBar.delegate = self
        let rightNavBarButton = UIBarButtonItem(customView:searchBar)
        self.navigationItem.rightBarButtonItem = rightNavBarButton
    }
    
    private func configureViewCollection() {
        let identifiers = MovieViewModel.Style.allCases
            .filter { !$0.isTable }
            .flatMap { $0.identifiers }
        viewCollection = UICollectionView(frame: .zero, direction: .vertical, identifiers: identifiers)
        viewCollection.register(MovieListCell.self, forCellWithReuseIdentifier: "MovieListCell")
        viewCollection.isHidden = true
        viewCollection.showsHorizontalScrollIndicator = false
        viewCollection.keyboardDismissMode = .onDrag
        
        view.addSubviewForAutoLayout(viewCollection)
        NSLayoutConstraint.activate([
            viewCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            viewCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            viewCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension MovieListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.searchMovies(_:)), object: searchBar)
        perform(#selector(self.searchMovies(_:)), with: searchBar, afterDelay: 0.75)
    }
    
    @objc
    func searchMovies(_ searchBar: UISearchBar){
        searchText = searchBar.text ?? ""
        self.interactor?.fetchData(currentPage: currentPage, searchKey: searchText)
    }
}

extension MovieListViewController: MovieListDataDelegate {
    func didSelectRow(movie: Movie, index: Int) {
        router?.routeToMovieDetail(movie: movie, index: index)
    }
    
    func didSelectStar(movie: Movie) { }
}
