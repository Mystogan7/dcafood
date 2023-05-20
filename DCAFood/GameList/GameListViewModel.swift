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

    func fetchGames(query: String, page: Int = 0) {
        // Set the current query and page
        currentQuery = query

        gameService.searchGames(query: query, page: page == 0 ? currentPage : page) { [weak self] result in
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
        if query.isEmpty {
            filteredGames.value = gameList.value
        } else {
            let filtered = gameList.value.filter { $0.name?.lowercased().contains(query.lowercased()) ?? false }
            if filtered.isEmpty {
                // Fetch new games from the API if no local results
                fetchGames(query: query, page: currentPage)
            } else {
                filteredGames.value = filtered
            }
        }
    }
}
