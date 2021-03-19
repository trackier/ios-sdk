//
//  TrackierSDKInstance.swift
//  trackier-ios-sdk
//
//  Created by Prakhar Srivastava on 18/03/21.
//

import Foundation

class TrackierSDKInstance {
    
      //private val device = DeviceInfo()
      //lateinit var config: TrackierSDKConfig
      //private var refDetails: RefererDetails? = null
      private var appToken: String = ""

      var isEnabled = true
      var isInitialized = false
      var configLoaded = false
      var gaid: String? = ""
      var isLAT = false
      var installId = ""
    
        /**
        * Initialize method should be called to initialize the sdk
        */
       func initialize() {
           if (true) {
               return
           }
          // this.config = config
           //this.configLoaded = true
          // appToken = this.config.appToken
           //this.installId = getInstallID()
          // DeviceInfo.init(device, this.config.context)
        
        DispatchQueue.global().async { //Swift sample
          sleep(1) //emulates heavy operation, delay 1 second
            self.initGaid()
            self.initAttributionInfo()
            self.trackInstall()
         }
       }
    
    private  func initGaid() {
//        val (gaid, isLat) = DeviceInfo.getGAID(this.config.context)
//        this.gaid = gaid
//        this.isLAT = isLat
    }

    private  func initAttributionInfo() {
        isInitialized = true
    }

    private func isReferrerStored() -> Bool {
//        val url = Util.getSharedPrefString(this.config.context, Constants.SHARED_PREF_INSTALL_URL)
        return true
    }

    private func getReferrerDetails() {
//        if (refDetails != null) {
//            return refDetails!!
//        }
//        var url = Util.getSharedPrefString(this.config.context, Constants.SHARED_PREF_INSTALL_URL)
//        val clickTime = Util.getSharedPrefString(this.config.context, Constants.SHARED_PREF_CLICK_TIME)
//        val installTime = Util.getSharedPrefString(this.config.context, Constants.SHARED_PREF_INSTALL_TIME)
//        if (url.isBlank()) {
//            url = RefererDetails.ORGANIC_REF
//        }
//        refDetails = RefererDetails(url, clickTime, installTime)
//        return true
    }

    private func setReferrerDetails() {
//        refDetails = refererDetails
//        val prefs = Util.getSharedPref(this.config.context)
//        prefs.edit().putString(Constants.SHARED_PREF_INSTALL_URL, refererDetails.url)
//            .putString(Constants.SHARED_PREF_CLICK_TIME, refererDetails.clickTime)
//            .putString(Constants.SHARED_PREF_INSTALL_TIME, refererDetails.installTime)
//            .apply()
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
    
    private func makeWorkRequest(kind: String){
//           val trackierWorkRequest = TrackierWorkRequest(kind, appToken, this.config.env)
//           trackierWorkRequest.device = device
//           trackierWorkRequest.gaid = gaid
//           trackierWorkRequest.refDetails = getReferrerDetails()
//           trackierWorkRequest.installID = installId
//           return trackierWorkRequest
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

       private func _trackEvent() {
//           val wrkRequest = makeWorkRequest(TrackierWorkRequest.KIND_EVENT)
//           wrkRequest.event = event
//           TrackierWorkRequest.enqueue(wrkRequest)
       }

       func trackEvent() {
//           if (!isEnabled || !configLoaded) {
//               return
//           }
//           if (!isInitialized) {
//               Factory.logger.warning("Event Tracking request sent before SDK data was initialized")
//           }
//           if (!isInstallTracked()) {
//               CoroutineScope(Dispatchers.IO).launch {
//                   for (i in 1..5) {
//                       delay(1000 * i.toLong())
//                       if (isInstallTracked()) {
//                           _trackEvent(event)
//                           break
//                       }
//                   }
//               }
//           } else {
//               _trackEvent(event)
//           }
//
//       }
    
   }
}
