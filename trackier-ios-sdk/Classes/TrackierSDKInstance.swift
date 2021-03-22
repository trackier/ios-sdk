//
//  TrackierSDKInstance.swift
//  trackier-ios-sdk
//
//  Created by Prakhar Srivastava on 18/03/21.
//

import Foundation
import os

class TrackierSDKInstance {
    
    var config = TrackierSDKConfig(appToken: "", env: "")
    var appToken: String = ""
    
    init() {}

    var isEnabled = true
    var isInitialized = false
    var minSessionDuration: Int64 = 10 // in seconds
    var idfa: String? = ""
    var installId = ""
    let deviceInfo = DeviceInfo()
    
    /**
     * Initialize method should be called to initialize the sdk
     */
    public func initialize(config: TrackierSDKConfig) {
        if self.isInitialized {
            return
        }
        self.config = config
        self.isInitialized = true
        self.appToken = config.appToken
        self.installId = getInstallID()

        DispatchQueue.global().async {
            self.trackInstall()
            self.trackSession()
        }
    }

    private func setInstallID(installID: String) {
        CacheManager.setString(key: Constants.SHARED_PREF_INSTALL_ID, value: installID)
    }

    private func getInstallID() -> String {
        return CacheManager.getString(key: Constants.SHARED_PREF_INSTALL_ID)
    }

    private func isInstallTracked() -> Bool {
        return CacheManager.getBool(key: Constants.SHARED_PREF_IS_INSTALL_TRACKED)
    }

    private func setInstallTracked() {
        CacheManager.setBool(key: Constants.SHARED_PREF_IS_INSTALL_TRACKED, value: true)
    }
    
    private func getLastSessionTime() -> Int64 {
        return CacheManager.getInt(key: Constants.SHARED_PREF_LAST_SESSION_TIME)
    }

    private func setLastSessionTime(val: Int64){
        CacheManager.setInt(key: Constants.SHARED_PREF_LAST_SESSION_TIME, value: val)
    }

    private  func trackInstall() {
        if (isInstallTracked()) {
            return
        }
        var installId = getInstallID()
        if installId == "" {
            installId = UUID().uuidString
            setInstallID(installID: installId)
        }
        let wrk = TrackierWorkRequest(kind: TrackierWorkRequest.KIND_INSTALL, appToken: self.appToken, mode: self.config.env)
        wrk.installId = installId
        wrk.deviceInfo = deviceInfo
        APIManager.doWork(workRequest: wrk)
        setInstallTracked()
    }

    func trackEvent(event: TrackierEvent) {
        if (!isEnabled) {
            os_log("SDK Not Enabled", log: Log.dev, type: .debug)
            return
        }
        if (!isInitialized) {
            os_log("SDK Not Initialized", log: Log.dev, type: .debug)
        }
        if (!isInstallTracked()) {
            os_log("Event sent before Install was tracked", log: Log.dev, type: .debug)
            return
        }
        let wrk = TrackierWorkRequest(kind: TrackierWorkRequest.KIND_EVENT, appToken: self.appToken, mode: self.config.env)
        wrk.installId = installId
        wrk.eventObj = event
        wrk.deviceInfo = deviceInfo
        DispatchQueue.global().async {
            APIManager.doWork(workRequest: wrk)
        }
    }
    
    func trackSession() {
        if (!isEnabled) {
            os_log("SDK Not Enabled", log: Log.dev, type: .debug)
            return
        }
        if (!isInitialized) {
            os_log("SDK Not Initialized", log: Log.dev, type: .debug)
        }
        let wrk = TrackierWorkRequest(kind: TrackierWorkRequest.KIND_SESSION, appToken: self.appToken, mode: self.config.env)
        wrk.installId = installId
        wrk.deviceInfo = deviceInfo
        let lastSessionTime = getLastSessionTime()
        wrk.lastSessionTime = Utils.convertUnixTsToISO(ts: lastSessionTime)
        let currentSessionTime = Int64(Date().timeIntervalSince1970)
        if (currentSessionTime - lastSessionTime) < self.minSessionDuration {
            // Session duration is too low
            return
        }
        DispatchQueue.global().async {
            APIManager.doWork(workRequest: wrk)
            self.setLastSessionTime(val: currentSessionTime)
        }
    }
}
