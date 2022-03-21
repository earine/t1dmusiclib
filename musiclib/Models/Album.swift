//
//  Album.swift
//  musiclib
//
//  Created by mlunts on 19.03.2022.
//

import Foundation
struct Album: Codable {
    let id: Int
    let title: String
    let coverMedium: String?
//    let tracklist: [Track]

    enum CodingKeys: String, CodingKey {
        case id, title, coverMedium
    }
}

struct AlbumResponse: Codable {
    var data: [Album]
}
