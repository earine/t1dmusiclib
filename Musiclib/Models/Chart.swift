//
//  Chart.swift
//  musiclib
//
//  Created by mlunts on 21.03.2022.
//

struct Chart: Codable {
    let artists: [Artist]

    private enum CodingKeys: String, CodingKey {
        case artists = "data"
    }
}
