//
//  MovieListTableViewCell.swift
//  Movie
//
//  Created by Abhinav Saini on 20/02/25.
//

import UIKit

class MovieListTableViewCell: UITableViewCell {
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieReleaseYear: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!

    var movie: Movie?
    var viewModel: MovieViewModel?

    func configure(with movie: Movie, viewModel: MovieViewModel) {
        self.movie = movie
        self.viewModel = viewModel

        movieTitle.text = movie.title
        movieReleaseYear.text = movie.releaseDate
        movieImage.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w500/\(movie.posterPath ?? "")"))

        updateFavoriteButton()
    }

    private func updateFavoriteButton() {
        let isFavorite = viewModel?.isFavorite(movieId: movie?.id ?? 0) ?? false
        let imageName = isFavorite ? "heart.fill" : "heart"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
        
    }

    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        guard let movie = movie else { return }
        viewModel?.toggleFavorite(movie: movie)
        updateFavoriteButton()
    }
}
