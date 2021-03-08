//
//  MovieListInteractorTests.swift
//  TheMovieDbAppTests
//
//  Created by HalitG on 8.03.2021.
//  Copyright © 2021 HalitG. All rights reserved.
//

import XCTest

class MovieListInteractorTests: XCTestCase {
    // MARK: Subject under test
    
    var sut: MovieListInteractor!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        setupMovieListInteractor()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    //MARK: Test setup
    
    func setupMovieListInteractor(){
        sut = MovieListInteractor()
    }
    
    // MARK: Display Logic Spy
    
    class MovieListPresentationLogicSpy: MovieListPresentationLogic {
        var presentMovieCalled = false
        
        func presentMovie(movies: [Movie]) {
            presentMovieCalled = true
        }
        
    }
    
    // MARK: Tests
    
    func testPresentMovie() {
        // Given
        let spy = MovieListPresentationLogicSpy()
        sut.presenter = spy
        
        let predicate = NSPredicate(block: { any, _ in
            guard let spy = any as? MovieListPresentationLogicSpy else {
                return false
            }
            
            return spy.presentMovieCalled
        })
        
        _ = self.expectation(for: predicate, evaluatedWith: spy, handler: .none)
        
        // When
        sut.fetchData(currentPage: 1, searchKey: "")
        
        // Then
        waitForExpectations(timeout: 5, handler: .none)
    }
}
