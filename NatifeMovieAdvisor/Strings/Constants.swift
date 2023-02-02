//
//  Constants.swift
//  NatifeMovieAdvisor
//
//  Created by Леонід Шевченко on 11.01.2023.
//

import UIKit

enum Constants {
    enum AlertAnswers {
        static var somethingWentWrongAnswear = "somethingWentWrong".localized()
        static var noDataByThisParametrs = "noDataByThisParametrs".localized()
        static var noConnection = "noConnection".localized()
        static var noConnectionShort = "noConnectionShort".localized()
    }

    enum Fonts {
        static let smallRegularFont = UIFont.systemFont(ofSize: 16, weight: .regular)
        static let mediumSemiBoldFont = UIFont.systemFont(ofSize: 18, weight: .semibold)
        static let bigSemiBoldFont = UIFont.systemFont(ofSize: 27, weight: .black)
    }

    enum MenuTexts {
        static let filterByTitle = "filterByTitle".localized()
        static let sortByTitle = "sortByTitle".localized()
        static let yearTitle = "yearTitle".localized()
        static let regionTitle = "regionTitle".localized()
        static let voteAvaraggeTitle = "voteAvaraggeTitle".localized()
        static let popularityTitle = "popularityTitle".localized()

        static let calendarImage = "calendar"
        static let flagImage = "flag"
        static let starImage = "star.leadinghalf.fill"
        static let personsImage = "person.2"
        static let sliderImage = "slider.horizontal.3"
    }

    // MARK: - Another constants:
    static let noData = "noData".localized()
    static let popularMoviesTitle = "popularMovies".localized()
    static let searchMoviesPlaceholder = "searchForMovies".localized()
    static let noImageURL = "https://us.123rf.com/450wm/koblizeek/koblizeek1902/koblizeek190200055/koblizeek190200055.jpg?ver=6"
    static let upButtonImage = "chevron.up"
    static let movieTableViewHeight = CGFloat(540)
    static let loaderTableViewHeight = CGFloat(60)
}
