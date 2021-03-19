//
//  TrackierSDK.swift
//  trackier-ios-sdk
//
//  Created by Prakhar Srivastava on 18/03/21.
//

import Foundation
import os

public class TrackierSDK{
    
    private static  var isInitialized = false
    private var instance = TrackierSDKInstance()
    
    
    public static func initialize() {
        if (isInitialized) {
          //  os_log("SDK Already initialized", log: OSLog.default, type: .info)
            os_log("SDK Already initialized", log: Log.prod, type: .info)
            return
        }
        isInitialized = true
        os_log("Trackier SDK ${Constants.SDK_VERSION} initialized", log: Log.prod, type: .info)
       //instance.initialize(config)
    }

    static func isEnabled() -> Bool{
       // return instance.isEnabled
         return false
    }

    func setEnabled(value : Bool) {
       // instance.isEnabled = value
    }

   
    static func trackEvent() {
        if (!isInitialized) {
            os_log("SDK Not Initialized", log: Log.prod, type: .info)
            return
        }
        if (!isEnabled()) {
            os_log("SDK Disabled", log: Log.prod, type: .info)
            return
        }
       // instance.trackEvent(event)
    }
    
}
