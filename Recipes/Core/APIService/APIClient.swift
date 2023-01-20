//
//  APIClient.swift
//  Recipes
//
//

import Foundation
import Combine

// MARK: - ApiClient

struct APIClient {
    
    private var baseURL: String
    private var apiKey: String
    private var networkDispatcher: NetworkDispatcher
    
    init(baseURL: String = "https://api.spoonacular.com",
         apiKey: String = Environment.apiKey,
         networkDispatcher: NetworkDispatcher = NetworkDispatcher() ) {
        
        self.baseURL = baseURL
        self.apiKey = apiKey
        self.networkDispatcher = networkDispatcher
    }

    private func dispatch<R: Request>(_ request: R) -> AnyPublisher<R.ReturnType, NetworkRequestError> {
        
        guard let urlRequest = request.asURLRequest(baseURL: baseURL) else {
            return Fail(outputType: R.ReturnType.self, failure: NetworkRequestError.badRequest).eraseToAnyPublisher()
            
        }
        
        typealias RequestPublisher = AnyPublisher<R.ReturnType, NetworkRequestError>
        let requestPublisher: RequestPublisher = networkDispatcher.dispatch(request: urlRequest)
        return requestPublisher.eraseToAnyPublisher()
    }
}

extension APIClient: SpoonacularAPIClient {
    
    func getRecipes() -> AnyPublisher<RecipeListResponse, NetworkRequestError> {
        let recipeListRequest = RecipeListRequest()
        return dispatch(recipeListRequest)
    }
    
    func getRecipe(id: Int) -> AnyPublisher<Recipe, NetworkRequestError> {
        let recipeRequest = RecipeRequest(id: id)
        return dispatch(recipeRequest)
    }
    
    func getSimilarRecipes(id: Int) -> AnyPublisher<[SimilarRecipe], NetworkRequestError> {
        let similarRecipesRequest = SimilarRecipesRequest(id: id)
        return dispatch(similarRecipesRequest)
    }
    
    func getFullSimilarRecipes(id: Int) -> AnyPublisher<[Recipe], NetworkRequestError> {
        let similarRecipesRequest = SimilarRecipesRequest(id: id)
        return dispatch(similarRecipesRequest).flatMap { similarRecipes in
            let recipes = similarRecipes.compactMap { similarRecipe in
                let recipeRequest = RecipeRequest(id: similarRecipe.id)
                return dispatch(recipeRequest)
            }
            return Publishers.MergeMany(recipes).collect()
        }.eraseToAnyPublisher()
    }
}
