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

    private var moviesModel: [PopMoviesResponse] = []

    enum TableSection: Int {
        case articlesList
        case loader
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setUpTableView()
        getAllPopMovies()
    }

    private func getAllPopMovies() {
        ActivityIndicatorView.shared.showIndicator(.movieLoading)

        RestService.shared.getAllPopMovies { [weak self] result in
            guard let self = self else { return }
            
            switch result {
                    
                case .success(let movies):
                    self.moviesModel.removeAll()
                    self.moviesModel.append(contentsOf: movies)
                    DispatchQueue.main.async {
                        ActivityIndicatorView.shared.hide()
                        self.moviesTableView.reloadData()
                    }
                case .failure(let error):
                    self.showErrorAlert(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Methods
    private func setUpTableView() {
        moviesTableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
//        moviesTableView.delegate = self
//        moviesTableView.dataSource = self
    }
    
    // MARK: - Alert that shows different types of error (Bad network connection included)
    func showErrorAlert(_ message: String) {
        let errorAlert = MyAlertManager.shared.presentTemporaryInfoAlert(
            title: Constants.AlertAnswers.somethingWentWrongAnswear,
            message: message,
            preferredStyle: .actionSheet,
            forTime: 8.0)
        DispatchQueue.main.async {
            ActivityIndicatorView.shared.hide()
            self.present(errorAlert, animated: true)
        }
    }

}


// MARK: - Work with tableView DataSource/Delegate methods
//extension MoviesListViewController: UITableViewDelegate, UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        2
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard let listSection = TableSection(rawValue: section) else { return 0 }
//
//        switch listSection {
//        case .articlesList:
//            return self.moviesModel.count
//        case .loader:
//            return self.moviesModel.count >= APIConstants.pageLimit ? 1 : 0
//        }
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard
//            let section = TableSection(rawValue: indexPath.section)
//        else {
//            return UITableViewCell()
//        }
//
//        var totalRezults = RestService.shared.totalRezults
//
//        switch section {
//        case .articlesList:
//            guard
//                let cell = tableView.dequeueReusableCell(
//                    withIdentifier: MovieTableViewCell.identifier
//                ) as? MovieTableViewCell
//            else {
//                return UITableViewCell()
//            }
//
////            cell.configure(with: ArticlesCustomTableViewCellViewModel(with: articlesModel[indexPath.row]))
////            cell.delegate = self
//            cell.tag = indexPath.row
//            cell.selectionStyle = .none
//            return cell
//        case .loader:
//            guard
//                let cell = tableView.dequeueReusableCell(withIdentifier: "loaderCell") else {
//                return UITableViewCell()
//            }
//
//            cell.selectionStyle = .none
//
//            if totalRezults > moviesModel.count {
//                return cell
//            }
//        }
//
//        return UITableViewCell()
//    }
//
//
//}

// MARK: - Setup UI components
extension MoviesListViewController {
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(moviesTableView)
//        view.addSubview(upButton)

        moviesTableView.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide)
        }

//        upButton.snp.makeConstraints {
//            $0.width.height.equalTo(40)
//            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(10)
//            $0.centerX.equalToSuperview()
//        }
    }
}
