//
//  ArtistAction.swift
//  musiclib
//
//  Created by mlunts on 21.03.2022.
//

import Foundation

enum ArtistAction {
    case onAppear
    case dataLoaded(Result<[Album], APIError>)
}
