//
//  SimilarRecipeCollectionViewCellViewModel.swift
//  Recipes
//
//

import Foundation

struct SimilarRecipeCollectionViewCellViewModel {
    
    private let recipe: Recipe
    
    init(recipe: Recipe) {
        self.recipe = recipe
    }
    
    var title: String {
        recipe.title
    }
    
    var imageURL: URL {
        recipe.image
    }
    
    var badgeValue: String {
        "\(recipe.weightWatcherSmartPoints)"
    }
}
