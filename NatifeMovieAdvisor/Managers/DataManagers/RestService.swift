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

    static let pageLimit = 20

    enum EndPoints: String {
        case popMoviesEndPoint = "movie/popular?"
        case searchMoviesEndPoint = "search/movie?"
    }

    //    static let mainURL = "https://v1.basketball.api-sports.io/"

    //    static let leaguesEndPoint = "leagues?"
    //    static let teamsEndPoint = "teams?"
    //    static let standingsEndPoint = "standings?"
    //
    //    static var currentSeson: String? = "2022-2023"
    //    static var currentLeagueID = 12
    //    static var currentTeamID: Int?
    //
    //    static var currentLeagueName: String? = "NBA"
    //    static var currentTeamName: String?
}

class RestService {
    public var isPaginating = false
    public var totalRezults = 0

    static let shared: RestService = .init()

    private init() {}

    // MARK: CONTROL API RESPONSE
    private func getJsonResponse(
        _ path: String,
        endPoint: APIConstants.EndPoints,
        params: [String: Any] = [:],
        method: HTTPMethod = .get,
        encoding: ParameterEncoding = URLEncoding.default,
        completion: @escaping(AFDataResponse<Any>) -> Void
    ) {
        let url = "\(APIConstants.mainURL)\(endPoint.rawValue)api_key=\(APIConstants.apiKey)\(path)"
        debugPrint(url)

        if let encoded = url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) {

//            AF.session.configuration.timeoutIntervalForRequest = 3
            AF.request(
                encoded,
                method: method,
                parameters: params,
                encoding: encoding,
                headers: nil
            ).responseJSON { response in
                debugPrint("Successfull network request")
                completion(response)
            }
        }
    }

    // MARK: - Getting all popMovies Searching for movies
    func getAllPopMovies(
        pagination: Bool = false,
        language: String? = "en",
        region: String? = "us",
        year: String? = "2022",
        query: String? = nil,
        page: Int = 1,
        completionHandler: @escaping(Result<[PopMoviesResponse], Error>) -> Void
    ) {
        var endPoint = APIConstants.EndPoints.popMoviesEndPoint
        var path = "&page=\(page)"

        if let queryKey = query, !queryKey.isEmpty {
            endPoint = .searchMoviesEndPoint
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

        debugPrint(path)

        if pagination {
            isPaginating = true
        }

        getJsonResponse(path, endPoint: endPoint) { [weak self] response in
            guard let self = self else { return }

            switch response.result {
                case .success:
                    let decoder = JSONDecoder()
                    if let data = try? decoder.decode(PopMoviesEntryPoint.self, from: response.data ?? Data()) {
                        let movies = data.results ?? []
                        completionHandler(.success(movies))
                        debugPrint("Movies now count: \(movies.count) 👀")
                    }
                case .failure(let error):
                    completionHandler(.failure(error))
            }

            self.isPaginating = false
        }
    }
}
