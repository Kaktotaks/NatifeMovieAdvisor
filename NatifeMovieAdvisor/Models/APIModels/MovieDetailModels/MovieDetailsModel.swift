import Foundation

struct MovieDetailsModel: Codable {
	let adult: Bool?
	let backdropPath: String?
	let belongsToCollection: BelongsToCollectionModel?
	let budget: Int?
	let genres: [GenresModel]?
    let homepage: String?
	let id: Int?
	let imdbId: String?
	let originalLanguage: String?
	let originalTitle: String?
	let overview: String?
	let popularity: Double?
	let posterPath: String?
	let productionCompanies: [ProductionCompaniesModel]?
	let productionCountries: [ProductionCountriesModel]?
	let releaseDate: String?
	let revenue: Int?
	let runtime: Int?
	let spokenLanguages: [SpokenLanguagesModel]?
	let status: String?
	let tagline: String?
	let title: String?
	let video: Bool?
	let voteAverage: Double?
	let voteCount: Int?

	enum CodingKeys: String, CodingKey {
		case adult = "adult"
		case backdropPath = "backdrop_path"
		case belongsToCollection = "belongs_to_collection"
		case budget = "budget"
		case genres = "genres"
		case homepage = "homepage"
		case id = "id"
		case imdbId = "imdb_id"
		case originalLanguage = "original_language"
		case originalTitle = "original_title"
		case overview = "overview"
		case popularity = "popularity"
		case posterPath = "poster_path"
		case productionCompanies = "production_companies"
		case productionCountries = "production_countries"
		case releaseDate = "release_date"
		case revenue = "revenue"
		case runtime = "runtime"
        case spokenLanguages = "spoken_languages"
		case status = "status"
		case tagline = "tagline"
		case title = "title"
		case video = "video"
		case voteAverage = "vote_average"
		case voteCount = "vote_count"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		adult = try values.decodeIfPresent(Bool.self, forKey: .adult)
		backdropPath = try values.decodeIfPresent(String.self, forKey: .backdropPath)
		belongsToCollection = try values.decodeIfPresent(BelongsToCollectionModel.self, forKey: .belongsToCollection)
		budget = try values.decodeIfPresent(Int.self, forKey: .budget)
		genres = try values.decodeIfPresent([GenresModel].self, forKey: .genres)
		homepage = try values.decodeIfPresent(String.self, forKey: .homepage)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		imdbId = try values.decodeIfPresent(String.self, forKey: .imdbId)
		originalLanguage = try values.decodeIfPresent(String.self, forKey: .originalLanguage)
		originalTitle = try values.decodeIfPresent(String.self, forKey: .originalTitle)
		overview = try values.decodeIfPresent(String.self, forKey: .overview)
		popularity = try values.decodeIfPresent(Double.self, forKey: .popularity)
		posterPath = try values.decodeIfPresent(String.self, forKey: .posterPath)
		productionCompanies = try values.decodeIfPresent([ProductionCompaniesModel].self, forKey: .productionCompanies)
		productionCountries = try values.decodeIfPresent([ProductionCountriesModel].self, forKey: .productionCountries)
		releaseDate = try values.decodeIfPresent(String.self, forKey: .releaseDate)
		revenue = try values.decodeIfPresent(Int.self, forKey: .revenue)
		runtime = try values.decodeIfPresent(Int.self, forKey: .runtime)
		spokenLanguages = try values.decodeIfPresent([SpokenLanguagesModel].self, forKey: .spokenLanguages)
		status = try values.decodeIfPresent(String.self, forKey: .status)
		tagline = try values.decodeIfPresent(String.self, forKey: .tagline)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		video = try values.decodeIfPresent(Bool.self, forKey: .video)
		voteAverage = try values.decodeIfPresent(Double.self, forKey: .voteAverage)
		voteCount = try values.decodeIfPresent(Int.self, forKey: .voteCount)
	}
}
