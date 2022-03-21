//
//  Track.swift
//  musiclib
//
//  Created by mlunts on 19.03.2022.
//

struct Track: Codable {
    let id: String
    let title: String
    let duration: String
    let contributors: [String]
}
