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
        static let smallThinFont = UIFont.systemFont(ofSize: 12, weight: .thin)
        static let smallRegularFont = UIFont.systemFont(ofSize: 14, weight: .thin)
        static let mediumSemiBoldFont = UIFont.systemFont(ofSize: 16, weight: .semibold)
        static let bigSemiBoldFont = UIFont.systemFont(ofSize: 24, weight: .semibold)
    }

    //MARK: - Another constants:
    static let redColor = UIColor(red: 198 / 255, green: 60 / 255, blue: 83 / 255, alpha: 1.0)
    static let noData = "No data"

    static let noImageURL = "https://us.123rf.com/450wm/koblizeek/koblizeek1902/koblizeek190200055/koblizeek190200055.jpg?ver=6"
}
