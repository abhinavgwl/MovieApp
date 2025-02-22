//
//  CoreDataManger.swift
//  Movie
//
//  Created by Abhinav Saini on 20/02/25.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    private let persistentContainer: NSPersistentContainer

    private init() {
        persistentContainer = NSPersistentContainer(name: "Movie") // Ensure this matches your Core Data model name
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                print("Failed to load Core Data stack: \(error.localizedDescription)")
            }
        }
    }

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error.localizedDescription)")
        }
    }

    // MARK: - Add Favorite Movie
    func addFavorite(movie: Movie) {
        if isFavorite(movieId: movie.id) {
            print("Movie already exists in favorites")
            return
        }

        let favorite = FavoriteMovie(context: context)
        favorite.id = Int64(movie.id)
        favorite.title = movie.title
        favorite.overview = movie.overview
        favorite.releaseDate = movie.releaseDate
        favorite.posterPath = movie.posterPath
        favorite.backdropPath = movie.backdropPath
        favorite.voteAverage = movie.voteAverage
        favorite.voteCount = Int64(movie.voteCount)

        saveContext()
    }

    // MARK: - Remove Favorite Movie
    func removeFavorite(movieId: Int) {
        let fetchRequest: NSFetchRequest<FavoriteMovie> = FavoriteMovie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", movieId)

        do {
            let movies = try context.fetch(fetchRequest)
            for movie in movies {
                context.delete(movie)
            }
            saveContext()
        } catch {
            print("Failed to delete movie: \(error.localizedDescription)")
        }
    }

    // MARK: - Fetch All Favorites
    func fetchFavorites() -> [Movie] {
        let fetchRequest: NSFetchRequest<FavoriteMovie> = FavoriteMovie.fetchRequest()
        do {
            let favoriteMovies = try context.fetch(fetchRequest)
            return favoriteMovies.map { movie in
                return Movie(
                    id: Int(movie.id),
                    title: movie.title ?? "",
                    overview: movie.overview ?? "",
                    releaseDate: movie.releaseDate ?? "",
                    posterPath: movie.posterPath,
                    backdropPath: movie.backdropPath,
                    voteAverage: movie.voteAverage,
                    voteCount: Int(movie.voteCount)
                )
            }
        } catch {
            print("Failed to fetch favorite movies: \(error.localizedDescription)")
            return []
        }
    }

    // MARK: - Check if Movie is Favorite
    func isFavorite(movieId: Int) -> Bool {
        let fetchRequest: NSFetchRequest<FavoriteMovie> = FavoriteMovie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", movieId)

        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Failed to check favorite status: \(error.localizedDescription)")
            return false
        }
    }
}
