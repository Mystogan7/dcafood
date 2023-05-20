//
//  Genre.swift
//  DCAFood
//
//  Created by Mohamed Abdelhamid Mohamed Oshaiba on 20/05/2023.
//

import Foundation

struct Genre: Codable {
    let id: Int
    let name, slug: String

    enum CodingKeys: String, CodingKey {
        case id, name, slug
    }
}
