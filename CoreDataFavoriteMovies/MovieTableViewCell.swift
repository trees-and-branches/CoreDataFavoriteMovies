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
    
    private var movie: Movie?
    private var apiMovie: APIMovie?
    
    private var heart = UIImage(systemName: "heart")
    private var favoritedHeart = UIImage(systemName: "heart.fill")
    
    func update(with movie: Movie) {
        self.movie = movie
        titleLabel.text = movie.title
        yearLabel.text = movie.year
        heartButton.setImage(favoritedHeart, for: .normal)
        heartButton.tintColor = .red
    }
    
    func update(with movie: APIMovie) {
        self.apiMovie = movie
        titleLabel.text = movie.title
        yearLabel.text = movie.year
        heartButton.setImage(heart, for: .normal)
        heartButton.tintColor = .gray
    }
    
    @IBAction func favoriteButtonPressed() {
    }
    
}
