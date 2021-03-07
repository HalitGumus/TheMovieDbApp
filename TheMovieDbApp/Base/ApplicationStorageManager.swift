//
//  ApplicationStorageManager.swift
//  TheMovieDbApp
//
//  Created by HalitG on 7.03.2021.
//  Copyright © 2021 HalitG. All rights reserved.
//

import Foundation

open class ApplicationStorageManager: NSObject {
    public static let shared = ApplicationStorageManager()
    
    open var shouldRefreshMovie: Bool = false
    open var movieIndex: Int = 0
    
    
    public func setRefreshMovie(_ movieIndex: Int){
        self.movieIndex = movieIndex
        self.shouldRefreshMovie = true
    }
    
    public func resetRefreshMovie(){
        self.movieIndex = 0
        self.shouldRefreshMovie = false
    }
}
