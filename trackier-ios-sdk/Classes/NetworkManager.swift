//
//  NetworkManager.swift
//  trackier-ios-sdk
//
//  Created by Prakhar Srivastava on 21/03/21.
//

import UIKit
import Foundation
import Alamofire
import Reachability
import os

class NetworkManager: NSObject
{
    
    private var retriedRequests: [String: Int] = [:]
    
   // public typealias successHandler = (Data) -> ()
    public typealias failureHandler = (_ error: String?) -> ()
    
    static let sharedManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 20
        configuration.timeoutIntervalForResource = 20
        
        let manager = Alamofire.SessionManager(configuration: configuration)
        let requestRet = NetworkRequestRetrier()
        manager.retrier = requestRet
        return manager
    }()
    
    
    class func postApiCall( url : String,  body : [String : Any], headers : [String : String]?,failure: @escaping failureHandler)
    {
        
        if  NetworkReachabilityManager()!.isReachable
        {
            let apiUrl = URL(string: url)
            print("POST API Called - \(apiUrl!)")
            
            sharedManager.request(url, method: .post,
                                  parameters: body,
                                  encoding: JSONEncoding.default, headers: headers).validate().response{ (responseObject) -> Void in
//
                        os_log("Install success!", log: Log.prod, type: .info)
//                                    response in
//
//                                    if let dataResponse = response.data {
//                                        let str = String(decoding: dataResponse, as: UTF8.self)
//                                        print("decoded response - \(str)")
//                                    } else {
//                                        print("response - \(response)")
//                                    }
//
//                                    if let result = response.result.value {
//                                        let JSON = result as! NSDictionary
//                                        print(JSON)
//                                    }
//                                    switch (response.result) {
//                                    case .success:
//                                        success(response.data!)
//                                        break
//
//                                    case .failure(let error):
//                                        let errorCustom = error.getCustomError()
//                                        failure(errorCustom)
//                                        break
//                                    }
            }
        }
        else
        {
           failure("sldfjks")
        }
    }
}

extension Error
{
    func getCustomError() -> NetworkError
    {
        var customError: NetworkError
        print("custom error \(self.localizedDescription)")
        let errorGenerated = self as NSError
        print("errorGenerated.code \(errorGenerated.code)")
        switch errorGenerated.code
        {
        case -1009:
            customError = NetworkError.internetNotAvailable
        case -1001:
            customError = NetworkError.timeout
        case -1005:
            customError = NetworkError.connectionLost
        default:
            customError = NetworkError.defaultIssue
        }
        return customError
    }
    
}
