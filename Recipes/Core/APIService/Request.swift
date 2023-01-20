//
//  Request.swift
//  Recipes
//
//

import Foundation

// MARK: Request
protocol Request {
    
    associatedtype ReturnType: Codable
    
    var path: String { get }
    var method: HTTPMethod { get }
    var contentType: String { get }
    var queryParams: [String: Any]? { get }
    var body: [String: Any]? { get }
    var headers: [String: String]? { get }
}

extension Request {
    
    // Defaults
    var method: HTTPMethod { .get }
    var contentType: String { "application/json" }
    var queryParams: [String: Any]? { nil }
    var body: [String: Any]? { nil }
    var headers: [String: String]? { nil }
    
    /// Serializes an HTTP dictionary to a JSON Data Object
    /// - Parameter params: HTTP Parameters dictionary
    /// - Returns: Encoded JSON
    
    private func requestBodyFrom(params: [String: Any]?) -> Data? {
        guard let params = params else { return nil }
        guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else {
            return nil
        }
        return httpBody
    }
    
    /// Generates a URLQueryItems array from a Params dictionary
    /// - Parameter params: HTTP Parameters dictionary
    /// - Returns: An Array of URLQueryItems
    private func queryItemsFrom(params: [String: Any]?) -> [URLQueryItem]? {
        guard let params = params else { return nil }
        return params.map {
            URLQueryItem(name: $0.key, value: $0.value as? String)
        }
    }
    
    /// Transforms an Request into a standard URL request
    /// - Parameter baseURL: API Base URL to be used
    /// - Returns: A ready to use URLRequest
    
    func asURLRequest(baseURL: String) -> URLRequest? {
        
        guard var urlComponents = URLComponents(string: baseURL) else { return nil }
        urlComponents.path = "\(urlComponents.path)\(path)"
        urlComponents.queryItems = queryItemsFrom(params: queryParams)
        guard let finalURL = urlComponents.url else { return nil }
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = method.rawValue
        request.httpBody = requestBodyFrom(params: body)
        request.allHTTPHeaderFields = headers
        return request
    }
}
