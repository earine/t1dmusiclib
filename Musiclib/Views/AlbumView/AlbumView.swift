//
//  AlbumView.swift
//  Musiclib
//
//  Created by mlunts on 22.03.2022.
//

import SwiftUI
import ComposableArchitecture
import UIKit
struct AlbumView: View {
    let store: Store<AlbumState, AlbumAction>

    private enum Constants {
        static let trackNumberWidth: CGFloat = 22
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
                            Image(systemName: "camera.metering.unknown")
                        }
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                        .listRowInsets(EdgeInsets())

                        if let tracks = viewStore.tracks {

                            ForEach(tracks.indices) { index in
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
                .frame(width: Constants.trackNumberWidth, alignment: .leading)
            
            Text(track.title)

            Spacer()
            
            Text(track.duration.durationString)
        }
        .lineLimit(1)
        .listRowBackground(Color(UIColor.secondarySystemBackground))
    }
}

//struct AlbumView_Previews: PreviewProvider {
//    static var previews: some View {
//        AlbumView()
//    }
//}
