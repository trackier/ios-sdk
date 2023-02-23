//
//  DeepLink.swift
//  trackier-ios-sdk
//
//  Created by Sanu Gupta on 17/02/23.
//

import Foundation

public class DeepLink {
    
    public init() {}
    
    var dictionaryData = [String: Any]()
    
    public func dictionaryData(dictionary: Dictionary<String, Any>) {
        dictionaryData = dictionary
        print("dictData---sasa----\(String(describing: dictionary["message"]))}")
    }
    
    private func getDictData(key: String) -> String {
        let dictData = dictionaryData[key]
        print("dictData----wewe---\(String(describing: dictData))")
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
    
}
