////
////  APIRepository.swift
////  Alamofire
////
////  Created by Prakhar Srivastava on 19/03/21.
////
//
//import Foundation
//import UIKit
//
//class APIRepository : UIViewController{
//    
//    
//    override func viewDidLoad() {
//        
//        let status = Reach().connectionStatus()
//                 switch status {
//                 case .unknown, .offline:
//                     print("Not connected")
//                 case .online(.wwan):
//                     print("Connected via WWAN")
//                 case .online(.wiFi):
//                     print("Connected via WiFi")
//                 }
//        
//        if case .online(value: let value) = status {
//            // do something with `value`
//            var emptyDictionary = [String: AnyObject]()
//            
//            ApiManager.sharedInstance.requestPOSTURL("www.google.com/", params: emptyDictionary, headers: nil, success: { (json) in
//                // success code
//                print(json)
//            }, failure: { (error) in
//                //error code
//                print(error)
//            })
//        }
//      
//        
//       }
//    
//}
