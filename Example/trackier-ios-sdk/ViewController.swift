//
//  ViewController.swift
//  trackier-ios-sdk
//
//  Created by prak24oct on 03/18/2021.
//  Copyright (c) 2021 prak24oct. All rights reserved.
//

import UIKit
import trackier_ios_sdk

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let config = TrackierSDKConfig(appToken: "xxxx-xx-xxx-xxx", env: TrackierSDKConfig.ENV_DEVELOPMENT)
        TrackierSDK.initialize(config: config)
        let event = TrackierEvent(id: TrackierEvent.PURCHASE)
        event.addEventValue(prop: "purchaseId", val: "sldfjdslfsfsdf")
        event.addEventValue(prop: "purchasePnr", val: "sd2-3dslk329032-23")
        event.setRevenue(revenue: 120.5, currency: "INR")
        event.param1 = "this is a param1 value"
        DispatchQueue.global().async {
            sleep(1)
            TrackierSDK.trackEvent(event: event)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   

}

extension UIDevice {
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
}

