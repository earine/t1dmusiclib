//
//  ChartsReducer.swift
//  musiclib
//
//  Created by mlunts on 21.03.2022.
//

import Foundation
import ComposableArchitecture

let chartsReducer = Reducer<
    ChartsState,
    ChartsAction,
    SystemEnvironment<ChartsEnvironment>
> { state, action, environment in
    switch action {
    case .onAppear:
        return environment.chartsRequest()
            .receive(on: environment.mainQueue())
            .catchToEffect()
            .map(ChartsAction.chartDataLoaded)

    case .chartDataLoaded(let result):
        switch result {
        case .success(let chart):
            state.artists = chart.artists
        case .failure:
            break
        }
        return .none

    case .searchArtistByText(let searchQuery):
        state.isSearching = searchQuery != ""

        guard state.isSearching else {
            return .none
        }
        
        return environment.searchArtistRequest(searchQuery)
            .receive(on: environment.mainQueue())
            .catchToEffect()
            .map(ChartsAction.searchResultDataLoaded)

    case .searchResultDataLoaded(let result):
        switch result {
        case .success(let artists):
            state.searchedArtistsResult = artists
        case .failure:
            break
        }
        return .none
    }
}
