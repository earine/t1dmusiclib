//
//  ArtistEnvironment.swift
//  musiclib
//
//  Created by mlunts on 21.03.2022.
//

import Foundation
import ComposableArchitecture

struct ArtistEnvironment {
    var artistAlbumsRequest: (_ artistId: Int,
                              _ decoder: JSONDecoder) -> Effect<[Album], APIError>
}
