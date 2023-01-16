//
//  ViewController.swift
//  NatifeMovieAdvisor
//
//  Created by Леонід Шевченко on 10.01.2023.
//

import UIKit
import SnapKit

class MoviesListViewController: UIViewController {
    // MARK: - Constants & Variables
    private lazy var moviesTableView: UITableView = {
        let value: UITableView = .init()
        value.separatorStyle = .none
        return value
    }()

    private lazy var upButton: UIButton = {
        let value: UIButton = .init()
        value.setImage(UIImage(systemName: "chevron.up"), for: .normal)
        value.tintColor = .label
        value.contentMode = .scaleAspectFit
        value.clipsToBounds = true
        value.layer.cornerRadius = 20
        value.addTarget(self, action: #selector(upButtonPressed), for: .touchUpInside)
        value.backgroundColor = .systemGray3.withAlphaComponent(0.7)
        return value
    }()

    private var moviesModel: [PopMoviesResponseModel] = []

    // MARK: - Setup UISearchController
    private let searchController = UISearchController(searchResultsController: SearchMoviesViewController())
    private var isSearchBarEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
            return text.isEmpty
    }
    private var isFiltering: Bool {
        searchController.isActive && !isSearchBarEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setUpTableView()
        getAllPopMovies()
        setUpSearchController()
    }

    // MARK: - Methods
    private func getAllPopMovies(
        showActivityIndicator: Bool = true,
        language: String? = APIConstants.currentLanguage,
        region: String? = APIConstants.currentRegion,
        year: String? = APIConstants.currentYear,
        query: String? = nil,
        page: Int = APIConstants.currentPage
    ) {
        if showActivityIndicator {
            ActivityIndicatorView.shared.showIndicator(.movieLoading)
        }

        RestService.shared.getAllPopMovies(
            language: language,
            region: region,
            year: year,
            query: query,
            page: page
        ) { [weak self] result in
            guard let self = self else { return }

            switch result {
                case .success(let movies):
                    self.moviesModel.append(contentsOf: movies)
                    DispatchQueue.main.async {
                        ActivityIndicatorView.shared.hide()
                        self.moviesTableView.reloadData()
                    }
                case .failure(let error):
                    ActivityIndicatorView.shared.hide()
                    MyAlertManager.shared.showErrorAlert(error.localizedDescription, controller: self)
            }
        }
    }

    private func setUpTableView() {
        moviesTableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
    }

    @objc private func upButtonPressed() {
        let topRow = IndexPath(row: 0, section: 0)

        moviesTableView.scrollToRow(at: topRow,
                                   at: .top,
                                   animated: true
        )
    }

    // Setup UISearchController method
    private func setUpSearchController() {
        let searchMoviesVC = SearchMoviesViewController()
        let searchController = UISearchController(searchResultsController: searchMoviesVC)
        searchController.searchResultsUpdater = searchMoviesVC
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Constants.searchMoviesPlaceholder
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

// MARK: - Work with tableView DataSource/Delegate methods
extension MoviesListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.moviesModel.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: MovieTableViewCell.identifier
            ) as? MovieTableViewCell
        else {
            return UITableViewCell()
        }

        let movie = moviesModel[indexPath.row]
        cell.configure(MovieTableViewCellViewModel(with: movie))
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard !self.moviesModel.isEmpty else { return }

        let totalRezults = RestService.shared.totalRezults

        if indexPath.row == moviesModel.count - 1 && totalRezults > moviesModel.count {

            debugPrint("load new movies...")
            APIConstants.currentPage += 1
            debugPrint("Current page now is: \(APIConstants.currentPage)")
            self.moviesTableView.tableFooterView = LoaderFooterView.shared.createLoaderFooterView(
                viewController: self,
                tableView: moviesTableView
            )

            getAllPopMovies(
                showActivityIndicator: false,
                language: APIConstants.currentLanguage,
                region: APIConstants.currentRegion,
                year: APIConstants.currentYear,
                query: nil,
                page: APIConstants.currentPage
            )
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.movieTableViewHeight
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        upButtonAppearance(scrollView, upButton: upButton)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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

        let movieID = moviesModel[indexPath.row].id
        let movieDetailVC = MovieDetailsViewController(movieID: movieID)

        let navVC = UINavigationController(rootViewController: movieDetailVC)
        navVC.modalPresentationStyle = .fullScreen
        navVC.modalTransitionStyle = .flipHorizontal
        self.present(navVC, animated: true)
    }
}

// MARK: - Setup UI components
extension MoviesListViewController {
    private func setupUI() {
        title = Constants.popularMoviesTitle
        view.backgroundColor = .systemBackground
        view.addSubview(moviesTableView)
        view.addSubview(upButton)

        moviesTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        upButton.snp.makeConstraints {
            $0.width.height.equalTo(40)
            $0.bottom.equalToSuperview().inset(30)
            $0.trailing.equalToSuperview().inset(30)
        }
    }

    func upButtonAppearance(_ scrollView: UIScrollView, upButton: UIButton) {
        DispatchQueue.main.async {
            let startPoint = scrollView.contentOffset.y
            let scrollHeight = scrollView.frame.height

            if startPoint >= abs(scrollHeight * 3) {
                upButton.isHidden = false
            } else {
                upButton.isHidden = true
            }
        }
    }
}
