//
//  TrackierSkanManager.swift
//  trackier-ios-sdk
//
//  Created by Satyam Jha on 01/04/25.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import Foundation
import trackier_ios_sdk

class SKANManager {
    static let shared = SKANManager()
    
    private init() {}
    
    func configureSKAN() {
        TrackierSDK.configureSKAN(
            aid: "YOUR_SKAN_AID",
            baseURL: "https://api.trackier.com/v2",
            minimumRevenueDelta: 0.5, // Only update if revenue changes by $0.50+
            maximumUpdateFrequency: 1800, // Max every 30 minutes
            automaticSessionTracking: true,
            debugMode: true // Enable in development
        )
        
        // Register for attribution (call once)
        TrackierSDK.registerSKAdNetwork()
    }
    
    func trackEvent(_ event: String, revenue: Double? = nil) {
        // Standard event tracking
        let trackierEvent = TrackierEvent(id: event)
        TrackierSDK.trackEvent(event: trackierEvent)
        
        // If revenue is associated, update SKAN conversion value
        if let revenue = revenue {
            updateConversion(revenue: revenue, eventId: event)
        }
    }
    
    func updateConversion(revenue: Double, eventId: String? = nil) {
        TrackierSDK.updateSKANConversion(
            revenue: revenue,
            eventId: eventId
        ) { success, error in
            if let error = error {
                print("SKAN update failed: \(error.localizedDescription)")
            } else {
                print("SKAN update succeeded")
                
                // Debug current values
                let (fine, coarse) = TrackierSDK.getCurrentSKANValues()
                print("Current SKAN values - Fine: \(fine ?? 0), Coarse: \(coarse ?? "none")")
            }
        }
    }
    
    @available(iOS 16.1, *)
    func testPostback() {
        guard let url = URL(string: "https://your-test-endpoint.com") else { return }
        
        TrackierSDK.testSKANPostback(url: url) { success, error in
            if success {
                print("SKAN test postback succeeded")
            } else if let error = error {
                print("SKAN test postback failed: \(error.localizedDescription)")
            }
        }
    }
}
