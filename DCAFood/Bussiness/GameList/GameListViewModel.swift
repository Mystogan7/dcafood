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
        currentQuery = query
        if query.count <= 2 {
            // If the query contains 2 letters or less, filter the games list based on the query
            filteredGames.value = filteredGameList(query: query)
        } else {
            // If the query contains more than 2 letters, search for games in the already fetched data
            let filteredList = filteredGameList(query: query)
            if !filteredList.isEmpty {
                // If there are games in the filtered list, set the filtered games property to the filtered list
                filteredGames.value = filteredList
            } else {
                // If there are no games in the filtered list, call the API to fetch games
                currentPage = 1
                gameList.value = []
                fetchGames(query: query, page: 1)
            }
        }
    }

    private func filteredGameList(query: String) -> [Game] {
        return gameList.value.filter { $0.name?.lowercased().contains(query.lowercased()) ?? false }
    }
}
