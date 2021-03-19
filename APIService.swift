//
//  APIService.swift
//  trackier-ios-sdk
//
//  Created by Hemant Mann on 19/03/21.
//

import Foundation
import Alamofire

class APIService {
    static func post(uri : String, body : [String : Any], headers : [String : String]?){
        Alamofire.request(uri, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).validate().response { (responseObject) -> Void in
            print(responseObject)
            if let data = responseObject.data {
                let json = String(data: data, encoding: String.Encoding.utf8)
                print("Response: \(json)")
            }
        }
    }
}
