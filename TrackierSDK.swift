//
//  TrackierSDK.swift
//  trackier-ios-sdk
//
//  Created by Prakhar Srivastava on 18/03/21.
//

import Foundation
import os

public class TrackierSDK {
    private var isInitialized = false
    private var instance = TrackierSDKInstance()
    
    static let shared = TrackierSDK()
    
    private init() {}
    
    public static func initialize(config: TrackierSDKConfig) {
        if (shared.isInitialized) {
            os_log("SDK Already initialized!", log: Log.prod, type: .info)
            return
        }
        shared.isInitialized = true
        os_log("Trackier SDK %@ initialized", log: Log.prod, type: .info, Constants.SDK_VERSION)
        shared.instance.initialize(config: config)
    }

    static func isEnabled() -> Bool {
        return shared.instance.isEnabled
    }

    static func setEnabled(value : Bool) {
        shared.instance.isEnabled = value
    }
   
    static func trackEvent(event: TrackierEvent) {
        if (!shared.isInitialized) {
            os_log("SDK Not Initialized", log: Log.prod, type: .info)
            return
        }
        if (!isEnabled()) {
            os_log("SDK Disabled", log: Log.prod, type: .info)
            return
        }
        shared.instance.trackEvent(event: event)
    }
}
