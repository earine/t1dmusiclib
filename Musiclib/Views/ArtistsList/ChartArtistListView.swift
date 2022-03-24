//
//  ChartArtistListView.swift
//  musiclib
//
//  Created by mlunts on 19.03.2022.
//

import SwiftUI
import ComposableArchitecture

struct ChartArtistListView: View {
    let store: Store<ChartsState, ChartsAction>

    @State private var searchQueryString = ""

    private enum Constants {
        static let cellHeight: CGFloat = 40
        static let artistImageWidth: CGFloat = 60
        static let trackCoverPlaceholderImageName: String = "camera.metering.unknown"
    }

    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                ScrollViewReader { proxy in
                    List {
                        if let artists = viewStore.state.isSearching
                            ? viewStore.state.searchedArtistsResult
                            : viewStore.state.artists {
                            ForEach(artists, id: \.id) { artist in
                                NavigationLink(destination: ArtistView(store: Store(
                                    initialState: ArtistState(artist: artist),
                                    reducer: artistReducer,
                                    environment: ArtistEnvironment(
                                        artistAlbumsRequest: NetworkClient.shared.artistAlbumsEffect
                                    )
                                ))) {
                                    artistCell(artist)
                                }
                            }
                        }

                        if viewStore.state.isSearching
                            && viewStore.state.searchedArtisResultIsFull == false {
                            HStack {
                                Spacer()
                                ProgressView()
                                    .onAppear {
                                        viewStore.send(.searchArtistByText(searchQueryString))
                                    }
                                Spacer()
                            }
                        }
                    }
                    .navigationTitle("Artists")
                    .listStyle(.plain)
                    .onAppear() {
                        viewStore.send(.onAppear)
                    }
                    .onChange(of: searchQueryString) { searchText in
                        proxy.scrollTo(0)
                        viewStore.send(.searchArtistByText(searchText))
                    }
                }

            }
            .searchable(text: $searchQueryString)
        }
    }
}

extension ChartArtistListView {
    private func artistCell(_ artist: Artist) -> some View {
        HStack {
            AsyncImage(url: URL(string: artist.pictureMedium)) { image in
                image.coverImageModifier(height: Constants.cellHeight,
                                         width: Constants.artistImageWidth)
            } placeholder: {
                Image(systemName: Constants.trackCoverPlaceholderImageName)
            }
            .frame(width: Constants.artistImageWidth, height: Constants.cellHeight)

            Text(artist.name)
        }
        .frame(height: Constants.cellHeight)
    }
}

struct ArtistsListView_Previews: PreviewProvider {
    static var previews: some View {
        ChartArtistListView(store: Store(
            initialState: ChartsState(isSearching: false,
                                      artists: [
                                        Artist(id: 1, name: "Sade", pictureMedium: ""),
                                        Artist(id: 2, name: "Fiona Apple", pictureMedium: ""),
                                        Artist(id: 3, name: "Beach House", pictureMedium: "")
                                      ],
                                      searchedArtistsResult: nil),
            reducer: chartsReducer,
            environment: ChartsEnvironment(
                chartsRequest: NetworkClient.shared.chartArtistsEffect,
                searchArtistRequest: NetworkClient.shared.searchArtistEffect
            )

        ))
    }
}
