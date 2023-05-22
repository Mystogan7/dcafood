//
//  FavoritesViewModelTests.swift
//  DCAFoodTests
//
//  Created by Mohamed Abdelhamid Mohamed Oshaiba on 22/05/2023.
//

import XCTest
@testable import DCAFood

class FavoritesViewModelTests: XCTestCase {
    var viewModel: FavoritesViewModelProtocol!
    var favoritesServiceMock: FavoritesServiceMock!
    
    override func setUp() {
        super.setUp()
        favoritesServiceMock = FavoritesServiceMock()
        viewModel = FavoritesViewModel(favoriteService: favoritesServiceMock)
    }
    
    override func tearDown() {
        favoritesServiceMock = nil
        viewModel = nil
        super.tearDown()
    }
    
    func testAddRemoveFavorites() {
        // Given
        let game1 = Game(id: 1, slug: "game1", name: "Game1", metacritic: 80, genres: [], backgroundImage: "")
        let game2 = Game(id: 2, slug: "game2", name: "Game2", metacritic: 85, genres: [], backgroundImage: "")
        
        // When adding a game to favorites
        favoritesServiceMock.addToFavorites(game: game1)
        
        // Then the game list should contain that game
        XCTAssertEqual(viewModel.gameList.value, [game1])
        
        // When adding another game to favorites
        favoritesServiceMock.addToFavorites(game: game2)
        
        // Then the game list should contain both games
        XCTAssertEqual(viewModel.gameList.value, [game1, game2])
        
        // When removing a game from favorites
        viewModel.removeFromFavorites(game: game1)
        
        // Then the game list should not contain the removed game
        XCTAssertEqual(viewModel.gameList.value, [game2])
    }
}

class FavoritesServiceMock: FavoritesServiceProtocol {
    var favorites: Observable<[Game]> = Observable([])

    func addToFavorites(game: Game) {
        favorites.value.append(game)
    }
    
    func removeFromFavorites(game: Game) {
        if let index = favorites.value.firstIndex(of: game) {
            favorites.value.remove(at: index)
        }
    }
    
    func isFavorite(game: Game) -> Bool {
        return favorites.value.contains(game)
    }
}
