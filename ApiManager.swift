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
    
    override init() {
    }

    static let sharedInstance = ApiManager()

    //TODO :-
    /* Handle Time out request alamofire */


    func requestGETURL(_ strURL: String, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void)
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

    func requestPOSTURL(_ strURL : String, params : [String : AnyObject]?, headers : [String : String]?, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void){
        Alamofire.request(strURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            //print(responseObject)
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                success(resJson)
            }
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                failure(error)
            }
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