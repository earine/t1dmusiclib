//
//  ArtistReducer.swift
//  musiclib
//
//  Created by mlunts on 21.03.2022.
//

import ComposableArchitecture

let artistReducer = Reducer<
    ArtistState,
    ArtistAction,
    ArtistEnvironment
> { state, action, environment in
    switch action {
    case .onAppear:
        state.isLoading = true
        return environment.artistAlbumsRequest(state.artist.id)
            .receive(on: DispatchQueue.main)
            .catchToEffect()
            .map(ArtistAction.albumsDataLoaded)

    case .albumsDataLoaded(let result):
        state.isLoading = false
        switch result {
        case .success(let albums):
            state.artist.albums = albums
        case .failure:
            break
        }
        return .none
    }
}
