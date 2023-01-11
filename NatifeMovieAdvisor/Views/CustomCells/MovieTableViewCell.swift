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
        value.layer.cornerRadius = 20
        return value
    }()

    private lazy var gradientView: GradientView = {
        let value: GradientView = .init()
        value.verticalMode = true
        value.startColor = Constants.redColor.withAlphaComponent(0.7)
        value.endColor = .clear
        value.clipsToBounds = true
//        value.translatesAutoresizingMaskIntoConstraints = false
        return value
    }()

    private lazy var movieTitleLabel: UILabel = {
        let value: UILabel = .init()
        value.font = Constants.Fonts.bigSemiBoldFont
        value.contentMode = .center
        value.text = Constants.noData
        return value
    }()

    private lazy var voteAverageLabel: UILabel = {
        let value: UILabel = .init()
        value.font = Constants.Fonts.smallRegularFont
        value.contentMode = .center
        value.text = Constants.noData
        return value
    }()

    private lazy var releaseDateLabel: UILabel = {
        let value: UILabel = .init()
        value.font = Constants.Fonts.smallRegularFont
        value.contentMode = .center
        value.text = Constants.noData
        return value
    }()

    private lazy var genresLabel: UILabel = {
        let value: UILabel = .init()
        value.font = Constants.Fonts.smallThinFont
        value.contentMode = .center
        value.text = Constants.noData
        return value
    }()

    // MARK: - Methods
       override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
           super.init(style: style, reuseIdentifier: reuseIdentifier)
   
           setUpUI()
       }
   
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
    func configure(with popMovieModel: PopMoviesResponse) {
        if let posterURL = popMovieModel.posterPath {
            let moviePosterImageURL = URL(string: APIConstants.imageBaseURL + posterURL)
            posterImageView.kf.indicatorType = .activity
            posterImageView.kf.setImage(with: moviePosterImageURL)
        }

        movieTitleLabel.text = popMovieModel.title
        voteAverageLabel.text = popMovieModel.voteAverage?.description
        releaseDateLabel.text = popMovieModel.releaseDate
        genresLabel.text = popMovieModel.genreIds?.description
    }
}

// MARK: - UI setup.
extension MovieTableViewCell {
    private func setUpUI() {
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4))
        contentView.addSubview(posterImageView)
        posterImageView.addSubview(gradientView)
        gradientView.addSubview(movieTitleLabel)
        gradientView.addSubview(voteAverageLabel)
        gradientView.addSubview(releaseDateLabel)
        gradientView.addSubview(genresLabel)
    
        posterImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

//extension GameTableViewCell {
//    private func setUpUI() {
//        contentView.addSubview(myBackgroundView)
//        myBackgroundView.addSubview(statusLabel)
//        myBackgroundView.addSubview(homeTotalScoreLabel)
//        myBackgroundView.addSubview(guestTotalScoreLabel)
//        myBackgroundView.addSubview(addToFavouritesButton)
//        myBackgroundView.addSubview(homeTeamImageView)
//        myBackgroundView.addSubview(guestTeamImageView)
//        myBackgroundView.addSubview(dateLabel)
//        myBackgroundView.addSubview(leagueImageView)
//        myBackgroundView.addSubview(homeTeamNameLable)
//        myBackgroundView.addSubview(guestTeamNameLable)
//        myBackgroundView.addSubview(countryCodeLabel)
//
//        myBackgroundView.snp.makeConstraints {
//            $0.edges.equalToSuperview().inset(6)
//        }
//
//        countryCodeLabel.snp.makeConstraints {
//            $0.height.width.equalTo(40)
//            $0.bottom.equalToSuperview().inset(4)
//            $0.leading.equalToSuperview().inset(8)
//        }
//
//        addToFavouritesButton.snp.makeConstraints {
//            $0.width.height.equalTo(40)
//            $0.bottom.trailing.equalToSuperview().inset(4)
//        }
//
//        leagueImageView.snp.makeConstraints {
//            $0.height.width.equalTo(40)
//            $0.centerX.equalToSuperview()
//            $0.centerY.equalTo(homeTotalScoreLabel.snp.centerY)
//        }
//
//        homeTeamImageView.snp.makeConstraints {
//            $0.height.width.equalToSuperview().dividedBy(2.2)
//            $0.top.leading.equalToSuperview().inset(12)
//        }
//
//        guestTeamImageView.snp.makeConstraints {
//            $0.height.width.equalToSuperview().dividedBy(2.2)
//            $0.top.trailing.equalToSuperview().inset(12)
//        }
//
//        homeTeamNameLable.snp.makeConstraints {
//            $0.top.equalTo(homeTeamImageView.snp.bottom).offset(12)
//            $0.width.equalTo(homeTeamImageView)
//            $0.height.equalTo(52)
//            $0.centerX.equalTo(homeTeamImageView)
//        }
//
//        guestTeamNameLable.snp.makeConstraints {
//            $0.top.equalTo(guestTeamImageView.snp.bottom).offset(12)
//            $0.width.equalTo(guestTeamImageView)
//            $0.height.equalTo(52)
//            $0.centerX.equalTo(guestTeamImageView)
//        }
//
//        homeTotalScoreLabel.snp.makeConstraints {
//            $0.top.equalTo(homeTeamNameLable.snp.bottom)
//            $0.centerX.equalTo(homeTeamImageView)
//            $0.bottom.equalTo(dateLabel.snp.top)
//            $0.width.equalTo(homeTeamImageView)
//
//        }
//
//        guestTotalScoreLabel.snp.makeConstraints {
//            $0.top.equalTo(guestTeamNameLable.snp.bottom)
//            $0.centerX.equalTo(guestTeamImageView)
//            $0.bottom.equalTo(dateLabel.snp.top)
//            $0.width.equalTo(guestTeamImageView)
//        }
//
//        statusLabel.snp.makeConstraints {
//            $0.bottom.equalToSuperview()
//            $0.centerX.equalToSuperview()
//            $0.leading.trailing.equalToSuperview()
//            $0.height.equalTo(20)
//        }
//
//        dateLabel.snp.makeConstraints {
//            $0.bottom.equalTo(statusLabel.snp.top)
//            $0.centerX.leading.trailing.equalToSuperview()
//            $0.height.equalTo(20)
//        }
//    }
//}


//protocol GameTableViewCellDelegate: AnyObject {
//    func saveToPickedButtonTapped(tappedForItem item: Int)
//}
