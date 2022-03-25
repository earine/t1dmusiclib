//
//  Artist.swift
//  musiclib
//
//  Created by mlunts on 19.03.2022.
//

struct Artist: Codable, Equatable {
    let id: Int
    let name: String
    let pictureMedium: String
    var albums: [Album]? 

    enum CodingKeys: String, CodingKey {
        case id, name, pictureMedium
    }

    static func == (lhs: Artist, rhs: Artist) -> Bool {
        return lhs.id == rhs.id
    }
}

struct ArtistsResponse: Codable {
    let data: [Artist]
}
