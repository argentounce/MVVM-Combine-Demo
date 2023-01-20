//
//  Ingredient.swift
//  Recipes
//
//

import Foundation

struct Ingredient: Codable {
    let id: Int
    let aisle: String
    let name: String
    let original: String
}
