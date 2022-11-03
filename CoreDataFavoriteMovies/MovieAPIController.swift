//
//  MovieAPIController.swift
//  CoreDataFavoriteMovies
//
//  Created by Parker Rushton on 11/1/22.
//

import Foundation

struct SearchResponse: Codable {
    let movies: [APIMovie]
    
    enum CodingKeys: String, CodingKey {
        case movies = "Search"
    }
}

struct APIMovie: Codable, Identifiable, Hashable {
    let title: String
    let year: String
    let imdbID: String
    let posterURL: URL?
    
    var id: String { imdbID }

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case posterURL = "Poster"
    }

}

class MovieAPIController {
    
    let baseURL = URL(string: "http://www.omdbapi.com/")!
    let apiKey = "12a1d7aa"
    
    func fetchMovies(with searchTerm: String) async throws -> [APIMovie] {
        var searchURL = baseURL
        let searchItem = URLQueryItem(name: "s", value: searchTerm)
        let apiKeyItem = URLQueryItem(name: "apiKey", value: apiKey)
        searchURL.append(queryItems: [searchItem, apiKeyItem])
        let (data, _) = try await URLSession.shared.data(from: searchURL)
        let searchResponse = try JSONDecoder().decode(SearchResponse.self, from: data)
        return searchResponse.movies
    }
    
}
