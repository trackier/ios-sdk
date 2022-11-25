//
//  APIService.swift
//  trackier-ios-sdk
//
//  Created by Hemant Mann on 19/03/21.
//

import Foundation
import Alamofire

struct DataResponse: Codable {
    let success: Bool
}

class APIService {
    var sessionManager = Session()          // Create a session manager 
    static var shared = APIService()

    private func request(uri : String, method: HTTPMethod, body : [String : Any], headers : HTTPHeaders?) {
        sessionManager.request(uri, method: method, parameters: body, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (responseObj) -> Void in
            Logger.debug(message: "Response is \(responseObj)")
        }
    }
    
    static func post(uri : String, body : [String : Any], headers : HTTPHeaders?){
        shared.request(uri: uri, method: HTTPMethod.post, body: body, headers: headers)
    }
    
    @available(iOS 13.0, *)
    private func requestAsync(uri : String, method: HTTPMethod, body : [String : Any], headers : HTTPHeaders?) async throws -> Data {
        try await withUnsafeThrowingContinuation { continuation in
            AF.request(uri, method: method, parameters: body, encoding: JSONEncoding.default, headers: headers).validate().responseData { response in
                if let data = response.value {
                    continuation.resume(returning: data)
                    return
                }
                if let err = response.error {
                    continuation.resume(throwing: err)
                    return
                }
                fatalError("unhandled request edge case")
            }
        }
    }
    
    @available(iOS 13.0, *)
    static func postAsync(uri : String, body : [String : Any], headers : HTTPHeaders?) async throws -> Data {
        return try await shared.requestAsync(uri: uri, method: HTTPMethod.post, body: body, headers: headers)
    }
}
