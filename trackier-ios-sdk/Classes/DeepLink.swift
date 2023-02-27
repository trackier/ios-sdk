//
//  DeepLink.swift
//  trackier-ios-sdk
//
//  Created by Sanu Gupta on 17/02/23.
//

import Foundation

public class DeepLink {
    
    private var dictionaryData: [String: Any]
    
    public init(result: [String: Any]) {
        self.dictionaryData = result
    }
    
    public func getDictData(key: String) -> String {
        let dictData = self.dictionaryData[key]
        return (dictData as? String)!
    }
    
    public func getMessage() -> String {
        return getDictData(key: "message")
    }
    
    public func getAd() -> String {
        return getDictData(key: "ad")
    }
    
    public func getAdId() -> String {
        return getDictData(key: "adId")
    }
    
    public func getCamp() -> String {
        return getDictData(key: "camp")
    }
    
    public func getCampId() -> String {
        return getDictData(key: "campId")
    }
    
    public func getAdSet() -> String {
        return getDictData(key: "adSet")
    }
    
    public func getAdSetId() -> String {
        return getDictData(key: "adSetId")
    }
    
    public func getChannel() -> String {
        return getDictData(key: "channel")
    }
    
    public func getP1() -> String {
        return getDictData(key: "p1")
    }
    
    public func getP2() -> String {
        return getDictData(key: "p2")
    }
    
    public func getP3() -> String {
        return getDictData(key: "p3")
    }
    
    public func getP4() -> String {
        return getDictData(key: "p4")
    }
    
    public func getP5() -> String {
        return getDictData(key: "p5")
    }
    
    public func getClickId() -> String {
        return getDictData(key: "clickId")
    }
    
    public func getDlv() -> String {
        return getDictData(key: "dlv")
    }
    
    public func getPid() -> String {
        return getDictData(key: "pid")
    }
    
    static func parseDeeplinkData(res: InstallResponse) -> DeepLink {
        var dict = Dictionary<String, Any>()
        dict["ad"] = res.ad
        dict["adId"] = res.adId
        dict["adSetId"] = res.adSetId
        dict["camp"] = res.camp
        dict["campId"] = res.campId
        dict["adSet"] = res.adSet
        dict["adSetId"] = res.adSetId
        dict["channel"] = res.channel
        dict["message"] = res.message
        dict["p1"] = res.p1
        dict["p2"] = res.p2
        dict["p3"] = res.p3
        dict["p4"] = res.p4
        dict["p5"] = res.p5
        dict["clickId"] = res.clickId
        dict["dlv"] = res.dlv
        dict["pid"] = res.pid
        dict["sdkParams"] = res.sdkParams
        dict["isRetargeting"] = res.isRetargeting
        dict["dlv"] = "this-is-dlv-value"
        return DeepLink(result: dict)
    }
}
