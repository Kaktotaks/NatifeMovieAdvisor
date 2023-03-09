//
//  SearchMoviesViewController.swift
//  NatifeMovieAdvisor
//
//  Created by Леонід Шевченко on 13.01.2023.
//

import UIKit

final class SearchMoviesViewController: BaseViewController, UISearchResultsUpdating {
    // MARK: - Constants and Variables
    private let filteredMoviesTableView: UITableView = build {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.separatorStyle = .none
    }

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

        RestService.shared.getAllPopMovies(
            language: APIConstants.currentAppLanguageID,
            region: APIConstants.currentRegion,
            year: APIConstants.currentYear,
            query: query,
            page: 1
        ) { [weak self] result in
                guard let self = self else { return }

                switch result {
                    case .success(let movies):
                        DispatchQueue.main.async {
                            self.filteredMovies = movies
                            self.filteredMoviesTableView.reloadData()
                        }
                    case .failure(let error):
                        MyAlertManager.shared.showErrorAlert(
                            error.localizedDescription,
                            controller: self,
                            forTime: 2
                        )
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
        configurePopMovieCellForItem(models: filteredMovies, tableView: tableView, indexPath: indexPath)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.movieTableViewHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentMovieDetailVC(models: filteredMovies, indexPath: indexPath)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableViewCellApearingAnimation(tableView, willDisplay: cell, forRowAt: indexPath)
    }
}
