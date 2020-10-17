//
//  APIService.swift
//  Currencies
//
//  Created by Egor Bozko on 10/17/20.
//  Copyright © 2020 Egor Bozko. All rights reserved.
//

import Foundation

struct ApiResponse: Codable {
    public let success: Bool
    public let base: String
    public let date: String
    public let rates: [String]
}

struct Rate: Codable {
    public let name: String
    public let value: String
}

final class Router {
    
    private(set) var baseAPIURL: String
    
    var latest: String { return urlWith(components: ["latest"])}
    var calculate: String { return urlWith(components: ["calculate"])}
    
    init() {
        baseAPIURL = Bundle.apiURL()
    }
    
    func urlWith(path: String) -> String {
        return "\(baseAPIURL)/\(path)/"
    }
    
    func urlWith(components: [String]) -> String {
           let path = components.joined(separator: "/")
           return urlWith(path: path)
    }
}

class APIService {
    static let shared = APIService()
    
    public enum APIError: Error {
        case apiError, invalidURL, invalidResponse, noData, decodeError
    }
    
    let router = Router()
    
    private let session = URLSession.shared
    
    private let jsonDecoder: JSONDecoder = {
       let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-mm-dd"
        decoder.dateDecodingStrategy = .formatted(formatter)
        return decoder
    }()
    
    private func fetchResources<T: Decodable>(url: URL, completion: @escaping (Result<T, APIError>) -> Void) {
        session.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else {
                completion(.failure(.apiError))
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                completion(.failure(.invalidResponse))
                return
            }

            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let values = try self.jsonDecoder.decode(T.self, from: data)
                completion(.success(values))
            } catch {
                completion(.failure(.decodeError))
            }
        }.resume()
    }
    
    func loadCurrencies(completion: ApiResponse,  failure: ([Error?])) {
        
    }
    
    func calculateCurrencies() {
        
    }
}
