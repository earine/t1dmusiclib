//
//  Artist.swift
//  musiclib
//
//  Created by mlunts on 19.03.2022.
//

import Foundation
struct Artist: Codable, Equatable {
    static func == (lhs: Artist, rhs: Artist) -> Bool {
        return lhs.id == rhs.id
    }

    let id: Int
    let name: String
    let pictureMedium: String
    var albums: [Album]? 

    enum CodingKeys: String, CodingKey {
        case id, name, pictureMedium
    }
}
