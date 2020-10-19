//
//  APIService.swift
//  Currencies
//
//  Created by Egor Bozko on 10/17/20.
//  Copyright © 2020 Egor Bozko. All rights reserved.
//

import Foundation

struct APILatestResponse: Codable {
    
    public let success: Bool
    public let base: String
    public let date: Date
    public let rates: [Rate]
    
    struct Rate: Codable {
        public let name: String
        public let value: Double
        public let localizedTitle: String
        
        var dictionary: [String: Double] {
            return [name : value]
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case success, base, date, rates
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        success = try container.decode(Bool.self, forKey: .success)
        base = try container.decode(String.self, forKey: .base)
        date = try container.decode(Date.self, forKey: .date)
        let r = try container.decode([String : Double].self, forKey: .rates)
        
        rates = r.map({ Rate(name: $0.key, value: $0.value, localizedTitle: Locale.getCurrencyName(for: $0.key)) }).sorted(by: {$0.name < $1.name})
    }
}

struct APICalculateResponse: Codable {
    public let success: Bool
    public let result: Double
}

final class Router {
    
    private(set) var baseAPIURL: String
    
    var latest: String { return urlWith(components: ["latest"])}
    var convert: String { return urlWith(components: ["convert"])}
    
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
    
    func loadCurrencies(completion: @escaping (Result<APILatestResponse, APIError>) -> Void) {
        guard let url = URL(string: router.latest) else {
            return
        }
        fetchResources(url: url, completion: completion)
    }
    
    func calculate(from: String, amount: String, completion: @escaping (Result<APICalculateResponse, APIError>) -> Void) {
        guard let url = URL(string: "\(router.convert)?from=\(from)&to=USD&amount=\(amount)") else {
            return
        }
        fetchResources(url: url, completion: completion)
    }
}
