//
//  Recipe.swift
//  Recipes
//
//

import Foundation

struct Recipe: Codable {
    let id: Int
    let title: String
    let image: URL
    let cuisines: [String]
    let extendedIngredients: [Ingredient]
    let dishTypes: [String]
    let summary: String
    let instructions: String
    let weightWatcherSmartPoints: Int
}
