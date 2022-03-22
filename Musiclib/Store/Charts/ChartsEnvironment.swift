//
//  ChartsEnvironment.swift
//  musiclib
//
//  Created by mlunts on 21.03.2022.
//

import ComposableArchitecture

struct ChartsEnvironment {
    var chartsRequest: () -> Effect<Chart, APIError>
    var searchArtistRequest: (String) -> Effect<[Artist], APIError>
}
