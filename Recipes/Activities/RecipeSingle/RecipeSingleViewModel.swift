//
//  RecipeSingleViewModel.swift
//  Recipes
//
//

import Foundation
import Combine

class RecipeSingleViewModel: ObservableObject {
    
    private let apiClient: APIClient
    private let recipe: Recipe
    private var similarRecipes: [Recipe] = []
    private var cancellables = [AnyCancellable]()
    
    private(set) var similarRecipes$ = PassthroughSubject<Result<[Recipe], NetworkRequestError>, Never>()
    
    var activityTitle: String {
        recipe.title
    }
    
    var recipeTitle: String {
        recipe.title
    }
    
    var recipeImageURL: URL {
        recipe.image
    }
    
    var recipeSummary: NSAttributedString {
        
        let stringData = Data(recipe.summary.utf8)
        
        if let attributedString = try? NSAttributedString(data: stringData, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            return attributedString
        }
        
        return NSAttributedString(string: recipe.summary)
    }
    
    var sectionsCount: Int {
        1
    }
    
    var similarRecipesCount: Int {
        similarRecipes.count
    }
    
    init(recipe: Recipe, apiClient: APIClient = APIClient(),
         similarRecipes: [Recipe] = [Recipe]() ) {
        
        self.apiClient = apiClient
        self.recipe = recipe
        self.similarRecipes = similarRecipes
    }
    
    func fetchSimilarRecipes() {
        apiClient.getFullSimilarRecipes(id: recipe.id).sink { [weak self] completion in
            switch completion {
                case .finished:
                    break
                case .failure(let error):
                self?.similarRecipes$.send(.failure(error))
            }
        } receiveValue: { [weak self] response in
            self?.similarRecipes = response
            self?.similarRecipes$.send(.success(response))
        }.store(in: &cancellables)
    }
    
    func similarRecipeAtIndex(_ index: Int) -> Recipe {
        return similarRecipes[index]
    }
}
