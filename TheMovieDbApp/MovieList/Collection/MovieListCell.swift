//
//  MovieListCell.swift
//  TheMovieDbApp
//
//  Created by HalitG on 7.03.2021.
//  Copyright (c) 2021 HalitG. All rights reserved.
//

import UIKit

class MovieListCell: UICollectionViewCell {
    
    static let identifier = "MovieListCell"
    
    var imageView: UIImageView = UIImageView()
    var starButton: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    
    private let detailImageSize: Int = 500
    private let listImageSize: Int = 200
    
    var title = UILabel()
    var ago = UILabel()
    var overview = UILabel()
    var vote = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        build()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
    }
    
    func build() {
        imageView.backgroundColor = .systemFill
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        starButton.backgroundColor = .clear
        starButton.imageView?.tintColor = .yellow
        starButton.contentMode = .scaleAspectFill
        starButton.clipsToBounds = true
        
        title.numberOfLines = 0
        title.textColor = .white
        title.font = .preferredFont(forTextStyle: .largeTitle)
        
        ago.textColor = .systemGray
        ago.font = .preferredFont(forTextStyle: .subheadline)
        
        overview.numberOfLines = 0
        overview.textColor = .systemGray2
        overview.font = .preferredFont(forTextStyle: .body)
        
        vote.textColor = .white
        
        [imageView, starButton, title, ago, overview, vote].forEach {
            contentView.addSubviewForAutoLayout($0)
        }
        
        let inset: CGFloat = 15
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            starButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            starButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            ago.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            contentView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: ago.bottomAnchor),
            
            overview.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            overview.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            ago.topAnchor.constraint(equalTo: overview.bottomAnchor, constant: 10),
            
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            overview.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5),
            
            vote.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            title.topAnchor.constraint(equalTo: vote.bottomAnchor, constant: 5)
        ])
    }
    
    func load(movie: Movie, downloader: ImageDownloader, pageType: MoviePageTye) {
        
        ago.text = movie.ago
        title.text = movie.title
        
        contentView.addGradient(count: 5, index: 1)
        
        if pageType == .detail {
            if let voteCount = movie.vote_count {
                vote.text = "Vote Count: \(voteCount)"
            }
            overview.text = movie.overview
            //source.text = movie.source?.name
            starButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
        
        if let id = movie.id, FavoriteMovies.shared.isFavorite(id){
            starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else if pageType == .list {
            starButton.setImage(nil, for: .normal)
        }
        
        imageView.load(urlString: movie.poster_path, size:
            CGSize( width: pageType == .detail ? detailImageSize : listImageSize, height: listImageSize), downloader: downloader)
        
        self.imageView.bounds = self.frame
        self.imageView.addGradient(count: 5, index: 1)
    }
    
}

