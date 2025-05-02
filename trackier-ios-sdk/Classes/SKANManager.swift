//
//  SKANManager.swift
//  
//
//  Created by Satyam Jha on 26/03/25.
//
// SKANManager.swift
import Foundation
import StoreKit

/// Central controller for all SKAdNetwork operations
final class SKANManager {
    static let shared = SKANManager()
    
    private var config: SKANConfig?
    private var currentValues: [Int: (fine: Int, coarse: SKANCoarseType)] = [:]
    private let networkService: SKANNetworkService
    private let storage: SKANStorage
    private let queue = DispatchQueue(label: "com.trackier.skan.queue", qos: .utility)
    
    init(networkService: SKANNetworkService = .shared,
         storage: SKANStorage = .shared) {
        self.networkService = networkService
        self.storage = storage
    }
    
    // MARK: - Public Interface
    
    /// Configures SKAN with account ID and fetches conversion mapping
    func configure(aid: String, baseURL: String) {
        queue.async { [weak self] in
            self?.loadConfig(aid: aid, baseURL: baseURL)
        }
    }
    
    /// Registers for SKAdNetwork attribution
    func registerForAttribution() {
        SKAdNetwork.registerAppForAdNetworkAttribution()
    }
    
    /// Updates conversion values based on revenue and event
    func updateConversionValue(revenue: Double, eventId: String? = nil) {
        queue.async { [weak self] in
            guard let self = self, let config = self.config else { return }
            
            for window in config.windows {
                self.updateWindowValues(window: window, revenue: revenue, eventId: eventId)
            }
            
            self.updateSystemConversionValues()
        }
    }
    
    /// Tests SKAdNetwork postback (iOS 16.1+)
    @available(iOS 16.1, *)
    func testPostback(url: URL, completion: @escaping (Bool, Error?) -> Void) {
        SKAdNetwork.testPostbackRequest(withServerURL: url) { error in
            DispatchQueue.main.async {
                completion(error == nil, error)
            }
        }
    }
    
    // MARK: - Private Implementation
    
    private func loadConfig(aid: String, baseURL: String) {
        // Try loading cached config first
        if let cachedConfig = storage.loadConfig(aid: aid) {
            self.config = cachedConfig
            Logger.debug(message: "Loaded cached SKAN config")
            return
        }
        
        // Fetch from network if no cache
        networkService.fetchConfig(aid: aid, baseURL: baseURL) { [weak self] result in
            switch result {
            case .success(let config):
                self?.config = config
                self?.storage.saveConfig(config, aid: aid)
                Logger.debug(message: "Successfully loaded SKAN config")
            case .failure(let error):
                Logger.error(message: "Failed to load SKAN config: \(error.localizedDescription)")
            }
        }
    }
    
    private func updateWindowValues(window: SKANWindow, revenue: Double, eventId: String?) {
        // Update fine value if revenue falls in range
        if let fineValue = window.fineValues?.first(where: {
            revenue >= $0.revenueStart && revenue <= $0.revenueEnd
        }) {
            currentValues[window.index] = (fineValue.value, currentValues[window.index]?.coarse ?? .low)
        }
        
        // Update coarse value if revenue falls in range or matches event
        if let coarseValue = window.coarseValues?.first(where: {
            revenue >= $0.revenueStart && revenue <= $0.revenueEnd ||
            eventId == $0.eventId
        }) {
            currentValues[window.index] = (currentValues[window.index]?.fine ?? 0, coarseValue.type)
        }
    }
    
    private func updateSystemConversionValues() {
        guard let window1Values = currentValues[1] else { return }
        
        if #available(iOS 15.4, *) {
            SKAdNetwork.updatePostbackConversionValue(
                window1Values.fine,
                coarseValue: window1Values.coarse.skAdNetworkValue,
                lockWindow: false
            )
        } else if #available(iOS 14.0, *) {
            SKAdNetwork.updateConversionValue(window1Values.fine)
        }
    }
}
