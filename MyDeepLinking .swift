//
//  MyDeepLinking .swift
//  trackier-ios-sdk
//
//  Created by Sanu Gupta on 22/02/23.
//

import Foundation

public class MyDeepLinking: DeepLinkListener {
    
    public init() {}
    
    public func onDeepLinking(result: DeepLink) {
        print("Deeplink Message---\(String(describing: result.getMessage))")
    }
    
    public func deeplinkingCallBack(completion: @escaping (DeepLink) -> Void) {
        completion(DeepLink())
    }
}
