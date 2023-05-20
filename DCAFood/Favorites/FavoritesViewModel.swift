//
//  FavoritesViewModel.swift
//  DCAFood
//
//  Created by Mohamed Abdelhamid Mohamed Oshaiba on 20/05/2023.
//

import Foundation

protocol FavoritesViewModelProtocol {
    var gameList: Observable<[Game]> { get }
    func removeFromFavorites(game: Game)
}

class FavoritesViewModel: FavoritesViewModelProtocol {
    private let favoriteService: FavoritesServiceProtocol
    private(set) var gameList: Observable<[Game]> = Observable([])
    
    
    init(favoriteService: FavoritesServiceProtocol = FavoritesService()) {
        self.favoriteService = favoriteService
        
        bindFavoritesService()
    }
    
    func removeFromFavorites(game: Game) {
        favoriteService.removeFromFavorites(game: game)
    }
    
    private func bindFavoritesService() {
        let favoritesObserver = ClosureObserver<[Game]> { [weak self] favorites in
            self?.gameList.value = favorites
        }
        favoriteService.favorites.addObserver(favoritesObserver)
    }
}
