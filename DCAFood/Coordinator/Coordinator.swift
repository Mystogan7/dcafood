//
//  Coordinator.swift
//  DCAFood
//
//  Created by Mohamed Abdelhamid Mohamed Oshaiba on 20/05/2023.
//

import UIKit

// Coordinator Protocol
protocol Coordinator {
    func start()
}

// Main Coordinator
// Manages the main tab bar controller and its child view controllers
class MainCoordinator: Coordinator {
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    // Sets up the tab bar controller and its child view controllers
    func start() {
        let tabBarController = MainTabBarController()
        
        // Set up the game list view controller and its coordinator
        let gameListViewController = GameListViewController()
        let gameListCoordinator = GameListCoordinator(gameListViewController: gameListViewController)
        gameListViewController.coordinator = gameListCoordinator
        gameListViewController.tabBarItem = UITabBarItem(title: "Games", image: UIImage(named: "games_icon"), tag: 0)
        
        // Set up the favorites view controller and its coordinator
        let favoritesViewController = FavoritesViewController()
        let favoritesCoordinator = FavoritesCoordinator(favoritesViewController: favoritesViewController)
        favoritesViewController.coordinator = favoritesCoordinator
        favoritesViewController.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(named: "favorites_icon"), tag: 1)
        
        tabBarController.viewControllers = [gameListCoordinator.gameListViewController, favoritesCoordinator.favoritesViewController]
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
}

// GameListCoordinator
class GameListCoordinator: Coordinator {
    let gameListViewController: GameListViewController
    
    init(gameListViewController: GameListViewController) {
        self.gameListViewController = gameListViewController
    }
    
    func start() {}
    
    func showGameDetails() {
//        let gameDetailsViewController = GameDetailsViewController()
//        gameDetailsViewController.coordinator = self
//        gameListViewController.navigationController?.pushViewController(gameDetailsViewController, animated: true)
    }
}

// FavoritesCoordinator
class FavoritesCoordinator: Coordinator {
    let favoritesViewController: FavoritesViewController
    
    init(favoritesViewController: FavoritesViewController) {
        self.favoritesViewController = favoritesViewController
    }
    
    func start() {}
}
