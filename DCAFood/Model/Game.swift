//
//  Game.swift
//  DCAFood
//
//  Created by Mohamed Abdelhamid Mohamed Oshaiba on 20/05/2023.
//

import Foundation

struct Game: Codable {
    let id: Int
    let slug, name: String
    let metacritic: Int
    let genres: [Genre]

    enum CodingKeys: String, CodingKey {
        case id, slug, name
        case metacritic
        case genres
    }
}
