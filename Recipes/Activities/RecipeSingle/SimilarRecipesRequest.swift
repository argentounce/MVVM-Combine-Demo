//
//  SimilarRecipesRequest.swift
//  Recipes
//
//

import Foundation

struct SimilarRecipesRequest: Request {
    
    typealias ReturnType = [SimilarRecipe]
    
    private let id: Int
    private let count: Int
    
    var path: String {
        "/recipes/\(id)/similar"
    }
    
    var headers: [String : String]? = [
        "x-api-key": Environment.apiKey
    ]
    
    var queryParams: [String : Any]? {
        [
           "number": "\(count)"
        ]
    }
    
    init(id:Int, count: Int = 3) {
        self.id = id
        self.count = count
    }
}
