//
//  CustomCenterView.swift
//  Musiclib
//
//  Created by mlunts on 25.03.2022.
//

import SwiftUI

struct CustomCenterView: View {
    let view: AnyView
    var fullScreen: Bool = false

    private enum Constants {
        static let height: CGFloat = 50
    }
    var body: some View {
        HStack(alignment: .center) {
            Spacer()
            view
            Spacer()
        }
        .frame(height: fullScreen ? UIScreen.main.bounds.height / 2 : Constants.height)
    }
}
