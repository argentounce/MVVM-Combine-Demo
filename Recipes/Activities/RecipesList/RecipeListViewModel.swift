//
//  RecipeListViewModel.swift
//  Recipes
//
//

import Foundation
import Combine

final class RecipeListViewModel: ObservableObject {
    
    private let apiClient: APIClient
    private var recipes: [Recipe] = []
    private var cancellables = [AnyCancellable]()
    
    let recipes$ = PassthroughSubject<Result<[Recipe], NetworkRequestError>, Never>()
    
    var activityTitle: String {
        "Recipes List"
    }
    
    var sectionsCount: Int {
        1
    }
    
    var recipesCount: Int {
        recipes.count
    }
    
    init(apiClient: APIClient = APIClient(),
         recipes: [Recipe] = [Recipe]()) {
        self.apiClient = apiClient
        self.recipes = recipes
    }
    
    func fetchRecipes() {
        
        apiClient.getRecipes().sink { [weak self] completion in
            switch completion {
                case .finished:
                    break
                case .failure(let error):
                self?.recipes$.send(.failure(error))
            }
        } receiveValue: { [weak self] response in
            self?.recipes = response.recipes
            self?.recipes$.send(.success(response.recipes))
        }.store(in: &cancellables)
    }
    
    func recipeAtIndex(_ index: Int) -> Recipe {
        return recipes[index]
    }
}
