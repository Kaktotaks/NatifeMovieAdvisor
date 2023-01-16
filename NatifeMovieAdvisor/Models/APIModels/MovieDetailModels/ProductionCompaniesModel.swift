import Foundation

struct ProductionCompaniesModel: Codable {
	let id: Int?
	let logoPath: String?
	let name: String?
	let originCountry: String?

	enum CodingKeys: String, CodingKey {
		case id = "id"
		case logoPath = "logo_path"
		case name = "name"
		case originCountry = "origin_country"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		logoPath = try values.decodeIfPresent(String.self, forKey: .logoPath)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		originCountry = try values.decodeIfPresent(String.self, forKey: .originCountry)
	}
}
