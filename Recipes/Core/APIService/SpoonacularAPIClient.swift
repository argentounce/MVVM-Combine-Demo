//
//  SpoonacularAPIClient.swift
//  Recipes
//
//

import Foundation
import Combine

protocol SpoonacularAPIClient {
    func getRecipes() -> AnyPublisher<RecipeListResponse, NetworkRequestError>
    func getRecipe(id: Int) -> AnyPublisher<Recipe, NetworkRequestError>
    func getSimilarRecipes(id: Int) -> AnyPublisher<[SimilarRecipe], NetworkRequestError>
}
