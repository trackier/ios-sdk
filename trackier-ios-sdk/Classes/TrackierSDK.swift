//
//  TrackierSDK.swift
//  trackier-ios-sdk
//
//  Created by Prakhar Srivastava on 18/03/21.
//

import Foundation
import os
import StoreKit

public class TrackierSDK {
    private var isInitialized = false
    private var instance = TrackierSDKInstance()
    
    static let shared = TrackierSDK()
    
    private init() {}
    
    public static func initialize(config: TrackierSDKConfig) {
        if (shared.isInitialized) {
            Logger.warning(message: "SDK Already initialized!")
            return
        }
        shared.isInitialized = true
        Logger.info(message: "Trackier SDK \(Constants.SDK_VERSION) initialized")
        shared.instance.initialize(config: config)
    }

    public static func isEnabled() -> Bool {
        return shared.instance.isEnabled
    }

    public static func setEnabled(value : Bool) {
        shared.instance.isEnabled = value
    }
   
    public static func trackEvent(event: TrackierEvent) {
        if (!shared.isInitialized) {
            Logger.warning(message: "SDK Not Initialized")
            return
        }
        if (!isEnabled()) {
            Logger.warning(message: "SDK Disabled")
            return
        }
        shared.instance.trackEvent(event: event)
    }
    
    public static func trackSession() {
        if #available(iOS 13.0, *) {
            shared.instance.trackSession()
        }
    }
    
    public static func setMinSessionDuration(val: UInt64) {
        if val > 0 {
            shared.instance.minSessionDuration = Int64(val)
        }
    }
    
    public static func setUserID(userId: String) {
        shared.instance.customerId = userId
    }
    
    public static func setUserEmail(userEmail: String) {
        shared.instance.customerEmail = userEmail
    }
    
    public static func setUserAdditionalDetails(userAdditionalDetails: Dictionary<String, Any>) {
        shared.instance.customerOptionals = userAdditionalDetails
    }

    public static func trackAsOrganic(organic: Bool) {
        shared.instance.organic = organic
    }
    
    public static func setUserPhone(userPhone: String) {
        shared.instance.customerPhone = userPhone
    }
    
    public static func setUserName(userName: String) {
        shared.instance.customerName = userName
    }
    
    public static func setDeviceToken(deviceToken: String) {
        let getCacheToken = CacheManager.getString(key: Constants.SHARED_PREF_DEVICE_TOKEN)
        if (!getCacheToken.elementsEqual(deviceToken)) {
            shared.instance.deviceToken = deviceToken
            shared.instance.deviceTokenApns()
            CacheManager.setString(key: Constants.SHARED_PREF_DEVICE_TOKEN, value: deviceToken)
        }
    }
    
    public static func updatePostbackConversion(conversionValue: Int) {
        if #available(iOS 15.4, *) {
            SKAdNetwork.updatePostbackConversionValue(conversionValue) { error in
                if error != nil {
                    //print("Coneversion VALUE --  \(error.localizedDescription)")
                }
            }
        } else if #available(iOS 11.3, *), #available(iOS 14.0, *) {
            SKAdNetwork.updateConversionValue(conversionValue)
        }
    }
}
