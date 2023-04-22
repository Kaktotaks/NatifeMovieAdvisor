//
//  MovieDetailsViewController.swift
//  NatifeMovieAdvisor
//
//  Created by Леонід Шевченко on 15.01.2023.
//

import UIKit
import Kingfisher
import YouTubeiOSPlayerHelper

final class MovieDetailsViewController: UIViewController, UIGestureRecognizerDelegate {
    // MARK: - Constants and Variables
    private lazy var scrollView: UIScrollView = build {
        $0.backgroundColor = .clear
    }

    private lazy var contentStackView: UIStackView = build {
        $0.axis = .vertical
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = .init()
        $0.distribution = .fill
    }

    private lazy var posterImageView: UIImageView = build {
        $0.contentMode = .scaleAspectFill
//        $0.clipsToBounds = true
    }

    private lazy var gradientView: GradientView = build {
        $0.verticalMode = true
        $0.startColor = .systemBackground
        $0.endColor = .clear
    }

    private lazy var titleLabel: UILabel = build {
        $0.numberOfLines = 0
        $0.font = Constants.Fonts.bigSemiBoldFont
        $0.shadowColor = .lightGray
        $0.shadowOffset = CGSize(width: -1, height: 2)
        $0.textAlignment = .center
    }

    private lazy var countryLabel: UILabel = build {
        $0.font = Constants.Fonts.mediumSemiBoldFont
    }

    private lazy var releaseDateLabel: UILabel = build {
        $0.font = Constants.Fonts.mediumSemiBoldFont
    }

    private lazy var genresLabel: UILabel = build {
        $0.font = Constants.Fonts.mediumSemiBoldFont
        $0.numberOfLines = 0
    }

    private lazy var voteAverageLabel: UILabel = build {
        $0.font = Constants.Fonts.mediumSemiBoldFont
    }

    private lazy var overviewLabel: UILabel = build {
        $0.font = Constants.Fonts.smallRegularFont
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }

    private lazy var videoPlayerView: YTPlayerView = build {
        $0.backgroundColor = .clear
    }

    private var movieID: Int?

    init(movieID: Int?) {
        self.movieID = movieID
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Aneble gesture to swipe back ViewControllers
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self

        configureNavigationBarItems()
        getMovieDetail()
        requestVideos()
        configureSubviews()
        configureConstraints()
        addGesture()
    }

    // MARK: - Methods
    private func getMovieDetail() {
        guard let movieID = movieID else { return }

        RestService.shared.getMoviewDetail(
            movieID: movieID, // Change to right from Delegate
            language: APIConstants.currentAppLanguageID
        ) { [weak self] result in
            guard let self = self else { return }

            ActivityIndicatorView.shared.showIndicator(.movieLoading)

            switch result {
                case .success(let movie):
                    self.configureContent(movieModel: movie)
                    DispatchQueue.main.async {
                        ActivityIndicatorView.shared.hide()
                    }
                case .failure(let error):
                    ActivityIndicatorView.shared.hide()
                    MyAlertManager.shared.showErrorAlert(error.localizedDescription, controller: self)
            }
        }
    }

    private func requestVideos() {
        guard let movieID = movieID else { return }

        RestService.shared.getMovieVideos(
            movieID: movieID) { results in
                switch results {
                    case .success(let videos):
                        guard let videoId = videos.first?.key else { return }

                        self.videoPlayerView.load(withVideoId: videoId)
                    case .failure(let error):
                        MyAlertManager.shared.showErrorAlert(error.localizedDescription, controller: self)
                }
        }
    }

    private func configureContent(movieModel: MovieDetailsModel?) {
        if let posterURL = movieModel?.backdropPath {
            let moviePosterImageURL = URL(string: APIConstants.imageBaseURL + posterURL)
            posterImageView.kf.indicatorType = .activity
            posterImageView.kf.setImage(with: moviePosterImageURL)
        }

        if let avarage = movieModel?.voteAverage {
            let roundedAvarage = Double(round(10 * avarage) / 10)
            voteAverageLabel.text = " ⭐️: \(roundedAvarage)"
        }

        titleLabel.text = movieModel?.title
        countryLabel.text = " 🌏: \(movieModel?.productionCountries?.first?.name ?? "")"
        releaseDateLabel.text = " 🗓️: \(movieModel?.releaseDate ?? "")"
        genresLabel.text = " 🎭: \(configureGenres(movieModel).minimalDescription)"
        overviewLabel.text = movieModel?.overview
    }

    private func configureGenres(_ movieModel: MovieDetailsModel?) -> [String] {
        var apiGenreNames: [String] = []
        let genres = movieModel?.genres ?? [GenresModel]()

        for genre in genres {
            apiGenreNames.append(genre.name ?? "")
        }

        return apiGenreNames.map { $0.localized() }
    }

    @objc private func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }

    private func addGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(gestureFired(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1

        posterImageView.addGestureRecognizer(tapGesture)
        posterImageView.isUserInteractionEnabled = true
    }

    @objc private func gestureFired(_ gesture: UITapGestureRecognizer) {
        let imageVC = ImageViewController(movieImage: posterImageView)
        let navVC = UINavigationController(rootViewController: imageVC)
        self.present(navVC, animated: true)
    }
}

// MARK: - Configure UI
extension MovieDetailsViewController {
    private func configureNavigationBarItems() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            style: .plain,
            target: self,
            action: #selector(didTapBackButton)
        )
    }

    private func configureSubviews() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        posterImageView.addSubview(gradientView)

        [
            posterImageView,
            titleLabel,
            countryLabel,
            releaseDateLabel,
            voteAverageLabel,
            genresLabel,
            overviewLabel,
            videoPlayerView
        ].forEach { contentStackView.addArrangedSubview($0) }
        contentStackView.setCustomSpacing(4, after: posterImageView)
        contentStackView.setCustomSpacing(10, after: titleLabel)
        contentStackView.setCustomSpacing(10, after: countryLabel)
        contentStackView.setCustomSpacing(10, after: releaseDateLabel)
        contentStackView.setCustomSpacing(10, after: voteAverageLabel)
        contentStackView.setCustomSpacing(14, after: genresLabel)
        contentStackView.setCustomSpacing(14, after: overviewLabel)
    }

    private func configureConstraints() {
        scrollView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.width.bottom.equalToSuperview()
        }

        contentStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }

        posterImageView.snp.makeConstraints {
            $0.height.equalTo(240)
        }

        gradientView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        videoPlayerView.snp.remakeConstraints {
            $0.height.equalTo(270)
        }

        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
}
