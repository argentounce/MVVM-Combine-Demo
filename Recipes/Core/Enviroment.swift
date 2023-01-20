//
//  Enviroment.swift
//  Recipes
//
//

import Foundation

public struct Environment {
    enum Keys {
        static let apiKey = "API_KEY"
    }
    
    static let apiKey: String = {
        guard let apiKeyProperty = Bundle.main.object(
            forInfoDictionaryKey: Keys.apiKey
        ) as? String else {
            fatalError("API_KEY not found")
        }
        return apiKeyProperty
    }()
}
