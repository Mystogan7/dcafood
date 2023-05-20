//
//  FavoritesService.swift
//  DCAFood
//
//  Created by Mohamed Abdelhamid Mohamed Oshaiba on 20/05/2023.
//

import Foundation

class FavoritesService {
    private var favorites: Set<Int> = []
    
    func isFavorite(id: Int) -> Bool {
        return favorites.contains(id)
    }
    
    func addToFavorites(id: Int) {
        favorites.insert(id)
    }
    
    func removeFromFavorites(id: Int) {
        favorites.remove(id)
    }
}
