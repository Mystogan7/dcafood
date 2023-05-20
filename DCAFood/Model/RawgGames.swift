//
//  RawgGames.swift
//  DCAFood
//
//  Created by Mohamed Abdelhamid Mohamed Oshaiba on 20/05/2023.
//

import Foundation

struct RawgGames: Codable {
    let items: [Game]

    enum CodingKeys: String, CodingKey {
        case items = "results"
    }
}
