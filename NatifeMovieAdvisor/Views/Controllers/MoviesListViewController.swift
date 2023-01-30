//
//  ViewController.swift
//  NatifeMovieAdvisor
//
//  Created by Леонід Шевченко on 10.01.2023.
//

import UIKit
import SnapKit

class MoviesListViewController: BaseViewController {
    // MARK: - Constants & Variables
    private lazy var moviesTableView: UITableView = build {
        $0.separatorStyle = .none
    }

    private lazy var upButton: UIButton = build {
        $0.setImage(UIImage(systemName: Constants.upButtonImage), for: .normal)
        $0.tintColor = .label
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
        $0.addTarget(self, action: #selector(upButtonPressed), for: .touchUpInside)
        $0.backgroundColor = .systemGray3.withAlphaComponent(0.7)
    }

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

    private var currentSortingParametr = SortByParametr.popularity

    // MARK: - UIView life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setUpTableView()
        getAllPopMovies()
        setUpSearchController()
        setUpRefreshControl()
        setupFilteredByButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        networkMonitor.startMonitoring()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        networkMonitor.stopMonitoring()
    }

    // MARK: - Methods
    private func getAllPopMovies(
        showActivityIndicator: Bool = true,
        language: String? = APIConstants.currentAppLanguageID,
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
                        switch self.currentSortingParametr {
                            case .voteAvarage:
                                self.setSortedModelToTableView(parametr: .voteAvarage)
                            case .popularity:
                                self.setSortedModelToTableView(parametr: .popularity)
                        }
                    }
                case .failure(let error):
                    ActivityIndicatorView.shared.hide()
                    MyAlertManager.shared.showErrorAlert(
                        error.localizedDescription,
                        controller: self,
                        forTime: 2
                    )
            }
        }
    }

    private func setUpRefreshControl() {
        moviesTableView.refreshControl = UIRefreshControl()
        moviesTableView.refreshControl?.addTarget(
            self,
            action: #selector(didPullRefresh),
            for: .valueChanged
        )
    }

    @objc private func didPullRefresh() {
        self.moviesTableView.refreshControl?.beginRefreshing()
        self.moviesModel.removeAll()
        APIConstants.currentPage = 1

        self.getAllPopMovies(
            showActivityIndicator: false,
            language: APIConstants.currentAppLanguageID,
            region: APIConstants.currentRegion,
            year: APIConstants.currentYear,
            query: nil,
            page: APIConstants.currentPage
        )

        self.moviesTableView.refreshControl?.endRefreshing()
    }

    private func setUpTableView() {
        moviesTableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
    }

    @objc private func upButtonPressed() {
        let topRow = IndexPath(row: 0, section: 0)

        moviesTableView.scrollToRow(
            at: topRow,
            at: .top,
            animated: true
        )
    }

    private func setUpSearchController() {
        let searchMoviesVC = SearchMoviesViewController()
        let searchController = UISearchController(searchResultsController: searchMoviesVC)
        searchController.searchResultsUpdater = searchMoviesVC
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Constants.searchMoviesPlaceholder
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    private func setupFilteredByButton() {
        let filterByMenu = UIMenu(
            title: Constants.MenuTexts.filterByTitle,
            children: [
                UIMenu(
                    title: Constants.MenuTexts.yearTitle,
                    image: UIImage(systemName: Constants.MenuTexts.calendarImage),
                    children: addYearAction()
                ),
                UIMenu(
                    title: Constants.MenuTexts.regionTitle,
                    image: UIImage(systemName: Constants.MenuTexts.flagImage),
                    children: addRegionAction()
                )
            ]
        )

        let sortByMenu = UIMenu(
            title: Constants.MenuTexts.sortByTitle,
            children: [
                UIAction(
                    title: Constants.MenuTexts.voteAvaraggeTitle,
                    image: UIImage(systemName: Constants.MenuTexts.starImage)
                ) { _ in
                    self.setSortedModelToTableView(parametr: .voteAvarage)
                },
                UIAction(
                    title: Constants.MenuTexts.popularityTitle,
                    image: UIImage(systemName: Constants.MenuTexts.personsImage)
                ) { _ in
                    self.setSortedModelToTableView(parametr: .popularity)
                }
            ]
        )

        let menu = UIMenu(
            title: Constants.MenuTexts.filterSortTitle,
            children: [sortByMenu, filterByMenu]
        )

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: nil,
            image: UIImage(systemName: Constants.MenuTexts.sliderImage),
            primaryAction: nil,
            menu: menu
        )
    }
}

// MARK: - Work with tableView DataSource/Delegate methods
extension MoviesListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.moviesModel.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        configurePopMovieCellForItem(models: moviesModel, tableView: tableView, indexPath: indexPath)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard !self.moviesModel.isEmpty else { return }

        let totalRezults = RestService.shared.totalRezults

        if indexPath.row == moviesModel.count - 1 && totalRezults > moviesModel.count {
            APIConstants.currentPage += 1
            self.moviesTableView.tableFooterView = LoaderFooterView.shared.createLoaderFooterView(
                viewController: self,
                tableView: moviesTableView
            )

            getAllPopMovies(
                showActivityIndicator: false,
                language: APIConstants.currentAppLanguageID,
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
        presentMovieDetailVC(models: moviesModel, indexPath: indexPath)
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

// MARK: - Setup sorting parametrs:
// swiftlint: disable all
extension MoviesListViewController {
    enum SortByParametr {
        case voteAvarage, popularity
    }

    func setSortedModelToTableView(parametr: SortByParametr) {
        if parametr == .popularity {
            let sortedModel = self.moviesModel.sortArray(by: \.popularity!)
            self.moviesModel.removeAll()
            self.moviesModel.append(contentsOf: sortedModel)
            self.currentSortingParametr = .popularity
            self.moviesTableView.reloadData()
        } else if parametr == .voteAvarage {
            let sortedModel = self.moviesModel.sortArray(by: \.voteAverage!)
            self.moviesModel.removeAll()
            self.moviesModel.append(contentsOf: sortedModel)
            self.currentSortingParametr = .voteAvarage
            self.moviesTableView.reloadData()
        }
    }

    // MARK: - Methods for adding UIMenu actions
    func addYearAction() -> [UIAction] {
        var result = [UIAction]()
        
        for year in 2010...2022 {
            let action = UIAction(title: "\(year)") { _ in
                APIConstants.currentYear = "\(year)"
                APIConstants.currentPage = 1
                self.moviesModel.removeAll()
                self.getAllPopMovies(
                    year: "\(APIConstants.currentYear ?? "2022")",
                    page: APIConstants.currentPage
                )
            }
            result.append(action)
        }
        return result.reversed()
    }

    func addRegionAction() -> [UIAction] {
        let regions = ["us", "gb", "fr", "es", "no"]
        var result = [UIAction]()

        for region in regions {
            let action = UIAction(title: "\(region)") { _ in
                APIConstants.currentRegion = region
                APIConstants.currentPage = 1
                self.moviesModel.removeAll()
                self.getAllPopMovies(
                    region: region,
                    page: APIConstants.currentPage
                )
            }
            result.append(action)
        }
        return result
    }
}
