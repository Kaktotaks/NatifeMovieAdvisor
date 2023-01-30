//
//  BaseViewController.swift
//  NatifeMovieAdvisor
//
//  Created by Леонід Шевченко on 16.01.2023.
//

import UIKit

class BaseViewController: UIViewController {
    let networkMonitor = NetworkMonitor.shared

    // MARK: - DataSource/Delegate methods
    func presentMovieDetailVC(
        models: [PopMoviesResponseModel],
        indexPath: IndexPath
    ) {
        if networkMonitor.isConnected == false {
            let actions: [MyAlertManager.Action] = [
                .init(title: "ok", style: .default)
            ]

            let alert = MyAlertManager.shared.presentAlertWithOptions(
                title: Constants.AlertAnswers.somethingWentWrongAnswear,
                message: Constants.AlertAnswers.noConnection,
                actions: actions,
                dismissActionTitle: nil
            )
            self.present(alert, animated: true)
        } else {
            let movieID = models[indexPath.row].id
            let movieDetailVC = MovieDetailsViewController(movieID: movieID)

            let navVC = UINavigationController(rootViewController: movieDetailVC)
            navVC.modalPresentationStyle = .fullScreen
            navVC.modalTransitionStyle = .flipHorizontal
            self.present(navVC, animated: true)
        }
    }

    func configurePopMovieCellForItem(
        models: [PopMoviesResponseModel],
        tableView: UITableView,
        indexPath: IndexPath
    ) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: MovieTableViewCell.identifier
            ) as? MovieTableViewCell
        else {
            return UITableViewCell()
        }

        let movie = models[indexPath.row]
        cell.configure(MovieTableViewCellViewModel(with: movie))
        cell.selectionStyle = .none
        return cell
    }
}
