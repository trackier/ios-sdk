//
//  DeviceInfo.swift
//  Alamofire
//
//  Created by Prakhar Srivastava on 19/03/21.
//

import Foundation

class DeviceInfo : UIViewController{
    
        override func viewDidLoad() {
           super.viewDidLoad()
           // Do any additional setup after loading the view, typically from a nib.
           let udid = UIDevice.current.identifierForVendor?.uuidString
           let name = UIDevice.current.name
           let version = UIDevice.current.systemVersion
           let modelName = UIDevice.current.model
           print(udid ?? "")    // D774EAE3F447445F9D5FE2B3B699ADB1
           print(name)          // iPhone XR
           print(version)       // 12.1
           print(modelName)     // iPhone
        }
    
}
