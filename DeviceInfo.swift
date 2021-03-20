//
//  DeviceInfo.swift
//  trackier-ios-sdk
//
//  Created by Prakhar Srivastava on 19/03/21.
//  Modified by Hemant Mann
//

import Foundation

class DeviceInfo {
    
    let buildInfo = Bundle.main.infoDictionary
    var name = UIDevice.current.name
    var systemName = UIDevice.current.systemName
    var systemVersion = UIDevice.current.systemVersion
    var model = UIDevice.current.model
    var batteryLevel = UIDevice.current.batteryLevel
    var isBatteryMonitoringEnabled = UIDevice.current.isBatteryMonitoringEnabled
    
    public func getDeviceInfo() -> Dictionary<String, Any> {
        var dict = Dictionary<String, Any>()
        #if os(iOS)
        dict["osName"] = "iOS"
        #elseif os(watchOS)
        dict["osName"] = "watchOS"
        #elseif os(tvOS)
        dict["osName"] = "tvOS"
        #endif
        
        dict["name"] = name
        dict["buildName"] = buildInfo?["BuildMachineOSBuild"]
        dict["osVersion"] = systemVersion
        dict["manufacturer"] = "Apple"
        dict["hardwareName"] = systemName
        dict["model"] = model
        dict["apiLevel"] = buildInfo?["DTPlatformBuild"]
        dict["brand"] = model
        dict["packageName"] = buildInfo?["CFBundleIdentifier"]
        dict["appVersion"] = buildInfo?["CFBundleShortVersionString"]
        dict["appNumericVersion"] = buildInfo?["CFBundleNumericVersion"]
        dict["sdkVersion"] = Constants.SDK_VERSION
        dict["language"] = Locale.current.languageCode
        dict["country"] = NSLocale.current.regionCode
        dict["timezone"] = TimeZone.current.identifier
        // TODO: screenSize,screenDensity?
        dict["batteryLevel"] = batteryLevel
        dict["ibme"] = isBatteryMonitoringEnabled
        let platformName: Any? = buildInfo?["DTPlatformName"]
        if platformName != nil && Utils.isEqual(type: String.self, a: platformName!, b: "iphonesimulator") {
            dict["isEmulator"] = true
        } else {
            dict["isEmulator"] = false
        }
        return dict
    }
}
