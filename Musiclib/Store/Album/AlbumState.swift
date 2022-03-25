//
//  AlbumState.swift
//  Musiclib
//
//  Created by mlunts on 22.03.2022.
//

struct AlbumState: Equatable {
    var album: Album

    var tracks: [Track] {
        if let tracks = album.tracks?.data {
            return tracks
        } else { return [] }
    }
    
    var isLoading: Bool = false
}
