//
//  Configurations.swift
//  DCAFood
//
//  Created by Mohamed Abdelhamid Mohamed Oshaiba on 20/05/2023.
//

import Foundation

enum Configuration {
    case development, production

    static let current: Configuration = {
        #if DEVELOPMENT
        return .development
        #else
        return .production
        #endif
    }()
}

extension Configuration {
    private static let config: NSDictionary = {
        guard let path = Bundle.main.path(forResource: "Configurations", ofType: "plist"),
              let config = NSDictionary(contentsOfFile: path) else {
            fatalError("Configurations.plist not found")
        }
        return config
    }()
    
    var baseURL: String {
        guard let config = Configuration.config[self.rawValue] as? [String: AnyObject],
              let baseURL = config["BaseURL"] as? String else {
            fatalError("Invalid or missing BaseURL for configuration")
        }
        return baseURL
    }
    
    var apiKey: String {
        guard let config = Configuration.config[self.rawValue] as? [String: AnyObject],
              let apiKey = config["APIKey"] as? String else {
            fatalError("Invalid or missing APIKey for configuration")
        }
        return apiKey
    }
    
    private var rawValue: String {
        switch self {
        case .development:
            return "Development"
        case .production:
            return "Production"
        }
    }
}
