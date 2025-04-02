//
//  SKANManager.swift
//  
//
//  Created by Satyam Jha on 26/03/25.
//



import Foundation
import StoreKit

final class SKANManager {
    static let shared = SKANManager()
    
    struct Configuration {
        var minimumRevenueDelta: Double = 1.0
        var maximumUpdateFrequency: TimeInterval = 3600
        var automaticSessionTracking: Bool = true
        var debugMode: Bool = false
    }
    
    private var config: SKANConfig?
    private var configuration = Configuration()
    private var currentValues: [Int: SKANCurrentValues] = [
        1: SKANCurrentValues(),
        2: SKANCurrentValues(),
        3: SKANCurrentValues()
    ]
    
    private let networkService: SKANNetworkService
    private let storage: SKANStorage
    private let queue = DispatchQueue(label: "com.trackier.skan.queue", qos: .utility)
    private var isFirstAppLaunch: Bool = true
    private var lastRevenueValue: Double = 0
    private var lastEventId: String?
    
    init(networkService: SKANNetworkService = .shared, storage: SKANStorage = .shared) {
        self.networkService = networkService
        self.storage = storage
    }
    
    func configure(aid: String, baseURL: String, config: Configuration = Configuration()) {
        self.configuration = config
        loadConfig(aid: aid, baseURL: baseURL)
        
        if configuration.automaticSessionTracking {
            startSessionTracking()
        }
    }
    
    func registerForAttribution() {
        if #available(iOS 14.0, *) {
            SKAdNetwork.registerAppForAdNetworkAttribution()
            logDebug("Registered for SKAdNetwork attribution")
        }
    }
    
    func updateConversionValue(revenue: Double, eventId: String? = nil, completion: ((Bool, Error?) -> Void)? = nil) {
        let now = Date()
        
        // Check if we should skip this update
        if let lastUpdate = currentValues[1]?.lastUpdated,
           now.timeIntervalSince(lastUpdate) < configuration.maximumUpdateFrequency,
           abs(revenue - lastRevenueValue) < configuration.minimumRevenueDelta,
           eventId == lastEventId {
            logDebug("Skipping SKAN update - too frequent or insignificant change")
            completion?(false, SKANError.updateTooFrequent)
            return
        }
        
        queue.async { [weak self] in
            guard let self = self else { return }
            
            self.lastRevenueValue = revenue
            self.lastEventId = eventId
            
            guard let config = self.config else {
                self.logError("SKAN not configured")
                DispatchQueue.main.async {
                    completion?(false, SKANError.configurationMissing)
                }
                return
            }
            
            self.updateWindow(window: config.window1, index: 1, revenue: revenue, eventId: eventId)
            self.updateWindow(window: config.window2, index: 2, revenue: revenue, eventId: eventId)
            self.updateWindow(window: config.window3, index: 3, revenue: revenue, eventId: eventId)
            
            self.updateSystemConversionValues(completion: completion)
        }
    }
    
    func getCurrentValues() -> (fine: Int?, coarse: String?) {
        let window1 = currentValues[1]
        return (window1?.fine, window1?.coarse?.rawValue)
    }
    
    @available(iOS 16.1, *)
    func testPostback(url: URL, completion: @escaping (Bool, Error?) -> Void) {
        queue.async { [weak self] in
            guard let self = self, let window1 = self.currentValues[1] else {
                self?.logError("Test postback failed: SKAN not configured or no values")
                DispatchQueue.main.async {
                    completion(false, SKANError.configurationMissing)
                }
                return
            }
            
            let fineValue = window1.fine ?? 0
            let coarseValue = window1.coarse?.rawValue ?? "none"
            
            self.logDebug("""
            Simulated SKAN postback to \(url):
            - Fine value: \(fineValue)
            - Coarse value: \(coarseValue)
            - Lock window: \(window1.lock)
            """)
            
            DispatchQueue.main.async {
                completion(true, nil)
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func startSessionTracking() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    @objc private func appDidBecomeActive() {
        if isFirstAppLaunch {
            isFirstAppLaunch = false
            updateConversionValue(revenue: 0, eventId: "first_open")
        } else {
            updateConversionValue(revenue: lastRevenueValue, eventId: "session_start")
        }
    }
    
    private func loadConfig(aid: String, baseURL: String) {
        if let cachedConfig = storage.loadConfig(aid: aid) {
            self.config = cachedConfig
            logDebug("Loaded cached SKAN config for aid: \(aid)")
            return
        }
        
        networkService.fetchConfig(aid: aid, baseURL: baseURL) { [weak self] result in
            switch result {
            case .success(let config):
                do {
                    try config.validate()
                    self?.config = config
                    self?.storage.saveConfig(config, aid: aid)
                    self?.logDebug("Fetched and validated SKAN config for aid: \(aid)")
                } catch {
                    self?.logError("SKAN config validation failed: \(error.localizedDescription)")
                }
            case .failure(let error):
                self?.logError("Failed to fetch SKAN config: \(error.localizedDescription)")
            }
        }
    }
    
    private func updateWindow(window: SKANWindow, index: Int, revenue: Double, eventId: String?) {
        guard index >= 1 && index <= 3 else { return }
        
        var currentValue = currentValues[index] ?? SKANCurrentValues()
        
        if index == 1, let fineValues = window.fineValues {
            if let fine = fineValues.first(where: { $0.matches(eventId: eventId, revenue: revenue) }) {
                currentValue.fine = fine.value
            }
        }
        
        if let coarseValues = window.coarseValues,
           let coarse = coarseValues.first(where: { $0.matches(eventId: eventId, revenue: revenue) }) {
            currentValue.coarse = coarse.type
            currentValue.lock = window.shouldLock
        }
        
        currentValue.lastUpdated = Date()
        currentValues[index] = currentValue
    }
    
    private func updateSystemConversionValues(completion: ((Bool, Error?) -> Void)? = nil) {
        guard let window1 = currentValues[1] else {
            completion?(false, SKANError.noValuesSet)
            return
        }
        
        let fineValue = window1.fine ?? 0
        let coarseValue = window1.coarse ?? .low
        let lockWindow = window1.lock
        
        if #available(iOS 16.1, *) {
            SKAdNetwork.updatePostbackConversionValue(
                fineValue,
                coarseValue: coarseValue.skAdNetworkValue,
                lockWindow: lockWindow
            ) { [weak self] error in
                if let error = error {
                    self?.logError("SKAN update failed: \(error.localizedDescription)")
                    completion?(false, error)
                } else {
                    self?.logDebug("SKAN updated successfully (iOS 16.1+)")
                    completion?(true, nil)
                }
            }
        } else if #available(iOS 15.4, *) {
            SKAdNetwork.updatePostbackConversionValue(fineValue) { [weak self] error in
                if let error = error {
                    self?.logError("SKAN update failed: \(error.localizedDescription)")
                    completion?(false, error)
                } else {
                    self?.logDebug("SKAN updated (iOS 15.4)")
                    completion?(true, nil)
                }
            }
        } else if #available(iOS 14.0, *) {
            SKAdNetwork.updateConversionValue(fineValue)
            logDebug("SKAN updated (iOS 14.0)")
            completion?(true, nil)
        } else {
            completion?(false, SKANError.unsupportediOSVersion)
        }
        
        if let aid = config?.aid {
            storage.saveLastUpdateTimestamp(Date(), aid: aid)
        }
    }
    
    private func logDebug(_ message: String) {
        if configuration.debugMode {
            Logger.debug(message: "[SKAN Debug] \(message)")
        }
    }
    
    private func logError(_ message: String) {
        Logger.error(message: "[SKAN Error] \(message)")
    }
}
