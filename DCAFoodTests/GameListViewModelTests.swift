//
//  GameListViewModelTests.swift
//  DCAFoodTests
//
//  Created by Mohamed Abdelhamid Mohamed Oshaiba on 22/05/2023.
//

import XCTest
@testable import DCAFood

final class GameListViewModelTests: XCTestCase {
    
    var viewModel: GameListViewModelProtocol!
    var gameServiceMock: GameServiceMock!
    
    override func setUp() {
        super.setUp()
        gameServiceMock = GameServiceMock()
        viewModel = GameListViewModel(gameService: gameServiceMock)
    }
    
    override func tearDown() {
        gameServiceMock = nil
        viewModel = nil
        super.tearDown()
    }
    
    func testSearchFunctionality() {
        // Given
        let game1 = Game(id: 1, slug: "game1", name: "Game1", metacritic: 80, genres: [], backgroundImage: "")
        let game2 = Game(id: 2, slug: "game2", name: "Game2", metacritic: 85, genres: [], backgroundImage: "")
        let game3 = Game(id: 3, slug: "game3", name: "Game3", metacritic: 90, genres: [], backgroundImage: "")
        let gameListResponse = GameListResponse(items: [game1, game2, game3])

        // Setup mock response
        gameServiceMock.searchGamesResponse = gameListResponse

        // When
        viewModel.fetchGames(query: "game", page: 1)

        // Then
        XCTAssertEqual(viewModel.gameList.value, [game1, game2, game3])
        XCTAssertEqual(viewModel.filteredGames.value, [game1, game2, game3])

        // When
        viewModel.searchGames(query: "Game2")

        // Then
        XCTAssertEqual(viewModel.filteredGames.value, [game2])
    }
    
}

class GameServiceMock: GameServiceProtocol {
    var searchGamesResponse: GameListResponse?

    func searchGames(query: String, page: Int, completion: @escaping (Result<GameListResponse, Error>) -> Void) {
        if let response = searchGamesResponse {
            completion(.success(response))
        } else {
            completion(.failure(ServiceError.invalidURL))
        }
    }
}
