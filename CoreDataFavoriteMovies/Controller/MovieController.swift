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
        let FavoritedMovie = Movie(context: viewContext)
        FavoritedMovie.id = movie.id
        FavoritedMovie.imdbID = movie.imdbID
        FavoritedMovie.title = movie.title
        if let posterURL = movie.posterURL {
            FavoritedMovie.posterURLString = posterURL.absoluteString
        }
        
        PersistenceController.shared.saveContext()
        
    }
    
    func unfavoriteMovie(_ movie: Movie) {
        viewContext.delete(movie)
        PersistenceController.shared.saveContext()
    }
    
    func favoriteMovie(from movie: APIMovie) -> Movie? {
            let fetchRequest = Movie.fetchRequest()
            let imdbID = movie.imdbID
            fetchRequest.predicate = NSPredicate(format: "imdbID LIKE %@", imdbID)
        fetchRequest.fetchLimit = 1
            
            do {
                let fetchedMovie = try PersistenceController.shared.viewContext.fetch(fetchRequest).first
                return fetchedMovie
            } catch {
            print("error fetching Movie \(error)")
                return nil
            }
            
        
        }
    
    
}
