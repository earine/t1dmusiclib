//
//  ChartsState.swift
//  musiclib
//
//  Created by mlunts on 21.03.2022.
//

import Foundation

struct ChartsState: Equatable {
    var isSearching: Bool = false
    var artists: [Artist]?
    var searchedArtistsResult: [Artist]?
}

