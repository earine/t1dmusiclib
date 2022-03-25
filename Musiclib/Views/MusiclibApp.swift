//
//  musiclibApp.swift
//  musiclib
//
//  Created by mlunts on 19.03.2022.
//

import SwiftUI
import ComposableArchitecture

@main
struct MusiclibApp: App {
    var body: some Scene {
        WindowGroup {
            ChartArtistListView(store: Store(
                initialState: ChartsState(),
                reducer: chartsReducer,
                environment: ChartsEnvironment.makeChartsEnvironment()
            ))
        }
    }
}
