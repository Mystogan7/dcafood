//
//  DetailsViewModel.swift
//  DCAFood
//
//  Created by Mohamed Abdelhamid Mohamed Oshaiba on 21/05/2023.
//

import Foundation

protocol DetailsViewModelProtocol {
    var details: Observable<GameDetails?> { get }
    var isFavorite: Observable<Bool> { get }
    func fetchDetails(id: Int)
    func favorite(game: Game)
}

class DetailsViewModel: DetailsViewModelProtocol {
    private let favoriteService: FavoritesServiceProtocol
    private let detailsService: DetailsServiceProtocol
    private let game: Game
    
    private(set) var details: Observable<GameDetails?> = Observable(nil)
    private(set) var isFavorite: Observable<Bool> = Observable(false)
    
    init(favoriteService: FavoritesServiceProtocol = FavoritesService.shared,
         detailsService: DetailsServiceProtocol = DetailsService(),
         game: Game) {
        self.favoriteService = favoriteService
        self.detailsService = detailsService
        self.game = game
        
        isFavorite.value = favoriteService.isFavorite(game: game)
    }
    
    func fetchDetails(id: Int) {
        detailsService.fetchGameDetails(id: id) { [weak self] result in
            switch result {
            case .success(let details):
                self?.details.value = details
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    
    func favorite(game: Game) {
        if !favoriteService.isFavorite(game: game) {
            favoriteService.addToFavorites(game: game)
            isFavorite.value = favoriteService.isFavorite(game: game)
        }
    }
}
