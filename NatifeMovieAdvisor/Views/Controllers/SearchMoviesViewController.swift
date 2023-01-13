//
//  SearchMoviesViewController.swift
//  NatifeMovieAdvisor
//
//  Created by Леонід Шевченко on 13.01.2023.
//

import UIKit

class SearchMoviesViewController: UIViewController, UISearchResultsUpdating {
    // MARK: - Constants and Variables
    private let filteredMoviesTableView: UITableView = {
        let value = UITableView()
        value.translatesAutoresizingMaskIntoConstraints = false
        value.separatorStyle = .none
        return value
    }()

    private var filteredMovies: [PopMoviesResponseModel] = []

    // MARK: - UI life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpSearchTableView()
    }

    // MARK: - Methods
    private func setUpSearchTableView() {
        filteredMoviesTableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        view.addSubview(filteredMoviesTableView)
        filteredMoviesTableView.delegate = self
        filteredMoviesTableView.dataSource = self
        filteredMoviesTableView.frame = view.bounds
    }

    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text else { return }

        debugPrint(query)

        RestService.shared.getAllPopMovies(
            language: APIConstants.currentLanguage,
            region: APIConstants.currentRegion,
            year: APIConstants.currentYear,
            query: query,
            page: 1) { [weak self] result in
                guard let self = self else { return }

                switch result {
                    case .success(let movies):
                        DispatchQueue.main.async {
                            self.filteredMovies = movies
                            self.filteredMoviesTableView.reloadData()
                        }
                    case .failure(let error):
                        MyAlertManager.shared.showErrorAlert(error.localizedDescription, controller: self)
                }
        }
    }
}

// MARK: - Work with tableView DataSource/Delegate methods
extension SearchMoviesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.filteredMovies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: MovieTableViewCell.identifier
            ) as? MovieTableViewCell
        else {
            return UITableViewCell()
        }

        cell.configure(MovieTableViewCellViewModel(with: filteredMovies[indexPath.row]))
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.movieTableViewHeight
    }

    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        if
    //            let stringURL = filteredArticles[indexPath.row].url,
    //            let artilleURL = URL(string: stringURL) {
    //
    //            let articleTitle = filteredArticles[indexPath.row].title
    //            let webVC = WebViewViewController(url: artilleURL, title: articleTitle)
    //            let navVC = UINavigationController(rootViewController: webVC)
    //            self.present(navVC, animated: true)
    //        } else {
    //            print("No url was found")
    //            let noURLalert = MyAlertManager.shared.presentTemporaryInfoAlert(
    //                title: Constants.TemporaryAlertAnswers.NoURLArticle,
    //                message: nil, preferredStyle: .actionSheet,
    //                forTime: 1.0
    //            )
    //
    //            self.present(noURLalert, animated: true)
    //            return
    //        }
    //    }
}
