//
//  ArtistView.swift
//  musiclib
//
//  Created by mlunts on 19.03.2022.
//

import SwiftUI
import ComposableArchitecture

struct ArtistView: View {
    let store: Store<ArtistState, ArtistAction>

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        WithViewStore(self.store) { viewStore in
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(viewStore.state.artist.albums ?? [], id: \.id) { album in
                        albumCell(album)
                    }
                }
            }
            .navigationTitle(viewStore.state.artist.name)
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}

extension ArtistView {
    private func albumCell(_ album: Album) -> some View {
        VStack(alignment: .leading) {
            if let coverMedium = album.coverMedium {
                AsyncImage(url: URL(string: coverMedium)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .clipped()
                } placeholder: {
                    Image(systemName: "camera.metering.unknown")
                }
            } else {
                Image(systemName: "camera.metering.unknown")
            }

            Spacer()

            Text(album.title)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .font(.body)
        }
        .padding()
    }
}

struct ArtistView_Previews: PreviewProvider {
    static var previews: some View {
        ArtistView(store: Store(initialState: ArtistState(artist: Artist(id: 0,
                                                                         name: "Sade",
                                                                         pictureMedium: "",
                                                                         albums: [
                                                                            Album(id: 1, title: "Lovers Rock", coverMedium: "") ])),
                                reducer: artistReducer,
                                environment: .live(
                                    environment: ArtistEnvironment(
                                        artistAlbumsRequest: NetworkClient.shared.artistAlbumsEffect)
                                )))
    }
}
