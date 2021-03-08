//
//  MovieListCollectionHandler.swift
//  TheMovieDbApp
//
//  Created by HalitG on 7.03.2021.
//  Copyright (c) 2021 HalitG. All rights reserved.
//

import UIKit


protocol MovieListDataDelegate {
    func didSelectRow(movie: Movie, index: Int)
    func didSelectStar(movie: Movie)
}

class MovieListCollectionHandler: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var items: [Movie] = []
    var movieListDataDelegate: MovieListDataDelegate?
    var pageType: MoviePageTye = .list
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        self.movieListDataDelegate?.didSelectRow(movie: item, index: indexPath.row)
    }
    
    @objc func tapBtnAction(_ sender: UITapGestureRecognizer) {
        if let index = sender.view?.tag {
            let item = items[index]
            self.movieListDataDelegate?.didSelectStar(movie: item)
        }
    }
}
