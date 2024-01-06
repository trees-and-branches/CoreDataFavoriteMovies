//
//  FavoritesViewController.swift
//  CoreDataFavoriteMovies
//
//  Created by Parker Rushton on 11/3/22.
//

import UIKit

class FavoritesViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var backgroundView: UIView!
    
    
    private var datasource: UITableViewDiffableDataSource<Int, Movie>!
    
    private lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        sc.delegate = self
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.placeholder = "Search a movie title"
        sc.searchBar.delegate = self
        return sc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        navigationItem.searchController = searchController
        fetchFavorites()
//        tableView.reloadData()
    }

}

extension FavoritesViewController: UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text {
            
                fetchFavorites()
            
        }
    }
}

private extension FavoritesViewController {
    
    func setUpTableView() {
        tableView.backgroundView = backgroundView
        setUpDataSource()
        tableView.register(UINib(nibName: MovieTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: MovieTableViewCell.reuseIdentifier)
    }
    
    func setUpDataSource() {
        datasource = UITableViewDiffableDataSource<Int, Movie>(tableView: tableView) { tableView, indexPath, movie in
            let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.reuseIdentifier) as! MovieTableViewCell
            cell.update(with: movie) {
//                self.toggleFavorite(movie)
                self.removeFavorite(movie) // onFavorite is what is being called here
            }
            return cell
        }
    }
    
    func applyNewSnapshot(from movies: [Movie]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Movie>()
        snapshot.appendSections([0])
        snapshot.appendItems(movies)
        datasource?.apply(snapshot, animatingDifferences: true)
        tableView.backgroundView = movies.isEmpty ? backgroundView : nil
    }
    
    func fetchFavorites() {
        let fetchRequest = Movie.fetchRequest()
        if let searchString = searchController.searchBar.text, !searchString.isEmpty {
            fetchRequest.predicate = NSPredicate(format: "title CONTAINS[c] %@", searchString)
        }
        
        
        do {
            let movies = try PersistenceController.shared.viewContext.fetch(fetchRequest)
            applyNewSnapshot(from: movies)
        } catch {
        print("error fetching Movies \(error)")
            applyNewSnapshot(from: [])
        }
        
    }
    func removeFavorite(_ movie: Movie) {
        MovieController.shared.unfavoriteMovie(movie)
        var snapshot = datasource.snapshot()
        snapshot.deleteItems([movie])
        datasource?.apply(snapshot, animatingDifferences: true)
    }

    
    
    
}
