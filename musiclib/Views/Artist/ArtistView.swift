//
//  ArtistView.swift
//  musiclib
//
//  Created by mlunts on 19.03.2022.
//

import SwiftUI

struct ArtistView: View {

    var artist: String

    let data = (1...100).map { "Item \($0)" }
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(data, id: \.self) { item in
                    albumCell()
                }
            }
        }
        .navigationTitle(artist)
    }
}

extension ArtistView {
    private func albumCell() -> some View {
        VStack {
            Image(systemName: "camera.metering.unknown")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()

            Text("Fetch the Bold Cutters")
        }
    }
}

struct ArtistView_Previews: PreviewProvider {
    static var previews: some View {
        ArtistView(artist: "Prince")
    }
}
