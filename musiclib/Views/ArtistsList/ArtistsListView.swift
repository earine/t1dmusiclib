//
//  ArtistsListView.swift
//  musiclib
//
//  Created by mlunts on 19.03.2022.
//

import SwiftUI
import ComposableArchitecture

struct ArtistsListView: View {
    let store: Store<ChartsState, ChartsAction>

    @State private var searchQueryString = ""

    private enum Constants {
        static let cellHeight: CGFloat = 40
        static let artistImageWidth: CGFloat = 60
    }

    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                List {
                    if let artists = viewStore.state.artists {
                        ForEach(artists, id: \.id) { artist in
                            NavigationLink(destination: ArtistView(store: Store(
                                initialState: ArtistState(artist: artist),
                                reducer: artistReducer,
                                environment: .live(
                                    environment: ArtistEnvironment(
                                        artistAlbumsRequest: NetworkClient.shared.artistAlbumsEffect)
                                )
                            ))) {
                                artistCell(artist)
                            }
                        }
                    }
                }
                .navigationTitle("Artists")
                .listStyle(.plain)

                .onAppear() {
                    viewStore.send(.onAppear)
                }
            }
            .searchable(text: $searchQueryString)
            .onChange(of: searchQueryString) { searchText in
            }
        }
    }
}

extension ArtistsListView {
    private func artistCell(_ artist: Artist) -> some View {
        HStack {
            AsyncImage(url: URL(string: artist.pictureMedium)) { image in
                image
                    .coverImageModifier(height: Constants.cellHeight,
                                        width: Constants.artistImageWidth)
            } placeholder: {
                Image(systemName: "camera.metering.unknown")
            }
            .frame(width: Constants.artistImageWidth, height: Constants.cellHeight)

            Text(artist.name)
        }
        .frame(height: Constants.cellHeight)
    }
}

//struct ArtistsListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ArtistsListView()
//    }
//}
