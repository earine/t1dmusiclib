//
//  AlbumEnvironment.swift
//  Musiclib
//
//  Created by mlunts on 22.03.2022.
//

import ComposableArchitecture

struct AlbumEnvironment {
    var albumRequest: (_ albumId: Int) -> Effect<Album, APIError>
    var trackRequest: (_ trackId: Int) -> Effect<Track, APIError>
}

extension AlbumEnvironment {
    static func makeAlbumEnvironment() -> AlbumEnvironment {
        AlbumEnvironment(
            albumRequest: { id in
                return .future { callback in
                    DispatchQueue.global(qos: .background).async {
                        NetworkClient.shared.album(id: id) { result in
                            switch result {
                            case .success(let album):
                                callback(.success(album))
                            case .failure(let error):
                                callback(.failure(error))
                            }
                        }
                    }
                }
            },
            trackRequest: { id in
                return .future { callback in
                    DispatchQueue.global(qos: .background).async {
                        NetworkClient.shared.trackInfo(id: id) { result in
                            switch result {
                            case .success(let track):
                                callback(.success(track))
                            case .failure(let error):
                                callback(.failure(error))
                            }
                        }
                    }
                }
            })
    }
}
