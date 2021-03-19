//
//  TrackierSDKConfig.swift
//  trackier-ios-sdk
//
//  Created by Prakhar Srivastava on 18/03/21.
//

import Foundation

public class TrackierSDKConfig {
    var appToken: String
    var env: String

    init(appToken: String, env: String) {
        self.appToken = appToken
        self.env = env
    }


    func setLogLevel() {
        //TODO: fix me
    }
}
