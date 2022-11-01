//
//  ViewController.swift
//  CoreDataFavoriteMovies
//
//  Created by Parker Rushton on 10/29/22.
//

import UIKit

class MovieSearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private let movieController = MovieController.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieController.fetchAndSaveMovies(with: "batman")
    }


}

