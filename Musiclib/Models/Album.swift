//
//  Album.swift
//  musiclib
//
//  Created by mlunts on 19.03.2022.
//

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

    mutating func updateTrackInfo(trackInfo: Track) {
        if let _ = tracks?.data,
           let trackIndex = tracks?.data.firstIndex(where: { $0.id == trackInfo.id }) {
            tracks?.data.removeAll(where: { $0.id == trackInfo.id })
            tracks?.data.insert(trackInfo, at: trackIndex)
        }
    }
}

struct AlbumResponse: Codable {
    var data: [Album]
}
