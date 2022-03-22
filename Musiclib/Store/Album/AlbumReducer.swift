//
//  AlbumReducer.swift
//  Musiclib
//
//  Created by mlunts on 22.03.2022.
//

import ComposableArchitecture

let albumReducer = Reducer<
    AlbumState,
    AlbumAction,
    SystemEnvironment<AlbumEnvironment>
> { state, action, environment in
    switch action {
    case .onAppear:
        state.isLoading = true
        return environment.albumRequest(state.album.id)
            .receive(on: environment.mainQueue())
            .catchToEffect()
            .map(AlbumAction.albumDataLoaded)

    case .albumDataLoaded(let result):
        state.isLoading = false
        switch result {
        case .success(let album):
            state.album = album
        case .failure:
            break
        }
        return .none
    }
}
