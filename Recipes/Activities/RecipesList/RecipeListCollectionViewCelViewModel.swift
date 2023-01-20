//
//  RecipeListCollectionViewCelViewModel.swift
//  Recipes
//
//

import Foundation

struct RecipeListCollectionViewCelViewModel {
    
    private let recipe: Recipe
    
    init(recipe: Recipe) {
        self.recipe = recipe
    }
    
    var title: String {
        recipe.title
    }
    
    var dishTypes: String {
        recipe.dishTypes.map({$0.capitalized}).joined(separator: ", ")
    }
    
    var imageURL: URL {
        recipe.image
    }
    
    var badgeValue: String {
        "\(recipe.weightWatcherSmartPoints)"
    }
}
