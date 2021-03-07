//
//  MovieListHandler.swift
//  TheMovieDbApp
//
//  Created by HalitG on 7.03.2021.
//  Copyright (c) 2021 HalitG. All rights reserved.
//

import UIKit

class MovieListHandler: MovieListCollectionHandler {

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieListCell.identifier, for: indexPath) as! MovieListCell

        let movie = items[indexPath.row]
        cell.load(movie: movie, downloader: ImageDownloader.shared, pageType: pageType)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapBtnAction(_:)))
        cell.starButton.tag = indexPath.row
        cell.starButton.addGestureRecognizer(tapGesture)
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if pageType == .detail {
            return collectionView.frame.size
        }
        
        let cellWidth = collectionView.frame.size.width/2 - 5
        let cellHeight = collectionView.frame.size.height/2
        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }

}
