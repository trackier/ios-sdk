//
//  DeeplinkData.swift
//  trackier-ios-sdk_Example
//
//  Created by Trackier on 27/02/23.
//  Copyright © 2023 Trackier. All rights reserved.
//

import Foundation
import trackier_ios_sdk

class DeeplinkData: DeepLinkListener {
    func onDeepLinking(result: DeepLink) -> Void {
        print("==result: \(result.getDlv())")
    }
}
