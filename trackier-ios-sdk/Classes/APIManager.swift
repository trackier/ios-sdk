//
//  APIManager.swift
//  trackier-ios-sdk
//
//  Created by Prakhar Srivastava on 19/03/21.
//

import Foundation
import os

class APIManager: NSObject {
    
    static let sharedInstance = APIManager()
    static var headers = ["User-Agent": Constants.USER_AGENT, "X-Client-SDK": Constants.SDK_VERSION]
    
    override init() {
    }
    
    static func doWork(workRequest: TrackierWorkRequest) {
        switch workRequest.kind {
        case TrackierWorkRequest.KIND_INSTALL:
            APIService.post(uri: Constants.INSTALL_URL, body: workRequest.getData(), headers: headers)
            break;
        case TrackierWorkRequest.KIND_EVENT:
            APIService.post(uri: Constants.EVENTS_URL, body: workRequest.getEventData(), headers: headers)
            break;
        case TrackierWorkRequest.KIND_SESSION:
            APIService.post(uri: Constants.SESSIONS_URL, body: workRequest.getSessionData(), headers: headers)
            break;
        case TrackierWorkRequest.KIND_UNKNOWN:
            break;
        default:
            break;
        }
    }
}
