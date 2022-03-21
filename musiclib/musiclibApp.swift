//
//  musiclibApp.swift
//  musiclib
//
//  Created by mlunts on 19.03.2022.
//

import SwiftUI
import ComposableArchitecture

@main
struct musiclibApp: App {
    var body: some Scene {
        WindowGroup {
            ArtistsListView(store: Store(
                                        initialState: ChartsState(),
                                        reducer: chartsReducer,
                                        environment: .live(environment: ChartsEnvironment(chartsRequest: NetworkClient.shared.chartArtistsEffect))))
        }
    }
}
