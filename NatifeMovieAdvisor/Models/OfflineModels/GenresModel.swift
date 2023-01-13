//
//  GenresModel.swift
//  NatifeMovieAdvisor
//
//  Created by Леонід Шевченко on 13.01.2023.
//

import Foundation

struct GenresModel {
    static var GenresList: [GenreModel] = [
        GenreModel(name: "Action", id: 28),
        GenreModel(name: "Adventure", id: 12),
        GenreModel(name: "Animation", id: 16),
        GenreModel(name: "Comedy", id: 35),
        GenreModel(name: "Crime", id: 80),
        GenreModel(name: "Documentary", id: 99),
        GenreModel(name: "Drama", id: 18),
        GenreModel(name: "Family", id: 10751),
        GenreModel(name: "Fantasy", id: 14),
        GenreModel(name: "History", id: 36),
        GenreModel(name: "Horror", id: 27),
        GenreModel(name: "Music", id: 10402),
        GenreModel(name: "Mystery", id: 9648),
        GenreModel(name: "Romance", id: 10749),
        GenreModel(name: "Science Fiction", id: 878),
        GenreModel(name: "TV Movie", id: 10770),
        GenreModel(name: "Thriller", id: 53),
        GenreModel(name: "War", id: 10752),
        GenreModel(name: "Western", id: 37)
    ]
}

struct GenreModel {
    let name: String?
    var id: Int?
}
