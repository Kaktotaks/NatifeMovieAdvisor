import Foundation

struct SpokenLanguagesModel: Codable {
	let iso6391: String?
	let name: String?

	enum CodingKeys: String, CodingKey {
		case iso6391 = "iso_639_1"
		case name = "name"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		iso6391 = try values.decodeIfPresent(String.self, forKey: .iso6391)
		name = try values.decodeIfPresent(String.self, forKey: .name)
	}
}
