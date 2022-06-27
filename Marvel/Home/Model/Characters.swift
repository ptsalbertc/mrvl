
import Foundation

struct Characters: Codable {
	let list: [Character]
	
	enum CodingKeys: String, CodingKey {
		case list = "results"
	}
}

struct Image: Codable {
	let path: String
	let ext: String
	
	var url: String {
		get {
			return path + "." + ext
		}
	}
	
	enum CodingKeys: String, CodingKey {
		case path
		case ext = "extension"
	}
}

struct Character: Codable {
	let id: Int
	let name: String
	let description: String
	let imageUrl: Image
	let characterUrl: String
	
	enum CodingKeys: String, CodingKey {
		case id
		case name
		case description
		case imageUrl = "thumbnail"
		case characterUrl = "resourceURI"
	}
}
