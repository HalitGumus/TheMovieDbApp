//
//  TheMovieDbAppTests.swift
//  TheMovieDbAppTests
//
//  Created by HalitG on 6.03.2021.
//  Copyright © 2021 HalitG. All rights reserved.
//

import XCTest
@testable import TheMovieDbApp

class TheMovieDbAppTests: XCTestCase {
    
    func testUserDefaultsPropertyWrapperSetter() throws {
        // When
        let category = MovieCategory.action
        UserDefaultsConfig.savedCategory = category
        
        // Then
        let value = UserDefaultsConfig.savedCategory
        XCTAssertTrue(value.rawValue == category.rawValue)
    }
    
    func testViewStyleIsTable() {
        // When
        let style = MovieViewModel.Style.movieList
        
        // Then
        XCTAssertFalse(style.isTable)
    }
    
    func testChangingCategoryConfiguration() throws {
        // Given
        var settings = Settings()
        
        // When
        let category = MovieCategory.comedy
        settings.category = category
        
        // Then
        XCTAssertTrue(settings.category.rawValue == category.rawValue)
    }
    
    func testChangingStyleConfiguration() throws {
        // Given
        var settings = Settings()
        
        // When
        let style = MovieViewModel.Style.movieList
        settings.style = style
        
        // Then
        XCTAssertTrue(settings.style.rawValue == style.rawValue)
    }
    
}
