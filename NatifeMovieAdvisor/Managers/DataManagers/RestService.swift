//
//  RestService.swift
//  NatifeMovieAdvisor
//
//  Created by Леонід Шевченко on 10.01.2023.
//

import Foundation
import Alamofire

enum APIConstants {
    static let mainURL = "https://api.themoviedb.org/3/"
    static let apiKey = "242869b42a65c82d7bfdc955a766ce9f"
    static let imageBaseURL = "https://image.tmdb.org/t/p/w500"
    static let videosPath = "/videos"

    enum EndPoints {
        static let popMoviesEndPoint = "movie/popular"
        static let searchMoviesEndPoint = "search/movie"
        static let getMovieDetailEndPoint = "movie/"
    }

    static let pageLimit = 20

    static var currentAppLanguageID: String? = NSLocale.current.languageCode
    static var currentRegion: String? = "us"
    static var currentYear: String? = "2022"
    static var currentPage = 1
}

class RestService {
    private let networkMonitor = NetworkMonitor.shared
    public var totalRezults = 0

    static let shared: RestService = .init()

    private init() {}

    // MARK: CONTROL API RESPONSE
    private func getJsonResponse(
        _ path: String,
        endPoint: String,
        params: [String: Any] = [:],
        method: HTTPMethod = .get,
        encoding: ParameterEncoding = URLEncoding.default,
        completion: @escaping(AFDataResponse<Any>) -> Void
    ) {
        let url = "\(APIConstants.mainURL)\(endPoint)?api_key=\(APIConstants.apiKey)\(path)"
        debugPrint(url)

        if let encoded = url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) {

            AF.request(
                encoded,
                method: method,
                parameters: params,
                encoding: encoding,
                headers: nil
            ).responseJSON { response in
                completion(response)
            }
        }
    }

    // MARK: - Getting all popMovies Searching for movies
    func getAllPopMovies(
        language: String?,
        region: String?,
        year: String?,
        query: String?,
        page: Int,
        completionHandler: @escaping(Result<[PopMoviesResponseModel], Error>) -> Void
    ) {
        var endPoint = APIConstants.EndPoints.popMoviesEndPoint
        var path = "&page=\(page)"

        if let queryKey = query, !queryKey.isEmpty {
            endPoint = APIConstants.EndPoints.searchMoviesEndPoint
            path = "\(path)&query=\(queryKey)"
        }

        if let languageKey = language {
            path = "\(path)&language=\(languageKey)"
        }

        if let regionKey = region {
            path = "\(path)&region=\(regionKey)"
        }

        if let yearKey = year {
            path = "\(path)&year=\(yearKey)"
        }

        if networkMonitor.isConnected == false {
            completionHandler(.failure(CustomError.noConnection))
        }

        getJsonResponse(path, endPoint: endPoint) { [weak self] response in
            guard let self = self else { return }

            switch response.result {
                case .success:
                    let decoder = JSONDecoder()
                    if let data = try? decoder.decode(PopMoviesEntryPointModel.self, from: response.data ?? Data()) {
                        let movies = data.results ?? []
                        completionHandler(.success(movies))
                        self.totalRezults = data.totalResults ?? 0
                    } else {
                        completionHandler(.failure(CustomError.noData))
                    }
                case .failure(let error):
                    completionHandler(.failure(error))
            }
        }
    }

    // MARK: - Getting detail information from API
    func getMoviewDetail(
        movieID: Int,
        language: String?,
        completionHandler: @escaping(Result<MovieDetailsModel, Error>) -> Void
    ) {
        let endPoint = APIConstants.EndPoints.getMovieDetailEndPoint + movieID.description
        var path = ""

        if let languageKey = language {
            path = "\(path)&language=\(languageKey)"
        }

        getJsonResponse(path, endPoint: endPoint) { response in
            switch response.result {
                case .success:
                    let decoder = JSONDecoder()
                    if let data = try? decoder.decode(MovieDetailsModel.self, from: response.data ?? Data()) {
                        let movie = data
                        completionHandler(.success(movie))
                    } else {
                        completionHandler(.failure(CustomError.noData))
                    }
                case .failure(let error):
                    completionHandler(.failure(error))
            }
        }
    }

    // MARK: - Getting YouTube video from API
    func getMovieVideos(
        movieID: Int,
        completionHandler: @escaping(Result<[MovieVideoModel], Error>) -> Void
    ) {
        let fullVideoPath = APIConstants.EndPoints.getMovieDetailEndPoint + movieID.description + APIConstants.videosPath

        getJsonResponse("", endPoint: fullVideoPath) { response in
            switch response.result {
                case .success:
                    let decoder = JSONDecoder()
                    if let data = try? decoder.decode(MovieVideoEntryPointModel.self, from: response.data ?? Data()) {
                            let videos = data.results ?? []
                        completionHandler(.success(videos))
                    } else {
                        completionHandler(.failure(CustomError.noData))
                    }
                case .failure(let error):
                    completionHandler(.failure(error))
            }
        }
    }
}
