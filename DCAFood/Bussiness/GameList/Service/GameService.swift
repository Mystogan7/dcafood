//
//  GameService.swift
//  DCAFood
//
//  Created by Mohamed Abdelhamid Mohamed Oshaiba on 20/05/2023.
//

enum ServiceError: Error {
    case invalidURL
}

protocol GameServiceProtocol {
    func searchGames(query: String, page: Int, completion: @escaping (Result<GameListResponse, Error>) -> Void)
}

class GameService: GameServiceProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    func searchGames(query: String, page: Int, completion: @escaping (Result<GameListResponse, Error>) -> Void) {
        guard let url = RawgAPI.Endpoint.searchGames(pageSize: 10, page: page, query: query).url() else {
            completion(.failure(ServiceError.invalidURL))
            return
        }
        networkService.request(url, completion: completion)
    }
}
