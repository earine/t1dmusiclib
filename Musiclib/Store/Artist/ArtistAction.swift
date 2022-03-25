//
//  ArtistAction.swift
//  musiclib
//
//  Created by mlunts on 21.03.2022.
//

import Foundation

enum ArtistAction: Equatable {
    case onAppear
    case albumsDataLoaded(Result<[Album], APIError>)
}
