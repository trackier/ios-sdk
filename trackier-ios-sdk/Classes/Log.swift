//
//  Factory.swift
//  Alamofire
//
//  Created by Prakhar Srivastava on 19/03/21.
//

import Foundation
import os

private let subsystem = "com.trackier.ios-sdk"

@available(iOS 10.0, *)
struct Log {
    static let dev = OSLog(subsystem: subsystem, category: "dev")
    static let prod = OSLog(subsystem: subsystem, category: "prod")
}
