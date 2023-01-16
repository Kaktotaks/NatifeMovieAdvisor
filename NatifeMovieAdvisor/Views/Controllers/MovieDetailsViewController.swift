//
//  MovieDetailsViewController.swift
//  NatifeMovieAdvisor
//
//  Created by Леонід Шевченко on 15.01.2023.
//

import UIKit
import Kingfisher
import YouTubeiOSPlayerHelper

class MovieDetailsViewController: UIViewController {
    private lazy var scrollView: UIScrollView = build {
        $0.backgroundColor = .clear
    }

    private lazy var contentStackView: UIStackView = build {
        $0.axis = .vertical
        $0.spacing = .zero
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = .init()
    }

    private lazy var posterImageView: UIImageView = build {
        $0.contentMode = .scaleAspectFill
    }

    private lazy var gradientView: GradientView = build {
        $0.verticalMode = true
        $0.startColor = .black
        $0.endColor = .clear
    }

    private lazy var titleLabel: UILabel = build {
        $0.numberOfLines = 0
        $0.font = Constants.Fonts.bigSemiBoldFont
        $0.textColor = .white
        $0.shadowColor = .lightGray
        $0.shadowOffset = CGSize(width: -1, height: 2)
    }

    private lazy var countryLabel: UILabel = build {
        $0.font = Constants.Fonts.mediumSemiBoldFont
        $0.textColor = .white
    }

    private lazy var releaseDateLabel: UILabel = build {
        $0.font = Constants.Fonts.mediumSemiBoldFont
        $0.textColor = .white
    }

    private lazy var genresLabel: UILabel = build {
        $0.font = Constants.Fonts.mediumSemiBoldFont
        $0.textColor = .white
        $0.numberOfLines = 0
    }

    private lazy var voteAverageLabel: UILabel = build {
        $0.font = Constants.Fonts.mediumSemiBoldFont
        $0.textColor = .white
    }

    private lazy var overviewLabel: UILabel = build {
        $0.font = Constants.Fonts.smallRegularFont
        $0.textAlignment = .center
        $0.textColor = .white
        $0.numberOfLines = 0
    }

    private lazy var videoPlayerView: YTPlayerView = build {
        $0.backgroundColor = .green
    }

    private var movieID: Int?
//    private var gotVideo: Bool?

    init(movieID: Int?) {
        self.movieID = movieID
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBarItems()
        getMovieDetail()
        requestVideos()
        configureSubviews()
        configureConstraints()
    }

    // MARK: - API requests
    private func getMovieDetail() {
        guard let movieID = movieID else { return }

        RestService.shared.getMoviewDetail(
            movieID: movieID, // Change to right from Delegate
            language: APIConstants.currentLanguage
        ) { [weak self] result in
            guard let self = self else { return }

            ActivityIndicatorView.shared.showIndicator(.movieLoading)

            switch result {
                case .success(let movie):
//                    self.movieModel = movie
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

    func requestVideos() {
        guard let movieID = movieID else { return }

        RestService.shared.getMovieVideos(
            movieID: movieID) { results in
                switch results {
                    case .success(let videos):
                        guard let videoId = videos.first?.key else { return }

//                        if !videoId.isEmpty {
                            self.videoPlayerView.load(withVideoId: videoId)
//                        } else {
//                            self.gotVideo = false
//                        }
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

        titleLabel.text = movieModel?.title
        countryLabel.text = "🌏: \(movieModel?.productionCountries?.first?.iso31661 ?? "")"
        releaseDateLabel.text = "🗓️: \(movieModel?.releaseDate ?? "")"
        genresLabel.text = "🎭: \(configureGenres(movieModel).minimalDescription)"
        voteAverageLabel.text = "⭐️: \(movieModel?.voteAverage ?? 0)"
        overviewLabel.text = movieModel?.overview
    }

    private func configureGenres(_ movieModel: MovieDetailsModel?) -> [String] {
        var apiGenreNames: [String] = []
        let genres = movieModel?.genres ?? [Genres]()

        for genre in genres {
            apiGenreNames.append(genre.name ?? "")
        }

        return apiGenreNames.map { $0.localized() }
    }

    @objc private func didTapBackButton() {
        self.dismiss(animated: true)
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
        view.backgroundColor = .black
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
            overviewLabel
        ].forEach { contentStackView.addArrangedSubview($0) }
        contentStackView.setCustomSpacing(4, after: posterImageView)
        contentStackView.setCustomSpacing(10, after: titleLabel)
        contentStackView.setCustomSpacing(10, after: countryLabel)
        contentStackView.setCustomSpacing(10, after: releaseDateLabel)
        contentStackView.setCustomSpacing(10, after: voteAverageLabel)
        contentStackView.setCustomSpacing(10, after: genresLabel)
        contentStackView.setCustomSpacing(10, after: overviewLabel)

//        if gotVideo == true {
            contentStackView.addArrangedSubview(videoPlayerView)
//        }
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
            $0.height.equalTo(270)
        }

        gradientView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        titleLabel.snp.remakeConstraints {
            $0.height.equalTo(titleLabel.snp.height)
            $0.leading.equalTo(6)
        }

        countryLabel.snp.remakeConstraints {
            $0.height.equalTo(countryLabel.snp.height)
            $0.leading.equalTo(4)
        }

        releaseDateLabel.snp.remakeConstraints {
            $0.height.equalTo(releaseDateLabel.snp.height)
            $0.leading.equalTo(4)
        }

        genresLabel.snp.remakeConstraints {
            $0.height.equalTo(genresLabel.snp.height)
            $0.leading.equalTo(4)
        }

        voteAverageLabel.snp.remakeConstraints {
            $0.height.equalTo(voteAverageLabel.snp.height)
            $0.leading.equalTo(4)
        }

        overviewLabel.snp.remakeConstraints {
            $0.height.equalTo(overviewLabel.snp.height)
        }

        videoPlayerView.snp.remakeConstraints {
            $0.height.equalTo(270)
        }

        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
}
