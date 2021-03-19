//
//  TrackierWorkRequest.swift
//  trackier-ios-sdk
//
//  Created by Hemant Mann on 19/03/21.
//

import Foundation

class TrackierWorkRequest {
    static let KIND_INSTALL = "install"
    static let KIND_EVENT = "event"
    static let KIND_SESSION = "session"
    static let KIND_UNKNOWN = "unknown"
    
    var kind: String
    var installId: String = ""
    var eventObj = TrackierEvent(id: "")
    private var appToken: String
    private var mode: String
    
    init(kind: String, appToken: String, mode: String) {
        self.kind = kind
        self.appToken = appToken
        self.mode = mode
    }
    
    func getData() -> Dictionary<String, Any> {
        var dict = Dictionary<String, Any>()
        dict["appKey"] = self.appToken
        dict["device"] = "{}"   // TODO: fix me
        dict["createdAt"] = Utils.getCurrentTime()
        dict["isLat"] = false
        dict["mode"] = self.mode
        dict["installId"] = self.installId
        return dict
    }
    
    func getEventData() -> Dictionary<String, Any> {
        var dict = getData()
        dict["event"] = self.eventObj.getHashMap()
        return dict
    }
}
