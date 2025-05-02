//
//  SkanService.swift
//  
//
//  Created by Satyam Jha on 26/03/25.
//

import Foundation

/// Handles network operations for SKAN configuration
final class SKANNetworkService {
    static let shared = SKANNetworkService()
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchConfig(aid: String, baseURL: String, completion: @escaping (Result<SKANConfig, Error>) -> Void) {
        let url = URL(string: "\(baseURL)/skans/conversion_studios?aid=\(aid)")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(SKANError.noData))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(SKANResponse.self, from: data)
                if response.success, let config = response.data {
                    completion(.success(config))
                } else {
                    completion(.failure(SKANError.invalidResponse))
                }
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

struct SKANResponse: Codable {
    let success: Bool
    let data: SKANConfig?
    let message: String?
}

enum SKANError: Error {
    case noData
    case invalidResponse
    case configurationMissing
}
