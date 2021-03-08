//
//  MovieListViewControllerTests.swift
//  TheMovieDbAppTests
//
//  Created by HalitG on 8.03.2021.
//  Copyright © 2021 HalitG. All rights reserved.
//

import XCTest

class MovieListViewControllerTests: XCTestCase {
    // MARK: Subject under test
    
    var sut: MovieListViewController!
    var window: UIWindow!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        window = UIWindow()
        
        setupMovieListViewController()
    }
    
    override func tearDown() {
        window = nil
        super.tearDown()
    }
    
    //MARK: Test setup
    
    func setupMovieListViewController(){
        sut = MovieListViewController()
    }
    
    func loadView(){
        window.addSubview(sut.view)
    }
    
    // MARK: Test doubles
    
    class MovieListBusinessLogicSpy: NSObject, MovieListBusinessLogic {
        var fetchDataCalled = false
        
        func fetchData(currentPage: Int, searchKey: String?) {
            fetchDataCalled = true
        }
    }
    
    class MovieListRoutingLogicSpy: NSObject, MovieListRoutingLogic, MovieListDataPassing {
        
        var dataStore: MovieListDataStore?
        
        var routeToMovieDetailCalled = false
        
        func routeToMovieDetail(movie: Movie, index: Int) {
            routeToMovieDetailCalled = true
        }
        
    }
    
    // MARK: Tests
    
    func testViewDidLoad(){
        // Given
        let spy = MovieListBusinessLogicSpy()
        sut.interactor = spy
        
        // When
        loadView()
        sut.viewDidLoad()
        
        // Then
        XCTAssertTrue(spy.fetchDataCalled)
    }
    
    func testRouteToMovieDetail(){
        // Given
        let spy = MovieListRoutingLogicSpy()
        sut.router = spy
        
        // When
        sut.didSelectRow(movie: Movie(), index: 0)
        
        //Then
        XCTAssertTrue(spy.routeToMovieDetailCalled)
    }
}
