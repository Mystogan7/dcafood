//
//  GameDetail.swift
//  DCAFood
//
//  Created by Mohamed Abdelhamid Mohamed Oshaiba on 20/05/2023.
//

import Foundation

struct GameDetails: Codable {
    let id: Int?
    let slug, name, nameOriginal, description: String?
    let website: String?
    let redditURL: String?
    let backgroundImage: String?

    enum CodingKeys: String, CodingKey {
        case id, slug, name
        case nameOriginal = "name_original"
        case description
        case backgroundImage = "background_image"
        case website
        case redditURL = "reddit_url"
    }
}
