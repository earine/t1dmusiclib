//
//  AlbumState.swift
//  Musiclib
//
//  Created by mlunts on 22.03.2022.
//

enum AlbumAction {
    case onAppear
    case albumDataLoaded(Result<Album, APIError>)
    case fetchAlbumData
    case trackDataLoaded(Result<Track, APIError>)
    case updateTrack(Track)
}
