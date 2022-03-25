//
//  Track.swift
//  musiclib
//
//  Created by mlunts on 19.03.2022.
//

struct Track: Codable, Equatable {
    let id: Int
    let title: String
    let duration: Int
    let contributors: [Artist]?

    static func == (lhs: Track, rhs: Track) -> Bool {
        return lhs.id == rhs.id
    }
}

struct TracksResponse: Codable {
    var data: [Track]
}
