//
//  UIMenuManager.swift
//  NatifeMovieAdvisor
//
//  Created by Леонід Шевченко on 01.02.2023.
//

import UIKit

final class UIMenuManager {
    static let shared: UIMenuManager = .init()

    private init() { }

    public var regionTitle: String?
    public var yearTitle: String?
    public var sortTitle: String?

    func checkIfValueNotNil(value: String? = nil, menu: UIMenu) {
        if let value = value {
            menu.children.forEach { action in
                guard let action = action as? UIAction else {
                    return
                }

                if action.title == value {
                    action.state = .on
                }
            }
        } else {
            let valueAction = menu.children.first as? UIAction
            valueAction?.state = .on
        }
    }
}
