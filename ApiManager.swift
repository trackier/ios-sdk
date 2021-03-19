//
//  ApiManager.swift
//  Alamofire
//
//  Created by Prakhar Srivastava on 19/03/21.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON


class ApiManager: NSObject {
    
    static let sharedInstance = ApiManager()
    
    override init() {
    }
    
    static func doWork(workRequest: TrackierWorkRequest) {
        switch workRequest.kind {
        case TrackierWorkRequest.KIND_INSTALL:
            sharedInstance.requestPOSTURL(strURL: "https://requestbin.offersoptimize.com/1kke4xr1", params: workRequest.getData(), headers: nil)
            break;
        case TrackierWorkRequest.KIND_EVENT:
            sharedInstance.requestPOSTURL(strURL: "https://requestbin.offersoptimize.com/1kke4xr1", params: workRequest.getEventData(), headers: nil)
            break;
        case TrackierWorkRequest.KIND_SESSION:
            break;
        case TrackierWorkRequest.KIND_UNKNOWN:
            break;
        default:
            break;
        }
    }


    func requestGETURL(strURL: String, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void)
    {
        Alamofire.request(strURL).responseJSON { (responseObject) -> Void in
            //print(responseObject)
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                //let title = resJson["title"].string
                //print(title!)
                success(resJson)
            }

            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                failure(error)
            }
        }
    }

    func requestPOSTURL(strURL : String, params : [String : Any], headers : [String : String]?){
        print("==request params", params)
        Alamofire.request(strURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).response { (responseObject) -> Void in
            print(responseObject)
            //print(responseObject)
//            if responseObject {
//                let resJson = JSON(responseObject.result.value!)
//                success(resJson)
//            }
//            if responseObject.result.isFailure {
//                let error : Error = responseObject.result.error!
//                failure(error)
//            }
        }
    }
}


/*
 USEAGES

//
//AFWrapper.sharedInstance.requestPOSTURL(HttpsUrl.Address, params: dict as [String : AnyObject]?, headers: nil, success: { (json) in
//    // success code
//    print(json)
//}, failure: { (error) in
//    //error code
//    print(error)
//})
 
 */
