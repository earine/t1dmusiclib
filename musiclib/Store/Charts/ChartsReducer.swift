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
        return environment.chartsRequest(environment.decoder())
            .receive(on: environment.mainQueue())
            .catchToEffect()
            .map(ChartsAction.dataLoaded)
    case .dataLoaded(let result):
        switch result {
        case .success(let chart):
            state.artists = chart.artists
        case .failure:
            break
        }
        return .none
    }
}
