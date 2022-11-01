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
    
    func fetchAndSaveMovies(with searchTerm: String) {
        Task {
            do {
                let results = try await apiController.fetchMovies(with: searchTerm)
                print(results)
            } catch {
                print(error)
            }
        }
    }
    
}
