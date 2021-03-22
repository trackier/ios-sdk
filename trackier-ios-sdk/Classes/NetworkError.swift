//
//  NetworkError.swift
//  trackier-ios-sdk
//
//  Created by Prakhar Srivastava on 21/03/21.
//

import Foundation

enum NetworkError : Error {
    case decoding
    case internetNotAvailable
    case timeout
    case connectionLost
    case defaultIssue
    case runtime(String)
    
    var errorDescription: String {
        switch self {
        case .decoding:
            return "Something went wrong. Please try again after sometime."
        case .internetNotAvailable:
            return "No Internet Connection. Please check your internet connection."
        case .timeout:
            return "Looks like the server is taking to long to respond, this can be caused by either poor connectivity or an error with our servers. Please try again in a while."
        case .connectionLost:
            return "Connection Has Been Lost"
        case .defaultIssue:
            return "Something went wrong"
        case .runtime(let errorMsg):
            return errorMsg
        }
    }
    
    var statusCode: String{
        switch self {
        case .internetNotAvailable:
            return "-1009"
        case .timeout:
            return "-1001"
        case .connectionLost:
            return "-1005"
        default:
            return "0"
        }
    }
}

extension Data {
    
    func responseJSONCodable<T: Codable>(for : T.Type, completion: @escaping (T) -> (), failure: @escaping (NetworkError) ->()) {
        let decoder: JSONDecoder = JSONDecoder()
        do {
            let decodedValue = try decoder.decode(T.self, from: self)
            completion(decodedValue)
        } catch {
            print("decoding error - \(error)")
            failure(NetworkError.decoding)
        }
    }
}

