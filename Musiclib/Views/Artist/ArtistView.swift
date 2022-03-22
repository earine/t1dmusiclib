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

    private let columns = [
        GridItem(.flexible(), alignment: .top),
        GridItem(.flexible(), alignment: .top)
    ]

    private enum Constants {
        static let albumCoverMultiplier: CGFloat = 0.45
        static let lineLimit: Int = 2
        static let spacing: CGFloat = 5
    }

    private var albumCoverFrame: CGFloat {
        return UIScreen.main.bounds.width * Constants.albumCoverMultiplier
    }

    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack {
                if viewStore.state.isLoading {
                    ProgressView()
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns) {
                            ForEach(viewStore.state.artist.albums ?? [], id: \.id) { album in

                                NavigationLink(destination: AlbumView(store: Store(
                                    initialState: AlbumState(album: album),
                                    reducer: albumReducer,
                                    environment: .live(
                                        environment: AlbumEnvironment(
                                            albumRequest: NetworkClient.shared.albumEffect
                                        )
                                    )
                                ))) {
                                    albumCell(artistName: viewStore.state.artist.name,
                                              album)

                                }
                            }
                        }
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
    private func albumCell(artistName: String, _ album: Album) -> some View {
        VStack(alignment: .leading, spacing: Constants.spacing) {
            Group {
                if let coverMedium = album.coverMedium {
                    AsyncImage(url: URL(string: coverMedium)) { image in
                        image
                            .coverImageModifier(height: albumCoverFrame,
                                                width: albumCoverFrame)
                    } placeholder: {
                        Image(systemName: "camera.metering.unknown")
                            .coverImageModifier()
                    }
                } else {
                    Image(systemName: "camera.metering.unknown")
                        .coverImageModifier()
                }
            }
            .frame(width: albumCoverFrame,
                   height: albumCoverFrame)

            Group {
                Text(album.title)
                    .bold()
                    .foregroundColor(.primary)

                Text(artistName)
                    .foregroundColor(.secondary)
                    .padding(.top, .zero)
            }
            .lineLimit(Constants.lineLimit)
            .multilineTextAlignment(.leading)
            .font(.body)
        }
        .padding([.leading, .trailing])
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
