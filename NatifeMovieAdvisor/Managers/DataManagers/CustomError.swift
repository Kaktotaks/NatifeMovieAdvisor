//
//  CustomError.swift
//  NatifeMovieAdvisor
//
//  Created by Леонід Шевченко on 23.01.2023.
//

import Foundation

enum CustomError {
    case noConnection, noData
}

extension CustomError: LocalizedError {
    public var errorDescription: String? {
        switch self {
            case .noData:
                return Constants.AlertAnswers.noDataByThisParametrs
            case .noConnection:
                return Constants.AlertAnswers.noConnectionShort
        }
    }
}
