//
//  RawgAPI.swift
//  DCAFood
//
//  Created by Mohamed Abdelhamid Mohamed Oshaiba on 20/05/2023.
//

import Foundation

struct RawgAPI {
    static let baseURL = Configuration.current.baseURL
    static let apiKey = Configuration.current.apiKey
    
    enum Endpoint {
        case gamesList(pageSize: Int, page: Int)
        case searchGames(pageSize: Int, page: Int, query: String)
        case gameDetails(gameId: Int)
    }
}

extension RawgAPI.Endpoint {
    func url() -> URL? {
        var components = URLComponents(string: RawgAPI.baseURL)
        
        switch self {
        case .gamesList(let pageSize, let page):
            components?.path += "/games"
            components?.queryItems = [
                URLQueryItem(name: "page_size", value: "\(pageSize)"),
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "key", value: RawgAPI.apiKey)
            ]
        case .searchGames(let pageSize, let page, let query):
            components?.path += "/games"
            components?.queryItems = [
                URLQueryItem(name: "page_size", value: "\(pageSize)"),
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "search", value: query),
                URLQueryItem(name: "key", value: RawgAPI.apiKey)
            ]
        case .gameDetails(let gameId):
            components?.path += "/games/\(gameId)"
            components?.queryItems = [
                URLQueryItem(name: "key", value: RawgAPI.apiKey)
            ]
        }
        
        return components?.url
    }
}
