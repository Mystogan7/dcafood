//
//  FavoritesService.swift
//  DCAFood
//
//  Created by Mohamed Abdelhamid Mohamed Oshaiba on 20/05/2023.
//

import Foundation

protocol FavoritesServiceProtocol {
    var favorites: Observable<[Game]> { get }
    func addToFavorites(game: Game)
    func removeFromFavorites(game: Game)
}

class FavoritesService: FavoritesServiceProtocol {
    private (set) var favorites: Observable<[Game]> = Observable([])
    
    func addToFavorites(game: Game) {
        favorites.value.append(game)
    }
    
    func removeFromFavorites(game: Game) {
        if let index = favorites.value.firstIndex(of: game) {
            favorites.value.remove(at: index)
        }
    }
}
