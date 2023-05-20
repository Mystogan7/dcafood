//
//  Game.swift
//  DCAFood
//
//  Created by Mohamed Abdelhamid Mohamed Oshaiba on 20/05/2023.
//

import Foundation

struct Game: Codable, Equatable {
    let id: Int?
    let slug: String?
    let name: String?
    let metacritic: Int?
    let genres: [Genre]?
    let backgroundImage: String?
    
    
    enum CodingKeys: String, CodingKey {
        case id, slug, name
        case metacritic
        case genres
        case backgroundImage = "background_image"
    }
    
    static func ==(lhs: Game, rhs: Game) -> Bool {
        return lhs.id == rhs.id
    }
}
