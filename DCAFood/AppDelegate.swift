//
//  AppDelegate.swift
//  DCAFood
//
//  Created by Mohamed Abdelhamid Mohamed Oshaiba on 20/05/2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var mainCoordinator: MainCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        mainCoordinator = MainCoordinator(window: window)
        mainCoordinator?.start()
        
        self.window = window
        window.makeKeyAndVisible()
        
        return true
    }

}

