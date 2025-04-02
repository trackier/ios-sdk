//
//  SkanService.swift
//  
//
//  Created by Satyam Jha on 26/03/25.
//


import Foundation

final class SKANNetworkService {
    static let shared = SKANNetworkService()
    private let session: URLSession
    
    // Hard-coded API key
    private let apiKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJvaWQiOiJBN3g3N0dnNHRpIiwidWlkIjoiNjQ4OTVlMDY2MjE0NDdmMzlhZmNhZTU4Iiwic3VpZCI6IjY3ODEwOTY5ZWE3MDZlYTAwZjNkMjE5YiIsImlhdCI6MTc0MzUwMDA3NCwiZXhwIjoxNzQzNTg2NDc0fQ.2pzrw2yECooszsgYoVAQAjhFmnzltPkPlh9yZDfQQW0" 

    init(session: URLSession = .shared) {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 60
        self.session = URLSession(configuration: configuration)
    }
    
    func fetchConfig(aid: String, baseURL: String, completion: @escaping (Result<SKANConfig, Error>) -> Void) {
        // Validate URL
        guard let url = URL(string: "\(baseURL)/skans/conversion_studios?aid=\(aid)") else {
            Logger.error(message: "Invalid URL constructed for SKAN config")
            completion(.failure(SKANError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        // Debug log the API key (masking most of it)
        let maskedKey = apiKey.isEmpty ? "Empty" : "*****" + apiKey.suffix(4)
        Logger.debug(message: "Attempting to fetch SKAN config with API Key: \(maskedKey)")
        
        // Add hard-coded API key header
        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")
        
        Logger.debug(message: """
        Making SKAN Config Request:
        URL: \(url.absoluteString)
        Headers: \(request.allHTTPHeaderFields ?? [:])
        """)
        
        let task = session.dataTask(with: request) { [weak self] data, response, error in
            // Handle network errors
            if let error = error {
                Logger.error(message: "Network error fetching SKAN config: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            // Validate HTTP response
            guard let httpResponse = response as? HTTPURLResponse else {
                Logger.error(message: "Invalid response received (not HTTP)")
                completion(.failure(SKANError.invalidResponse))
                return
            }
            
            Logger.debug(message: "Received response with status: \(httpResponse.statusCode)")
            
            // Handle unsuccessful status codes
            guard (200...299).contains(httpResponse.statusCode) else {
                // Try to extract error message from response body
                var errorMessage = "HTTP \(httpResponse.statusCode)"
                if let data = data, let body = String(data: data, encoding: .utf8) {
                    errorMessage += " - \(body)"
                    Logger.error(message: "Server error response: \(body)")
                }
                
                // Special handling for 401
                if httpResponse.statusCode == 401 {
                    Logger.error(message: "Authentication failed - please verify your API key")
                }
                
                completion(.failure(SKANError.serverError(statusCode: httpResponse.statusCode)))
                return
            }
            
            // Ensure data exists
            guard let data = data else {
                Logger.error(message: "No data received from server")
                completion(.failure(SKANError.noData))
                return
            }
            
            // Debug log raw response
            if let rawResponse = String(data: data, encoding: .utf8) {
                Logger.debug(message: "Raw SKAN config response: \(rawResponse)")
            }
            
            // Parse response
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                let apiResponse = try decoder.decode(SKANResponse.self, from: data)
                
                guard apiResponse.success else {
                    let message = apiResponse.message ?? "Unknown error"
                    Logger.error(message: "API reported failure: \(message)")
                    completion(.failure(SKANError.invalidResponse))
                    return
                }
                
                guard let config = apiResponse.data else {
                    Logger.error(message: "Missing data in successful response")
                    completion(.failure(SKANError.noData))
                    return
                }
                
                // Validate the config
                do {
                    try config.validate()
                    Logger.debug(message: "Successfully loaded and validated SKAN config")
                    completion(.success(config))
                } catch let validationError {
                    Logger.error(message: "SKAN config validation failed: \(validationError.localizedDescription)")
                    completion(.failure(validationError))
                }
                
            } catch let decodingError {
                Logger.error(message: "Failed to decode SKAN config: \(decodingError.localizedDescription)")
                completion(.failure(decodingError))
            }
        }
        
        task.resume()
    }
    
    @available(iOS 13.0, *)
    func fetchConfigAsync(aid: String, baseURL: String) async throws -> SKANConfig {
        return try await withCheckedThrowingContinuation { continuation in
            fetchConfig(aid: aid, baseURL: baseURL) { result in
                continuation.resume(with: result)
            }
        }
    }
}

struct SKANResponse: Codable {
    let success: Bool
    let data: SKANConfig?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case success
        case data
        case message
    }
}
