//
//  TrackierSDKConfig.swift
//  trackier-ios-sdk
//
//  Created by Prakhar Srivastava on 18/03/21.
//

import Foundation

public class TrackierSDKConfig {
    public static let ENVIRONMENT_PRODUCTION = Constants.ENV_PRODUCTION
    public static let ENV_DEVELOPMENT = Constants.ENV_DEVELOPMENT
    public static let ENV_TESTING = Constants.ENV_TESTING
    
    var appToken: String
    var env: String
    var secretId: String = ""
    var secretKey: String = ""
    var sdkt: String = "ios"
    var sdkVersion: String = Constants.SDK_VERSION

    public init(appToken: String, env: String) {
        self.appToken = appToken
        self.env = env
        if env == TrackierSDKConfig.ENVIRONMENT_PRODUCTION {
            Logger.setLogLevel(level: Logger.LEVEL_ERROR)
        } else {
            Logger.setLogLevel(level: Logger.LEVEL_DEBUG)
        }
    }
    
    public func setAppSecret(secretId: String, secretKey: String) {
        self.secretId = secretId
        self.secretKey = secretKey
    }
    
    func getAppSecretId() -> String {
        return self.secretId
    }
    
    func getAppSecretKey() -> String {
        return self.secretKey
    }

    func setLogLevel(level: UInt) {
        Logger.setLogLevel(level: level)
    }
    
    func getSDKType() -> String {
        return self.sdkt
    }
    
    public func setSDKType(sdkType: String) {
        self.sdkt = sdkType
    }
    
    func getSDKVersion() -> String {
       return self.sdkVersion
    }
    
    public func setSDKVersion(sdkVersion: String) {
        self.sdkVersion = sdkVersion
    }
    
  
}
