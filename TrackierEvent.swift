//
//  TrackierEvent.swift
//  trackier-ios-sdk
//
//  Created by Prakhar Srivastava on 18/03/21.
//

import Foundation

struct TrackierEvent {
    
    init(val id: String) {}
    var orderId: String? = ""
    var currency: String? = ""
    var param1: String? = ""
    var param2: String? = ""
    var param3: String? = ""
    var param4: String? = ""
    var param5: String? = ""
    var param6: String? = ""
    var param7: String? = ""
    var param8: String? = ""
    var param9: String? = ""
    var param10: String? = ""

    var revenue: Double? = 0.0
    var ev = [String: Any]()
    
    mutating func addEventValue(prop: String, val: Any) {
        var eventValue = self.ev
        eventValue[prop] = val
        self.ev = eventValue
    }

    static let LEVEL_ACHIEVED = "1CFfUn3xEY"
    static let ADD_TO_CART = "Fy4uC1_FlN"
    static let ADD_TO_WISHLIST = "AOisVC76YG"
    static let COMPLETE_REGISTRATION = "mEqP4aD8dU"
    static let TUTORIAL_COMPLETION = "99VEGvXjN7"
    static let PURCHASE = "Q4YsqBKnzZ"
    static let SUBSCRIBE = "B4N_In4cIP"
    static let START_TRIAL = "jYHcuyxWUW"
    static let ACHIEVEMENT_UNLOCKED = "xTPvxWuNqm"
    static let CONTENT_VIEW = "Jwzois1ays"
    static let TRAVEL_BOOKING = "yP1-ipVtHV"
    static let SHARE = "dxZXGG1qqL"
    static let INVITE = "7lnE3OclNT"
    static let LOGIN = "o91gt1Q0PK"
    static let UPDATE = "sEQWVHGThl"
}
