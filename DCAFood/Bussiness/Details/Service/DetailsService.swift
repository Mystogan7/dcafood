//
//  DetailsService.swift
//  DCAFood
//
//  Created by Mohamed Abdelhamid Mohamed Oshaiba on 21/05/2023.
//

import Foundation

protocol DetailsServiceProtocol {
    func fetchGameDetails(id: Int, completion: @escaping (Result<GameDetails, Error>) -> Void)
}

class DetailsService: DetailsServiceProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    func fetchGameDetails(id: Int, completion: @escaping (Result<GameDetails, Error>) -> Void) {
        guard let url = RawgAPI.Endpoint.gameDetails(gameId: id).url() else {
            completion(.failure(ServiceError.invalidURL))
            return
        }
        networkService.request(url, completion: completion)
    }
}
