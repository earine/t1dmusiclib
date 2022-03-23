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

        let fal = environment.albumRequest(state.album.id)
            .receive(on: environment.mainQueue())
            .catchToEffect()
            .map(AlbumAction.albumDataLoaded)
        return environment.albumRequest(state.album.id)
            .receive(on: environment.mainQueue())
            .catchToEffect()
            .map(AlbumAction.albumDataLoaded)

    case .albumDataLoaded(let result):
        switch result {
        case .success(let album):
            state.album = album

            var trackEffects: [Effect<AlbumAction, Never>] = []
            state.album.tracks?.data.forEach({
                trackEffects.append(environment.trackRequest($0.id)
                    .receive(on: environment.mainQueue())
                    .catchToEffect()
                    .map(AlbumAction.trackDataLoaded))
            })

            return .concatenate(trackEffects)
        case .failure:
            state.isLoading = false
            break
        }
        return .none

    case .trackDataLoaded(let result):
        switch result {
        case .success(let trackInfo):
            state.album.updateTrackInfo(trackInfo: trackInfo)

            if state.album.tracks?.data.last?.id ?? 0 == trackInfo.id {
                state.isLoading = false
            }
        case .failure:
            state.isLoading = false
            break
        }
        return .none
    }
}
