//
//  RecipeListRequest.swift
//  Recipes
//
//

import Foundation

struct RecipeListRequest: Request {
    
    typealias ReturnType = RecipeListResponse
    
    var path: String = "/recipes/random"
    var headers: [String : String]? = ["x-api-key": Environment.apiKey]
    var queryParams: [String : Any]? = [
        "number": "5",
        "tags": "mexican"
    ]
}
