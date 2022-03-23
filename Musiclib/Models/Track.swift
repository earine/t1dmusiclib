//
//  Track.swift
//  musiclib
//
//  Created by mlunts on 19.03.2022.
//

struct Track: Codable {
    let id: Int
    let title: String
    let duration: Int
    let contributors: [Artist]?
}

struct TracksResponse: Codable {
    var data: [Track]
}
