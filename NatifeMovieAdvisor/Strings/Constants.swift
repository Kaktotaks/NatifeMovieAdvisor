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
        static var noDataByThisParametrs = "noInformation".localized()
    }

    enum Fonts {
        static let smallRegularFont = UIFont.systemFont(ofSize: 16, weight: .regular)
        static let mediumSemiBoldFont = UIFont.systemFont(ofSize: 18, weight: .semibold)
        static let bigSemiBoldFont = UIFont.systemFont(ofSize: 27, weight: .black)
    }

    // MARK: - Another constants:
    static let redColor = UIColor(red: 198 / 255, green: 60 / 255, blue: 83 / 255, alpha: 1.0)
    static let noData = "No data".localized()
    static let popularMoviesTitle = "Popular Movies".localized()
    static let searchMoviesPlaceholder = "Search for Movies".localized()
    static let noImageURL = "https://us.123rf.com/450wm/koblizeek/koblizeek1902/koblizeek190200055/koblizeek190200055.jpg?ver=6"
    static let movieTableViewHeight = CGFloat(540)
    static let loaderTableViewHeight = CGFloat(60)
}
