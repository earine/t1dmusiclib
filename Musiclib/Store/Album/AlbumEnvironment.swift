//
//  AlbumEnvironment.swift
//  Musiclib
//
//  Created by mlunts on 22.03.2022.
//

import ComposableArchitecture

struct AlbumEnvironment {
    var albumRequest: (_ albumId: Int) -> Effect<Album, APIError>
}
