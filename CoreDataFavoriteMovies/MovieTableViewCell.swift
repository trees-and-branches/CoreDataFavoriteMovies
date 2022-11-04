//
//  MovieTableViewCell.swift
//  CoreDataFavoriteMovies
//
//  Created by Parker Rushton on 10/31/22.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    static let reuseIdentifier = "MovieTableViewCell"
    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var heartButton: UIButton!

    var onFavorite: (() -> Void)?
    
    private var movie: Movie?
    private var apiMovie: APIMovie?
    
    private var heart = UIImage(systemName: "heart")
    private var favoritedHeart = UIImage(systemName: "heart.fill")
    
    func update(with movie: Movie, onFavorite: (() -> Void)?) {
        self.movie = movie
        self.onFavorite = onFavorite
        titleLabel.text = movie.title
        yearLabel.text = movie.year
        setFavorite()
    }
    
    func update(with movie: APIMovie, onFavorite: (() -> Void)?) {
        self.apiMovie = movie
        self.onFavorite = onFavorite
        titleLabel.text = movie.title
        yearLabel.text = movie.year
        if MovieController.shared.favoriteExists(for: movie) {
            setFavorite()
        } else {
            setUnFavorite()
        }
    }

    func setFavorite() {
        heartButton.setImage(favoritedHeart, for: .normal)
        heartButton.tintColor = .red
    }
    
    func setUnFavorite() {
        heartButton.setImage(heart, for: .normal)
        heartButton.tintColor = .gray
    }
    
    @IBAction func favoriteButtonPressed() {
        onFavorite?()
    }
    
}
