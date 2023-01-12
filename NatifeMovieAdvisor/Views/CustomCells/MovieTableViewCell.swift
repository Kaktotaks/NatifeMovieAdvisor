//
//  MovieTableViewCell.swift
//  NatifeMovieAdvisor
//
//  Created by Леонід Шевченко on 10.01.2023.
//

import UIKit
import SnapKit
import Kingfisher

class MovieTableViewCell: UITableViewCell {
    // MARK: - Const/Variables
    static let identifier = "MovieTableViewCell"

    private lazy var posterImageView: UIImageView = {
        let value: UIImageView = .init()
        value.contentMode = .scaleAspectFill
        value.image = UIImage(named: "natifeLogo")
        value.clipsToBounds = true
        value.layer.cornerRadius = 24
        return value
    }()

    private lazy var gradientView: GradientView = {
        let value: GradientView = .init()
        value.verticalMode = true
        value.startColor = .black
        value.endColor = .clear
        value.clipsToBounds = true
//        value.translatesAutoresizingMaskIntoConstraints = false
        return value
    }()

    private lazy var movieTitleLabel: UILabel = {
        let value: UILabel = .init()
        value.font = Constants.Fonts.bigSemiBoldFont
        value.textAlignment = .center
        value.numberOfLines = 0
        value.text = Constants.noData
        value.textColor = .white
        value.shadowColor = .lightGray
        value.shadowOffset = CGSize(width: -1, height: 2)
        return value
    }()

    private lazy var voteAverageLabel: UILabel = {
        let value: UILabel = .init()
        value.font = Constants.Fonts.mediumSemiBoldFont
        value.textAlignment = .center
        value.text = Constants.noData
        value.textColor = .white
        return value
    }()

    private lazy var releaseDateLabel: UILabel = {
        let value: UILabel = .init()
        value.font = Constants.Fonts.mediumSemiBoldFont
        value.textAlignment = .center
        value.text = Constants.noData
        value.textColor = .white
        return value
    }()

    private lazy var genresLabel: UILabel = {
        let value: UILabel = .init()
        value.font = Constants.Fonts.smallRegularFont
        value.textAlignment = .center
        value.text = Constants.noData
        value.textColor = .white
        return value
    }()

    // MARK: - Methods
    override func layoutSubviews() {
        super.layoutSubviews()

        setUpUI()
    }

    func configure(with popMovieModel: PopMoviesResponse) {
        if let posterURL = popMovieModel.posterPath {
            let moviePosterImageURL = URL(string: APIConstants.imageBaseURL + posterURL)
            posterImageView.kf.indicatorType = .activity
            posterImageView.kf.setImage(with: moviePosterImageURL)
        }

        movieTitleLabel.text = popMovieModel.title
        voteAverageLabel.text = "⭐️ \(popMovieModel.voteAverage ?? 0)"
        releaseDateLabel.text = "🗓️ \(popMovieModel.releaseDate ?? Constants.noData)"
        genresLabel.text = "🎭 \(popMovieModel.genreIds ?? [Int]())"
    }
}

// MARK: - UI setup.
extension MovieTableViewCell {
    private func setUpUI() {
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16))
        contentView.addSubview(posterImageView)
        posterImageView.addSubview(gradientView)
        gradientView.addSubview(releaseDateLabel)
        gradientView.addSubview(voteAverageLabel)
        gradientView.addSubview(genresLabel)
        gradientView.addSubview(movieTitleLabel)

        posterImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        gradientView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        movieTitleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.centerY.equalToSuperview().offset(60)
            $0.height.equalTo(90)
        }

        voteAverageLabel.snp.makeConstraints {
            $0.top.equalTo(movieTitleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(20)
        }

        releaseDateLabel.snp.makeConstraints {
            $0.top.equalTo(voteAverageLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(20)
        }

        genresLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(releaseDateLabel.snp.bottom).offset(16)
            $0.height.equalTo(20)
        }
    }
}
