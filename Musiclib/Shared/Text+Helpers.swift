//
//  Text+Helpers.swift
//  Musiclib
//
//  Created by mlunts on 24.03.2022.
//

import SwiftUI

extension Text {
    func titleModifier() -> some View {
        self
            .fontWeight(.medium)
            .foregroundColor(.primary)
    }

    func artistTextModifier() -> some View {
        self
            .foregroundColor(.secondary)
            .font(.callout)
            .fontWeight(.light)
    }
}
