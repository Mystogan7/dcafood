//
//  DetailsViewModelTests.swift
//  DCAFoodTests
//
//  Created by Mohamed Abdelhamid Mohamed Oshaiba on 22/05/2023.
//

import XCTest
@testable import DCAFood

class DetailsViewModelTests: XCTestCase {
    var viewModel: DetailsViewModelProtocol!
    var favoritesServiceMock: FavoritesServiceMock!
    var detailsServiceMock: DetailsServiceMock!

    override func setUp() {
        super.setUp()
        favoritesServiceMock = FavoritesServiceMock()
        detailsServiceMock = DetailsServiceMock()
        let game = Game(id: 1, slug: "game1", name: "Game1", metacritic: 80, genres: [], backgroundImage: "")
        viewModel = DetailsViewModel(favoriteService: favoritesServiceMock, detailsService: detailsServiceMock, game: game)
    }

    override func tearDown() {
        favoritesServiceMock = nil
        detailsServiceMock = nil
        viewModel = nil
        super.tearDown()
    }

    func testFetchGameDetails() {
        // Given
        let gameDetails = GameDetails(id: 1, slug: "game1", name: "Game1", nameOriginal: "Game1", description: "Description of Game1", website: "https://game1.com", redditURL: "https://www.reddit.com/r/game1", backgroundImage: "https://images.game1.com/background.jpg")
        detailsServiceMock.gameDetails = gameDetails

        // When fetching game details
        viewModel.fetchDetails(id: gameDetails.id ?? 0)

        // Then the details should be equal to the fetched game details
        XCTAssertEqual(viewModel.details.value, gameDetails)
    }
    
    func testFavoriteGame() {
        // Given
        let game = Game(id: 1, slug: "game1", name: "Game1", metacritic: 80, genres: [], backgroundImage: "")
        
        // When the game is not a favorite
        XCTAssertFalse(viewModel.isFavorite.value)
        
        // When adding the game to favorites
        viewModel.favorite(game: game)
        
        // Then the game should be marked as a favorite
        XCTAssertTrue(viewModel.isFavorite.value)
        
        // When trying to add the game to favorites again
        viewModel.favorite(game: game)
        
        // Then the game should still be marked as a favorite (no change)
        XCTAssertTrue(viewModel.isFavorite.value)
    }
}

class DetailsServiceMock: DetailsServiceProtocol {
    var gameDetails: GameDetails?

    func fetchGameDetails(id: Int, completion: @escaping (Result<GameDetails, Error>) -> Void) {
        if let gameDetails = gameDetails {
            completion(.success(gameDetails))
        } else {
            completion(.failure(ServiceError.invalidURL))
        }
    }
}
