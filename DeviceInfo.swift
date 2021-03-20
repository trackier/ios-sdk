//
//  DeviceInfo.swift
//  Alamofire
//
//  Created by Prakhar Srivastava on 19/03/21.
//

import Foundation
import Network

class DeviceInfo : UIViewController{
    
    var name = UIDevice.current.name
    var systemName = UIDevice.current.systemName
    var systemVersion = UIDevice.current.systemVersion
    var model = UIDevice.current.model
    var localizedModel = UIDevice.current.localizedModel
    //var orientataion = UIDevice.current.orientation.
   // var batteryLevel = UIDevice.current.batteryLevel
    var isBatteryMonitoringEnabled = UIDevice.current.isBatteryMonitoringEnabled
   // var batteryState = UIDevice.current.batteryState
    var connectivity = ""


    func getConnectivity() -> String {
        var connection = ""
        let nwPathMonitor = NWPathMonitor()
        nwPathMonitor.pathUpdateHandler = { path in

            if path.usesInterfaceType(.wifi) {
                print("Path is Wi-Fi")
               connection = "Wi-Fi"
            } else if path.usesInterfaceType(.cellular) {
                    print("Path is Cellular")
               connection =  "Cellular"
            } else if path.usesInterfaceType(.wiredEthernet) {
                    print("Path is Wired Ethernet")
              connection =  "WiredEthernet"
            } else if path.usesInterfaceType(.loopback) {
                    print("Path is Loopback")
               connection =  "Loopback"
            } else if path.usesInterfaceType(.other) {
                    print("Path is other")
               connection = "other"
            }
        }

        nwPathMonitor.start(queue: .main)
        
        return connection
        
    }
    
    public func getDeviceInfo() -> Dictionary<String, Any> {
        var dict = Dictionary<String, Any>()
        dict["name"] = name
        dict["systemName"] = systemName
        dict["systemVersion"] = systemVersion
        dict["model"] = model
           dict["localizedModel"] = localizedModel
          // dict["orientataion"] = orientataion
          // dict["batteryLevel"] = batteryLevel
           dict["isBatteryMonitoringEnabled"] = isBatteryMonitoringEnabled
          // dict["batteryState"] = batteryState
           dict["connectivity"] = getConnectivity()
           return dict
       }
       
    
}
