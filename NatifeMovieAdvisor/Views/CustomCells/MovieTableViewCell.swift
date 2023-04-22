//
//  MovieTableViewCell.swift
//  NatifeMovieAdvisor
//
//  Created by Леонід Шевченко on 10.01.2023.
//

import UIKit
import SnapKit
import Kingfisher

final class MovieTableViewCell: UITableViewCell {
    // MARK: - Const/Variables
    static let identifier = "MovieTableViewCell"

    private lazy var posterImageView: UIImageView = build {
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: "natifeLogo")
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 24
    }

    private lazy var gradientView: GradientView = build {
        $0.verticalMode = true
        $0.startColor = .black
        $0.startLocation = 0.25
        $0.endColor = .clear
        $0.clipsToBounds = true
    }

    private lazy var contentStackView: UIStackView = build {
        $0.axis = .vertical
        $0.spacing = .zero
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = .init()
        $0.distribution = .fill
    }

    private lazy var movieTitleLabel: UILabel = build {
        $0.font = Constants.Fonts.bigSemiBoldFont
        $0.textAlignment = .center
        $0.numberOfLines = 2
        $0.text = Constants.noData
        $0.textColor = .white
        $0.shadowColor = .lightGray
        $0.shadowOffset = CGSize(width: -1, height: 2)
    }

    private lazy var voteAverageLabel: UILabel = build {
        $0.font = Constants.Fonts.mediumSemiBoldFont
        $0.textAlignment = .center
        $0.text = Constants.noData
        $0.textColor = .white
    }

    private lazy var releaseDateLabel: UILabel = build {
        $0.font = Constants.Fonts.mediumSemiBoldFont
        $0.textAlignment = .center
        $0.text = Constants.noData
        $0.textColor = .white
    }

    private lazy var genresLabel: UILabel = build {
        $0.font = Constants.Fonts.mediumSemiBoldFont
        $0.textAlignment = .center
        $0.text = Constants.noData
        $0.textColor = .white
        $0.numberOfLines = 0
    }

    // MARK: - Methods
    override func layoutSubviews() {
        super.layoutSubviews()

        setupSubviews()
        setupConstraints()
    }

    // MARK: - Func configure with viewModel (API model)
    func configure(_ viewModel: MovieTableViewCellViewModel) {
        if let posterURL = viewModel.posterPath {
            let moviePosterImageURL = URL(string: APIConstants.imageBaseURL + posterURL)
            posterImageView.kf.indicatorType = .activity
            posterImageView.kf.setImage(with: moviePosterImageURL)
        }

        movieTitleLabel.text = viewModel.movieTitle
        voteAverageLabel.text = "⭐️ \(viewModel.voteAverage ?? 0)"
        releaseDateLabel.text = "🗓️ \(viewModel.releaseDate ?? Constants.noData)"
        genresLabel.text = "🎭 \(configureGenres(viewModel).minimalDescription)"
    }

    private func configureGenres(_ viewModel: MovieTableViewCellViewModel) -> [String] {
        var apiGenreNames: [String] = []
        let genresList = OfflineGenresModel.GenresList

        for list in genresList {
            for response in viewModel.genreIds ?? [Int]() {
                if response == list.id {
                    apiGenreNames.append(list.name ?? "")
                }
            }
        }

        return apiGenreNames.map { $0.localized() }
    }
}

// MARK: - UI setup.
extension MovieTableViewCell {
    private func setupSubviews() {
        contentView.makeShadow()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16))
        contentView.addSubview(posterImageView)
        posterImageView.addSubview(gradientView)
        gradientView.addSubview(contentStackView)

        [
            movieTitleLabel,
            genresLabel,
            voteAverageLabel,
            releaseDateLabel
        ].forEach { contentStackView.addArrangedSubview($0) }
        contentStackView.setCustomSpacing(16, after: voteAverageLabel)
        contentStackView.setCustomSpacing(16, after: genresLabel)
        contentStackView.setCustomSpacing(16, after: movieTitleLabel)
    }

    private func setupConstraints() {
        posterImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        gradientView.snp.makeConstraints {
            $0.width.bottom.equalToSuperview()
            $0.height.equalTo(posterImageView.snp.height).dividedBy(2.5)
        }

        contentStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview().inset(12)
            $0.width.equalToSuperview()
        }
    }
}
