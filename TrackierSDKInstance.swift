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
//            val prefs = Util.getSharedPref(this.config.context)
//            prefs.edit().putString(Constants.SHARED_PREF_INSTALL_ID, installID)
//                    .apply()
    }

    private func getInstallID() -> String {
//        var installId = Util.getSharedPrefString(this.config.context, Constants.SHARED_PREF_INSTALL_ID)
//        if(installId.isBlank()){
//            installId = UUID.randomUUID().toString()
//            setInstallID(installId)
//        }
        return installId
    }

       private func isInstallTracked() -> Bool {
//           return try {
//               val prefs = Util.getSharedPref(this.config.context)
//               prefs.getBoolean(Constants.SHARED_PREF_IS_INSTALL_TRACKED, false)
//           } catch (ex: Exception) {
//               false
//           }
        return true
       }

       private func setInstallTracked() {
//           val prefs = Util.getSharedPref(this.config.context)
//           prefs.edit().putBoolean(Constants.SHARED_PREF_IS_INSTALL_TRACKED, true).apply()
       }

       private  func trackInstall() {
//           if (isInstallTracked()) {
//               return
//           }
//           if (config.isApkTrackingEnabled()) {
//               // TODO: implement APK tracking logic
//           }
//           if (!isReferrerStored()) {
//               val installRef = InstallReferrer(this.config.context)
//               val refDetails = installRef.getRefDetails()
//               this.setReferrerDetails(refDetails)
//           }
//           val wrkRequest = makeWorkRequest(TrackierWorkRequest.KIND_INSTALL)
//           TrackierWorkRequest.enqueue(wrkRequest)
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
