//
//  ArrayExtension.swift
//  NatifeMovieAdvisor
//
//  Created by Леонід Шевченко on 18.01.2023.
//

import Foundation

extension Array {
    func sortArray<T: Comparable>(by compare: (Element) -> T, asc ascendant: Bool = false) -> Array {
        return self.sorted {
            if ascendant {
                return compare($0) < compare($1)
            }

            return compare($0) > compare($1)
        }
    }
}
