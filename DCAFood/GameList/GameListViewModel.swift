//
//  GameListViewModel.swift
//  DCAFood
//
//  Created by Mohamed Abdelhamid Mohamed Oshaiba on 20/05/2023.
//

import Foundation

protocol GameListViewModelProtocol {
    var gameList: Observable<[Game]> { get }
    var filteredGames: Observable<[Game]> { get }
    func fetchGames(query: String, page: Int)
    func searchGames(query: String)
    var currentQuery: String {get set}
    var currentPage: Int {get set}
}

class GameListViewModel: GameListViewModelProtocol {
    private let gameService: GameServiceProtocol
    private(set) var gameList: Observable<[Game]> = Observable([])
    private(set) var filteredGames: Observable<[Game]> = Observable([])
     
    var currentQuery: String = ""
    var currentPage: Int = 1

    init(gameService: GameServiceProtocol = GameService()) {
        self.gameService = gameService
    }

    func fetchGames(query: String, page: Int = 1) {
        if query == currentQuery && page != 1 {
            currentPage = page
        } else {
            currentQuery = query
            currentPage = 1
        }
        
        gameService.searchGames(query: query, page: page) { [weak self] result in
            switch result {
            case .success(let gameListResponse):
                // Append new games to the existing game list
                var currentList = self?.gameList.value ?? []
                currentList.append(contentsOf: gameListResponse.items ?? [])
                self?.gameList.value = currentList
                
                // Filter the games based on the current query
                self?.searchGames(query: query)
                
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func searchGames(query: String) {
        if query.isEmpty || query == currentQuery {
            filteredGames.value = gameList.value
        } else {
            currentQuery = query
            currentPage = 1
            gameList.value = []
            fetchGames(query: query, page: 1)
        }
    }

    private func filteredGameList(query: String) -> [Game] {
        return gameList.value.filter { $0.name?.lowercased().contains(query.lowercased()) ?? false }
    }
}
