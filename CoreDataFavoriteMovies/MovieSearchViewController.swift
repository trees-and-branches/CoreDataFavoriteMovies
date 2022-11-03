//
//  ViewController.swift
//  CoreDataFavoriteMovies
//
//  Created by Parker Rushton on 10/29/22.
//

import UIKit
import CoreData

class MovieSearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private let movieController = MovieController.shared
    private var datasource: UITableViewDiffableDataSource<Int, APIMovie>!

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
        setUpDataSource()
        setupNavigationBar()
    }
    
}

private extension MovieSearchViewController {
    
    func setUpDataSource() {
        datasource = UITableViewDiffableDataSource<Int, APIMovie>(tableView: tableView) { tableView, indexPath, movie in
            let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.reuseIdentifier) as! MovieTableViewCell
            cell.update(with: movie)
            return cell
        }
    }
    
    func setupNavigationBar() {
        navigationItem.searchController = searchController
    }
    
    func fetchNewMovies() {
        let searchString = searchController.searchBar.text ?? ""
        if searchString.isEmpty {
            applyNewSnapshot(from: [])
            return
        }
        Task {
            let searchResults = try? await movieController.fetchMovies(with: searchString)
            applyNewSnapshot(from: searchResults ?? [])
        }
    }
    
    func applyNewSnapshot(from movies: [APIMovie]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, APIMovie>()
        snapshot.appendSections([0])
        snapshot.appendItems(movies)
        datasource?.apply(snapshot, animatingDifferences: true)
    }

}


// MARK: - UISearchResult Updating and UISearchControllerDelegate

extension MovieSearchViewController: UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        return
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        fetchNewMovies()
    }
    
}
