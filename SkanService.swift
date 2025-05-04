//
//  SkanService.swift
<<<<<<< HEAD
//  
=======
//
>>>>>>> cca9e48 (feat : fixed log issues)
//
//  Created by Satyam Jha on 26/03/25.
//

<<<<<<< HEAD

import Foundation

final class SKANNetworkService {
    static let shared = SKANNetworkService()
    private let session: URLSession
    
    // Hard-coded API key
    private let apiKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJvaWQiOiJBN3g3N0dnNHRpIiwidWlkIjoiNjQ4OTVlMDY2MjE0NDdmMzlhZmNhZTU4Iiwic3VpZCI6IjY3ODEwOTY5ZWE3MDZlYTAwZjNkMjE5YiIsImlhdCI6MTc0MzUwMDA3NCwiZXhwIjoxNzQzNTg2NDc0fQ.2pzrw2yECooszsgYoVAQAjhFmnzltPkPlh9yZDfQQW0" 

=======
import Foundation

// Singleton class to handle SKAdNetwork configuration fetching
final class SKANNetworkService {
    
    // Shared instance for global access
    static let shared = SKANNetworkService()
    
    private var appKeys: String {
        guard let key = TrackierSDK.getAppToken() else {
            Logger.error(message: "Trackier SDK not initialized or app token not available")
            return ""
        }
        return key
    }
    
    private let session: URLSession
    
>>>>>>> cca9e48 (feat : fixed log issues)
    init(session: URLSession = .shared) {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 60
        self.session = URLSession(configuration: configuration)
    }
    
<<<<<<< HEAD
    func fetchConfig(aid: String, baseURL: String, completion: @escaping (Result<SKANConfig, Error>) -> Void) {
        // Validate URL
        guard let url = URL(string: "\(baseURL)/skans/conversion_studios?aid=\(aid)") else {
            Logger.error(message: "Invalid URL constructed for SKAN config")
=======
    func fetchConfig(completion: @escaping (Result<SKANConfig, Error>) -> Void) {
        guard !appKeys.isEmpty else {
            completion(.failure(SKANError.configurationMissing))
            return
        }
        
        // Ensure the URL matches Postman and has no trailing slash
        let urlString = Constants.SKANURL.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        guard let url = URL(string: urlString) else {
            Logger.error(message: "Invalid SKAN URL from Constants: \(urlString)")
>>>>>>> cca9e48 (feat : fixed log issues)
            completion(.failure(SKANError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
<<<<<<< HEAD
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
=======
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("TrackierSDK/1.6.60 (iOS)", forHTTPHeaderField: "User-Agent")
        
        let body: [String: String] = ["appKey": appKeys]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: body, options: [])
            request.httpBody = jsonData
            request.setValue("\(jsonData.count)", forHTTPHeaderField: "Content-Length")
            Logger.debug(message: "Request body: \(String(data: jsonData, encoding: .utf8) ?? "Failed to decode body")")
        } catch {
            Logger.error(message: "Failed to serialize appKey JSON: \(error.localizedDescription)")
            completion(.failure(error))
            return
        }
        
        Logger.debug(message: "Attempting to fetch SKAN config with URL: \(url.absoluteString)")
        Logger.debug(message: "Request headers: \(request.allHTTPHeaderFields ?? [:])")
        
        let task = session.dataTask(with: request) { data, response, error in
>>>>>>> cca9e48 (feat : fixed log issues)
            if let error = error {
                Logger.error(message: "Network error fetching SKAN config: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
<<<<<<< HEAD
            // Validate HTTP response
=======
>>>>>>> cca9e48 (feat : fixed log issues)
            guard let httpResponse = response as? HTTPURLResponse else {
                Logger.error(message: "Invalid response received (not HTTP)")
                completion(.failure(SKANError.invalidResponse))
                return
            }
            
            Logger.debug(message: "Received response with status: \(httpResponse.statusCode)")
<<<<<<< HEAD
            
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
                
=======
            Logger.debug(message: "Response headers: \(httpResponse.allHeaderFields)")
            
            if let data = data, let rawResponse = String(data: data, encoding: .utf8) {
                Logger.debug(message: "Raw SKAN config response: \(rawResponse)")
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                Logger.error(message: "Server error with status code: \(httpResponse.statusCode)")
                if let data = data, let errorResponse = String(data: data, encoding: .utf8) {
                    Logger.error(message: "Error response body: \(errorResponse)")
                }
>>>>>>> cca9e48 (feat : fixed log issues)
                completion(.failure(SKANError.serverError(statusCode: httpResponse.statusCode)))
                return
            }
            
<<<<<<< HEAD
            // Ensure data exists
=======
>>>>>>> cca9e48 (feat : fixed log issues)
            guard let data = data else {
                Logger.error(message: "No data received from server")
                completion(.failure(SKANError.noData))
                return
            }
            
<<<<<<< HEAD
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
=======
            do {
                let decoder = JSONDecoder.skanDecoder
                let apiResponse = try decoder.decode(SKANResponse.self, from: data)
                Logger.debug(message: "Decoded API response - Success: \(apiResponse.success), Message: \(apiResponse.message ?? "none")")
                
                guard apiResponse.success, let config = apiResponse.data else {
                    Logger.error(message: "API reported failure: \(apiResponse.message ?? "Unknown error")")
>>>>>>> cca9e48 (feat : fixed log issues)
                    completion(.failure(SKANError.invalidResponse))
                    return
                }
                
<<<<<<< HEAD
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
=======
                try config.validate()
                Logger.debug(message: "Successfully fetched and validated config - ID: \(config.id), AID: \(config.aid)")
                completion(.success(config))
            } catch {
                Logger.error(message: "Failed to decode or validate SKAN config: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
}


>>>>>>> cca9e48 (feat : fixed log issues)
