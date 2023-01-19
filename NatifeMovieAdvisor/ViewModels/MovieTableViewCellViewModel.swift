//
//  MovieTableViewCellViewModel.swift
//  NatifeMovieAdvisor
//
//  Created by Леонід Шевченко on 10.01.2023.
//

import Foundation

struct MovieTableViewCellViewModel {
    var movieTitle: String?
    var voteAverage: Double?
    var releaseDate: String?
    var genreIds: [Int]?
    var posterPath: String?

    init(with apiModel: PopMoviesResponseModel) {
        movieTitle = apiModel.title
        voteAverage = apiModel.voteAverage
        releaseDate = apiModel.releaseDate
        genreIds = apiModel.genreIds
        posterPath = apiModel.posterPath
    }
}
