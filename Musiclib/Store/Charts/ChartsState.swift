//
//  ChartsState.swift
//  musiclib
//
//  Created by mlunts on 21.03.2022.
//

import Foundation

struct ChartsState: Equatable {
    var isSearching: Bool = false
    var searchQuery: String = ""

    var artists: [Artist]?
    var searchedArtistsResult: [Artist]?

    var searchedArtisResultIsFull: Bool {
        return currentPage == maximumPage
    }

    // MARK: pagination support
    var currentPage = 0
    let perPage = 25
    let maximumPage = 300
}

