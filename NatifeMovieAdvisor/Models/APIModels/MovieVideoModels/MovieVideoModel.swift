import Foundation

struct MovieVideoModel: Codable {
	let iso6391: String?
	let iso31661: String?
	let name: String?
	let key: String?
	let site: String?
	let size: Int?
	let type: String?
	let official: Bool?
	let publishedAt: String?
	let id: String?

	enum CodingKeys: String, CodingKey {
		case iso6391 = "iso_639_1"
		case iso31661 = "iso_3166_1"
		case name = "name"
		case key = "key"
		case site = "site"
		case size = "size"
		case type = "type"
		case official = "official"
		case publishedAt = "published_at"
		case id = "id"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		iso6391 = try values.decodeIfPresent(String.self, forKey: .iso6391)
        iso31661 = try values.decodeIfPresent(String.self, forKey: .iso31661)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		key = try values.decodeIfPresent(String.self, forKey: .key)
		site = try values.decodeIfPresent(String.self, forKey: .site)
		size = try values.decodeIfPresent(Int.self, forKey: .size)
		type = try values.decodeIfPresent(String.self, forKey: .type)
		official = try values.decodeIfPresent(Bool.self, forKey: .official)
        publishedAt = try values.decodeIfPresent(String.self, forKey: .publishedAt)
		id = try values.decodeIfPresent(String.self, forKey: .id)
	}
}
