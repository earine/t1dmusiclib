//
//  AlbumView.swift
//  Musiclib
//
//  Created by mlunts on 22.03.2022.
//

import SwiftUI
import ComposableArchitecture

struct AlbumView: View {
    let store: Store<AlbumState, AlbumAction>

    private enum Constants {
        static let trackNumberWidth: CGFloat = 25
        static let trackTitlePadding: CGFloat = 4
        static let trackCoverPlaceholderImageName: String = "camera.metering.unknown"
    }

    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack {
                if viewStore.state.isLoading {
                    ProgressView()
                } else {
                    List {
                        AsyncImage(url: URL(string: viewStore.album.coverMedium ?? "")) { image in
                            image
                                .coverImageModifier(height: UIScreen.main.bounds.width,
                                                    width: UIScreen.main.bounds.width)
                        } placeholder: {
                            Image(systemName: Constants.trackCoverPlaceholderImageName)
                        }
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                        .listRowInsets(EdgeInsets())

                        if let tracks = viewStore.tracks {
                            ForEach(tracks.indices, id: \.self) { index in
                                trackListCell(tracks[index], trackNumber: String(index + 1))
                            }
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width)
                    .listStyle(.plain)
                }
            }
            .navigationTitle(viewStore.state.album.title)
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }

    private func trackListCell(_ track: Track, trackNumber: String) -> some View {
        HStack(alignment: .center) {
            Text(trackNumber)
                .titleModifier()
                .frame(width: Constants.trackNumberWidth, alignment: .leading)

            VStack(alignment: .leading) {
                Text(track.title)
                    .titleModifier()

                if let contributors = track.contributors {
                    Text(contributors.map({ $0.name }).joined(separator: ", "))
                        .artistTextModifier()
                }
            }
            .padding([.top, .bottom], Constants.trackTitlePadding)
            
            Spacer()
            
            Text(track.duration.durationString)
                .artistTextModifier()
        }
        .lineLimit(1)
        .listRowBackground(Color(UIColor.secondarySystemBackground))
    }
}

struct AlbumView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumView(store: Store(
            initialState: AlbumState(album: Album(id: 0,
                                                  title: "SAWAYAMA",
                                                  coverMedium: nil,
                                                  tracks: TracksResponse(data: [
                                                    Track(id: 1,
                                                          title: "Dynasty",
                                                          duration: 329,
                                                          contributors:
                                                            [
                                                                Artist(id: 1,
                                                                       name: "Rina Sawayama",
                                                                       pictureMedium: "")
                                                            ]
                                                         )
                                                  ]))),
            reducer: albumReducer,
            environment: AlbumEnvironment.makeAlbumEnvironment()
        ))
    }
}
