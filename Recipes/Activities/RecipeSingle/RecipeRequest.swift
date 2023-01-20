//
//  RecipeRequest.swift
//  Recipes
//
//

import Foundation

struct RecipeRequest: Request {
    
    typealias ReturnType = Recipe
    
    private var id: Int
    
    var path: String {
        "/recipes/\(id)/information"
    }
    
    var headers: [String : String]? = [
        "x-api-key": Environment.apiKey
    ]
    
    init(id:Int) {
        self.id = id
    }
}
