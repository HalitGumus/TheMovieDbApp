//
//  MovieListPresenterTets.swift
//  TheMovieDbAppTests
//
//  Created by HalitG on 8.03.2021.
//  Copyright © 2021 HalitG. All rights reserved.
//

import XCTest

class MovieListPresenterTests: XCTestCase {
    // MARK: Subject under test
    
    var sut: MovieListPresenter!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        setupMovieListPresenter()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    //MARK: Test setup
    func setupMovieListPresenter(){
        sut = MovieListPresenter()
    }
    
    // MARK: Display Logic Spy
    
    class MovieListDisplayLogicSpy: UIViewController, MovieListDisplayLogic {
        
        var loadCalled = false
        
        func load(movies: [Movie]) {
            loadCalled = true
        }
    }
    
    // MARK: Tests
    
    func testLoad(){
        //Given
        let spy = MovieListDisplayLogicSpy()
        sut.viewController = spy
        
        //When
        sut.presentMovie(movies: [Movie()])
        
        //Then
        XCTAssertTrue(spy.loadCalled)
    }
}
