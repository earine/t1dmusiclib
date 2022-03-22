//
//  Album.swift
//  musiclib
//
//  Created by mlunts on 19.03.2022.
//

import Foundation
struct Album: Codable, Equatable {
    let id: Int
    let title: String
    let coverMedium: String?
    var tracks: TracksResponse?

    enum CodingKeys: String, CodingKey {
        case id, title, coverMedium, tracks
    }

    static func == (lhs: Album, rhs: Album) -> Bool {
        return lhs.id == rhs.id
    }
}

struct AlbumResponse: Codable {
    var data: [Album]
}
