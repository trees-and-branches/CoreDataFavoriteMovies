# CoreDataFavoriteMovies
# Part 1 - Movie Search + Favorites
## Initial Setup
- Create a new XCode project `FavoriteMovies` or `CoreDataFavoriteMovies`
- Make sure to check both the Core Data and `Host in CloudKit` check boxes
- These are the files you'll be adding right away:
    - `PersistenceController.swift`
    - `MovieSearchViewController.swift`
    - `MovieController.swift`
    - `MovieAPIController.swift`
    - `MovieTableViewCell.swift`
- Rename `ViewController` to `MovieSearchViewController`
- Make sure each one is embedded in a NavigationController
- Lets start in the `MovieSearchViewController`
    - Add a tableview with an IBOutlet
    - Set up a diffable datasource similar to `ToDoist`
- Create the `MovieTableViewCell` that will show both search results and favorite movies
    - Make sure the cell has a:
        - title label
        - year label
        - poster image
        - favorite button

## Core Data Model
- First, set up your Core Data stack by grabbing the Core Data code from the App Delegate and moving it into a `Persistence.swift` file similar to the `ToDoist` project from yesterday
    - Don't copy the one from `ToDoist` because it will be different
    - Make sure its got a shared instance and computed var `viewContext` that gives us access to the managed object context
- Now lets set up the model
    - Add an Entity called `Movie`
    - What properties should we give it?
    - It will be based on what the api can return to us. (skip down to the `Movie API` section to find out what properties the api will return)
    - Make sure you've got good names and the correct types for each of your attributes. 

## Movie API
### Test
- I always like to see the response I'm going to get from API before I try and code it up
- The api we'll be using can be found [here](http://www.omdbapi.com)
- Click on the `API Key` tab and get yourself an API key. You'll need it to be able to use the api
- Once you've got your API key we're going to try and test out the api
- If you don't have the `Postman` app downloaded already, download it [here](https://www.postman.com/downloads/)
- Grab the example url from the omdb documentation
- Insert your api key as a parameter
- Add the search parameter `s` to your query and search for a movie title (whatever you want)
- Check out the response it gives you. 
- I searched for `batman` and this is the first result I got:
```
{
    "Title": "Batman Begins",
    "Year": "2005",
    "imdbID": "tt0372784",
    "Type": "movie",
    "Poster": "https://m.media-amazon.com/images/M/MV5BOTY4YjI2N2MtYmFlMC00ZjcyLTg3YjEtMDQyM2ZjYzQ5YWFkXkEyXkFqcGdeQXVyMTQxNzMzNDI_V1_SX300.jpg"
 }
```

### Swift
- Now that we know what this API looks like, lets write the networking code to fetch a movie
- Add the `MovieAPIController.swift` file to the project
- This file will be responsible for fetching movies from the api
- Once we fetch the json from the API, we need to turn it into a Core Data `Movie`
- But don't forget about the single responsibility principle - The `MovieAPIController` shouldn't be responsible for fetching api movies AND saving them to Core Data!
- So lets create a struct at the top of the api controller called `APIMovie`. Make it `Codable`
    - We'll use it just as a transporter of data so the api controller can return `[APIMovie]` and the MovieController can turn them into Core Data `Movie`s
    - Take another close look at the response from postman. What is the top level object?
    ```
    {
    "Search": [
        {
            "Title": "Batman Begins",
            "Year": "2005",
    ```
    - So there is a top level object that has one property call `Search` which is an array of movies
    - So if we want Codable to work its magic for us we need to copy that format exactly
    - Add another struct above `APIMovie` called `SearchResponse`
        - Give it one property `let movies: [APIMovie]`
    - Then add this enum so the coding keys will match up with the api:
    ```
    enum CodingKey: String {
        case movies = "Search"
    }
    ```
- Add these properties to the api controller:
    - `let baseURL = URL(string: "http://www.omdbapi.com/")!`
    - `let apiKey = "notARealAPIKey"`
- Now you're ready to add the function that fetches movies. Here's the signature:
    - `func fetchMovies(with searchTerm: String) async throws -> [APIMovie]`
    - Inside the function:
    - Add the two query items to the url:
         - `let apiKeyItem = URLQueryItem(name: "apiKey", value: apiKey)`
         - `let searchItem = URLQueryItem(name: "s", value: searchTerm)`
     - Use `URLSession.shared.data(from: url)` to get the data at the url
     - Decode the response into a `SearchResponse`
     - Return the movies of the search response
### Now what?
- What do we do next??
- We've got a function that is supposed to fetch movies from the api, but we don't have any UI to show the results, and we can't save the movies to core data. How can we tell our code is working?
- This is a great principle to start practicing, isolate PIECES of your code and test them in isolation. 
    - If you have code to run an API call, and code to display api results in a table, and your table is empty, how do you know which code is at fault??
    - Test your API code first without the UI and make sure its working. That way, when your tableview inevitably doesn't work 😅, you know which code is to blame
- Add `MovieController` if you haven't already
    - Make it look like this:
    ```
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

    ```
## Core Data CRUD
## TableView UI
## Fetched Results Controller
## Favorites

# Part 2 - Images + Core Spotlight