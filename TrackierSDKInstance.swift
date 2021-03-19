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
    
//    private var device = DeviceInfo()

    var isEnabled = true
    var isInitialized = false
    var idfa: String? = ""
    var isLAT = false
    var installId = ""
    
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
        // DeviceInfo.init(device, this.config.context)

        DispatchQueue.global().async {
            self.trackInstall()
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
        let wrk = TrackierWorkRequest(kind: TrackierWorkRequest.KIND_EVENT, appToken: self.appToken, mode: self.config.env)
        wrk.installId = installId
        wrk.eventObj = event
        DispatchQueue.global().async {
            APIManager.doWork(workRequest: wrk)
        }
    }
}
