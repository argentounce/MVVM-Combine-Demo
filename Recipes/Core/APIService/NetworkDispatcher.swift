//
//  NetworkDispatcher.swift
//  Recipes
//
//

import Foundation
import Combine

struct NetworkDispatcher {
    
    private let urlSession: URLSession
    
    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    func dispatch<ReturnType: Codable>(request: URLRequest) -> AnyPublisher<ReturnType, NetworkRequestError> {
        
        return urlSession
            .dataTaskPublisher(for: request)
            .tryMap({ data, response in
                if let response = response as? HTTPURLResponse,
                   !(200...299).contains(response.statusCode) {
                    throw httpError(response.statusCode)
                }
                return data
            })
            .decode(type: ReturnType.self, decoder: JSONDecoder())
            .mapError { error in
                print(error.localizedDescription)
                return handleError(error)
            }
            .eraseToAnyPublisher()
    }
    
    func dispatch<ReturnType: Codable>(request: URLRequest, completion: @escaping (Result<ReturnType, NetworkRequestError>) -> Void) {
        
        urlSession.dataTask(with: request) { data, response, error in
            
            if let error = error {
                completion(.failure(handleError(error)))
            }
            
            if let response = response as? HTTPURLResponse,
               !(200...299).contains(response.statusCode) {
                completion(.failure(httpError(response.statusCode)))
            }
            
            guard let data = data else {
                completion(.failure(.badRequest))
                return
            }
            
            guard let response = try? JSONDecoder().decode(ReturnType.self, from: data) else {
                completion(.failure(.decodingError))
                return
            }
            
            completion(.success(response))
            
        }.resume()
        
    }
    
    private func httpError(_ statusCode: Int) -> NetworkRequestError {
        switch statusCode {
        case 400: return .badRequest
        case 401: return .unauthorized
        case 403: return .forbidden
        case 404: return .notFound
        case 402, 405...499: return .error4xx(statusCode)
        case 500: return .serverError
        case 501...599: return .error5xx(statusCode)
        default: return .unknownError
        }
    }

    private func handleError(_ error: Error) -> NetworkRequestError {
        switch error {
        case is Swift.DecodingError:
            return .decodingError
        case let urlError as URLError:
            return .urlSessionFailed(urlError)
        case let error as NetworkRequestError:
            return error
        default:
            return .unknownError
        }
    }
}
