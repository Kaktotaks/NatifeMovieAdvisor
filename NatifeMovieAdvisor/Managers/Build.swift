//
//  Build.swift
//  NatifeMovieAdvisor
//
//  Created by Леонід Шевченко on 15.01.2023.
//

import UIKit

//typealias VoidClosure = () -> Void

public func build<T: NSObject>(builder: (T) -> Void) -> T {
    build(.init(), builder: builder)
}

public func build<T>(_ object: T, builder: (T) -> Void) -> T {
    builder(object)
    return object
}
