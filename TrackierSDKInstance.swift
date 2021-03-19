//
//  TrackierSDKInstance.swift
//  trackier-ios-sdk
//
//  Created by Prakhar Srivastava on 18/03/21.
//

import Foundation

class TrackierSDKInstance {
    
    var config: TrackierSDKConfig? = nil
    var appToken: String = ""
    
    init() {}
    
//    private var device = DeviceInfo()


    var isEnabled = true
    var isInitialized = false
    var configLoaded = false
    var gaid: String? = ""
    var isLAT = false
    var installId = ""
    
    /**
     * Initialize method should be called to initialize the sdk
     */
    public func initialize(config: TrackierSDKConfig) {
        if self.isInitialized {
            return
        }
        self.isInitialized = true
        self.config = config
        self.appToken = config.appToken
        //this.installId = getInstallID()
        // DeviceInfo.init(device, this.config.context)

        DispatchQueue.global().async { //Swift sample
            sleep(1) //emulates heavy operation, delay 1 second
            self.initIdfa()
            self.initAttributionInfo()
            self.trackInstall()
        }
    }
    
    private  func initIdfa() {
        // TODO: fix me, get idfa for ios < 14
    }

    private  func initAttributionInfo() {
        isInitialized = true
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
        // TODO: fix me
        setInstallTracked()
    }

    func trackEvent(event: TrackierEvent) {
       if (!isEnabled || !configLoaded) {
           return
       }
       if (!isInitialized) {
       }
        // TODO: Fix me
   }
}
