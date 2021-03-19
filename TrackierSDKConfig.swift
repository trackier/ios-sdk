//
//  TrackierSDKConfig.swift
//  trackier-ios-sdk
//
//  Created by Prakhar Srivastava on 18/03/21.
//

import Foundation

class TrackierSDKConfi {
    private var enableApkTracking = false
   // private val logger: Logger

    init( val appToken: String, val env: String) {
//        context = context.applicationContext
//        val level = if (env == Constants.ENV_PRODUCTION) Level.SEVERE else Level.FINEST
//        Factory.setLogLevel(level)
//        logger = Factory.logger
    }


    func setLogLevel() {
        //Factory.setLogLevel(value)
    }

    func setApkTracking(value: Bool) {
       // enableApkTracking = value
    }

    func isApkTrackingEnabled() -> Bool {
        return enableApkTracking
    }
}
