//
//  MovieListViewController.swift
//  Movie
//
//  Created by Abhinav Saini on 20/02/25.
//


import UIKit
import SDWebImage

class MovieListViewController: UIViewController {
    @IBOutlet weak var movieTableView: UITableView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextField: UITextField!

    let viewModel = MovieViewModel()
    var filteredMovies: [Movie] = []
    var isSearching = false
    var showingFavorites = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        initialLoad()
    }

    func initialLoad() {
        movieTableView.dataSource = self
        movieTableView.delegate = self
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(searchMovies), for: .editingChanged)
        
        searchView.layer.cornerRadius = 8
        searchView.layer.borderColor = UIColor.lightGray.cgColor
        searchView.layer.borderWidth = 1
    }

    private func setupBindings() {
        viewModel.fetchMovies()
        viewModel.onMoviesUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.reloadMovies()
            }
        }
    }

    @objc func searchMovies() {
        let query = searchTextField.text?.lowercased() ?? ""
        isSearching = !query.isEmpty
        reloadMovies()
    }

    func reloadMovies() {
        if showingFavorites {
            filteredMovies = viewModel.getFavoriteMovies()
        } else if isSearching {
            let query = searchTextField.text?.lowercased() ?? ""
            filteredMovies = viewModel.movies.filter { $0.title.lowercased().contains(query) }
        } else {
            filteredMovies = viewModel.movies
        }
        movieTableView.reloadData()
    }
}

// MARK: - UITableView Delegate & DataSource
extension MovieListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMovies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieListTableViewCell", for: indexPath) as! MovieListTableViewCell
        let movie = filteredMovies[indexPath.row]
        cell.configure(with: movie, viewModel: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(identifier: "MoviewDetailsViewCOntroller") as! MoviewDetailsViewCOntroller
        vc.movie_Image = filteredMovies[indexPath.row].backdropPath ?? ""
        vc.movie_Description = filteredMovies[indexPath.row].overview
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: - UITextFieldDelegate
extension MovieListViewController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        searchTextField.text = ""
        isSearching = false
        filteredMovies = viewModel.movies
        movieTableView.reloadData()
        return true
    }
}

