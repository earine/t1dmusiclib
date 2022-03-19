//
//  ArtistsListView.swift
//  musiclib
//
//  Created by mlunts on 19.03.2022.
//

import SwiftUI

struct ArtistsListView: View {
    // TODO: replace dummy data with the backend
    let artists = ["Prince", "Lady Gaga", "Sade", "Taylor Swift", "Weeknd"]

    @State private var searchQueryString = ""

    private enum Constants {
        static let cellHeight: CGFloat = 40
        static let artistImageWidth: CGFloat = 50
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(artists, id: \.self) { artist in
                    NavigationLink(destination: ArtistView(artist: artist)) {
                        artistCell(artist)
                    }
                }
            }
            .navigationTitle("Artists")
            .listStyle(.plain)
        }
        .searchable(text: $searchQueryString)
        .onChange(of: searchQueryString) { searchText in
        }
    }
}

extension ArtistsListView {
    private func artistCell(_ artist: String) -> some View {
        HStack {
            Image(systemName: "camera.metering.unknown")
                .resizable()
                .frame(width: Constants.artistImageWidth)
                .aspectRatio(contentMode: .fit)

            Text(artist)
        }
        .frame(height: Constants.cellHeight)
    }
}

struct ArtistsListView_Previews: PreviewProvider {
    static var previews: some View {
        ArtistsListView()
    }
}
