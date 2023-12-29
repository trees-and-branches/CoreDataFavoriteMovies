//
//  MovieAPIController.swift
//  CoreDataFavoriteMovies
//
//  Created by Parker Rushton on 11/1/22.
//

import Foundation

enum MovieAPIError: Error, LocalizedError {
    case badResponse
}

class MovieAPIController {
    
    let baseURL = URL(string: "http://www.omdbapi.com/")!
    let apiKey = "6d9f375f"
    
    func fetchMovies(with searchTerm: String) async throws -> [APIMovie] {
        let queryItems = [ URLQueryItem(name: "apiKey", value: apiKey),
          URLQueryItem(name: "s", value: searchTerm) ]
        
        let url = baseURL.appending(queryItems: queryItems)
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw MovieAPIError.badResponse
        }
        
        let searchResponse = try JSONDecoder().decode(SearchResponse.self, from: data)
        
        return searchResponse.movies
        
    }
    

}
//    private func fakeMovies() -> [APIMovie] {
//        let posterURL1 = URL(string: "https://m.media-amazon.com/images/M/MV5BN2ZkNDgxMjMtZmRiYS00MzFkLTk5ZjgtZDJkZWMzYmUxYjg4XkEyXkFqcGdeQXVyNTIzOTk5ODM@._V1_SX300.jpg")
//        let mockMovie1 = APIMovie(title: "Nacho Libre", year: "2006", imdbID: "tt0457510", posterURL: posterURL1)
//        let posterURL2 = URL(string: "https://m.media-amazon.com/images/M/MV5BNjYwNTA3MDIyMl5BMl5BanBnXkFtZTYwMjIxNjA3._V1_SX300.jpg")
//        let mockMovie2 = APIMovie(title: "Napoleon Dynamite", year: "2004", imdbID: "tt0374900", posterURL: posterURL2)
//        let mockMovie3 = APIMovie(title: "Unknown Thriller", year: "not sure", imdbID: "tt03948", posterURL: nil)
//        return [mockMovie1, mockMovie2, mockMovie3]
//    }
    
