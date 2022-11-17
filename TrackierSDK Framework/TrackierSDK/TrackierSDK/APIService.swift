//
//  APIService.swift
//  trackier-ios-sdk
//
//  Created by Hemant Mann on 19/03/21.
//

import Foundation
import Alamofire

class APIService {
    var sessionManager = Session()          // Create a session manager 
    static var shared = APIService()
    var reponse = false

    private func request(uri : String, method: HTTPMethod, body : [String : Any], headers : HTTPHeaders?) {
        sessionManager.request(uri, method: method, parameters: body, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (responseObj) -> Void in
            Logger.debug(message: "Response is \(responseObj)")
        }
    }
    
    static func post(uri : String, body : [String : Any], headers : HTTPHeaders?) {
        shared.request(uri: uri, method: HTTPMethod.post, body: body, headers: headers)
    }
}
