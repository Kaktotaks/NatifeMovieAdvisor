//
//  SequenceExtension.swift
//  NatifeMovieAdvisor
//
//  Created by Леонід Шевченко on 13.01.2023.
//

import Foundation

extension Sequence {
    var minimalDescription: String {
        map { "\($0)" }.joined(separator: ", ")
    }
}
