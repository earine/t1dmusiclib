//
//  Image+Helpers.swift
//  musiclib
//
//  Created by mlunts on 22.03.2022.
//

import SwiftUI

extension Image {
    func coverImageModifier(height: CGFloat? = 30, width: CGFloat? = 30) -> some View {
        self
            .resizable()
            .scaledToFill()
            .frame(width: width, height: height)
            .clipped()
            .foregroundColor(.secondary)
    }
}
