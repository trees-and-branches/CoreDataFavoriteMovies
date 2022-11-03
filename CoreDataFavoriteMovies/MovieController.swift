//
//  MovieController.swift
//  CoreDataFavoriteMovies
//
//  Created by Parker Rushton on 11/1/22.
//

import Foundation

class MovieController {
    static let shared = MovieController()
    private let apiController = MovieAPIController()
    private var viewContext = PersistenceController.shared.viewContext
    
    func fetchMovies(with searchTerm: String) async throws -> [APIMovie] {
        return try await apiController.fetchMovies(with: searchTerm)
    }
    
    func favoriteMovie(_ movie: APIMovie) {
        let newMovie = Movie(context: viewContext)
        newMovie.title = movie.title
        newMovie.imdbID = movie.imdbID
        newMovie.year = movie.year
        newMovie.createdAt = Date()
        newMovie.favoritedAt = nil
        newMovie.posterURLString = movie.posterURL?.absoluteString
    }
    
    func unFavoriteMovie(_ movie: Movie) {
        let context = PersistenceController.shared.viewContext
        context.delete(movie)
        PersistenceController.shared.saveContext()
    }
    
}
