//
//  SKANStorage.swift
//  
//
//  Created by Satyam Jha on 26/03/25.
//

import Foundation

/// Handles persistent storage of SKAN configuration
final class SKANStorage {
    static let shared = SKANStorage()
    private let fileManager = FileManager.default
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    
    private var cacheDirectory: URL {
        fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("com.trackier.skan")
    }
    
    func saveConfig(_ config: SKANConfig, aid: String) {
        let fileURL = cacheDirectory.appendingPathComponent("config_\(aid).json")
        
        do {
            try fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
            let data = try encoder.encode(config)
            try data.write(to: fileURL)
        } catch {
            Logger.error(message: "Failed to save SKAN config: \(error.localizedDescription)")
        }
    }
    
    func loadConfig(aid: String) -> SKANConfig? {
        let fileURL = cacheDirectory.appendingPathComponent("config_\(aid).json")
        
        guard let data = try? Data(contentsOf: fileURL) else {
            return nil
        }
        
        do {
            return try decoder.decode(SKANConfig.self, from: data)
        } catch {
            Logger.error(message: "Failed to decode SKAN config: \(error.localizedDescription)")
            return nil
        }
    }
}
