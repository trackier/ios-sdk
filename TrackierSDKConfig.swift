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
    
    var appToken: String
    var env: String

    public init(appToken: String, env: String) {
        self.appToken = appToken
        self.env = env
    }

    func setLogLevel() {
        // TODO: fix me
    }
}
