//
//  MovieViewModel.swift
//  Movie
//
//  Created by Abhinav Saini on 20/02/25.
//

import Foundation

class MovieViewModel {
    private let movieService = MovieService()
    private let coreDataManager = CoreDataManager.shared
    var movies: [Movie] = []
    var onMoviesUpdated: (() -> Void)?

    func fetchMovies() {
        movieService.fetchMovies { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let movies):
                    self?.movies = movies
                    self?.onMoviesUpdated?()
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }

    func toggleFavorite(movie: Movie) {
        if coreDataManager.isFavorite(movieId: movie.id) {
            coreDataManager.removeFavorite(movieId: movie.id)
        } else {
            coreDataManager.addFavorite(movie: movie)
        }
        onMoviesUpdated?()
    }

    func getFavoriteMovies() -> [Movie] {
        return coreDataManager.fetchFavorites()
    }

    func isFavorite(movieId: Int) -> Bool {
        return coreDataManager.isFavorite(movieId: movieId)
    }
}
