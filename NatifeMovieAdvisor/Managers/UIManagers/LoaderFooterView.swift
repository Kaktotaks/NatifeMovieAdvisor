//
//  LoaderFooterView.swift
//  NatifeMovieAdvisor
//
//  Created by Леонід Шевченко on 12.01.2023.
//

import UIKit

final class LoaderFooterView {
    static let shared = LoaderFooterView()
    private init() {}

    func createLoaderFooterView(
        viewController: UIViewController,
        tableView: UITableView
    ) -> UIView {
        let footerView = UIView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: viewController.view.frame.size.width,
                height: 50
            )
        )

        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.center = footerView.center
        footerView.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()

        return footerView
    }
}
