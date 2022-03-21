//
//  Chart.swift
//  musiclib
//
//  Created by mlunts on 21.03.2022.
//

import Foundation

struct Chart: Codable {
    let artists: [Artist]

    // MARK: - Codable
    private enum CodingKeys: String, CodingKey {
        case artists = "data"
    }
}
