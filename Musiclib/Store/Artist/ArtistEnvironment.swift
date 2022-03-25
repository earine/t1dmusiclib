//
//  ArtistEnvironment.swift
//  musiclib
//
//  Created by mlunts on 21.03.2022.
//

import Foundation
import ComposableArchitecture

struct ArtistEnvironment {
    var artistAlbumsRequest: (_ artistId: Int) -> Effect<[Album], APIError>
}

extension ArtistEnvironment {
    static func makeArtistEnvironment() -> ArtistEnvironment {
        ArtistEnvironment(artistAlbumsRequest: { id in
            return .future { callback in
                DispatchQueue.global(qos: .background).async {
                    NetworkClient.shared.artistAlbums(id: id) { result in
                        switch result {
                        case .success(let response):
                            callback(.success(response.data))
                        case .failure(let error):
                            callback(.failure(error))
                        }
                    }
                }
            }
        })
    }
}
