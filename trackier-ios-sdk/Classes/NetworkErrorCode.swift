//
//  NetworkErrorCode.swift
//  trackier-ios-sdk
//
//  Created by Prakhar Srivastava on 21/03/21.
//

import Foundation
import Alamofire

enum NetworkErrorCode: Int {
    case timeOut = -1001
    case connectionLost = -1005
}

class NetworkRequestRetrier: RequestRetrier {
    
    let retry = 3
    
    // [Request url: Number of times retried]
    private var retriedRequests: [String: Int] = [:]
    
    func should(_ manager: SessionManager,
                retry request: Request,
                with error: Error,
                completion: @escaping RequestRetryCompletion) {
        
        guard
            request.task?.response == nil,
            let url = request.request?.url?.absoluteString
            else {
                removeCachedUrlRequest(url: request.request?.url?.absoluteString)
                completion(false, 0.0) // don't retry
                return
        }
        
        let  errorGenerated = error as NSError
        switch errorGenerated.code {
        case NetworkErrorCode.timeOut.rawValue, NetworkErrorCode.connectionLost.rawValue :
            guard let retryCount = retriedRequests[url] else {
                retriedRequests[url] = 1
                completion(true, 0.5) // retry after 0.5 second
                return
            }
            
            if retryCount < retry {
                retriedRequests[url] = retryCount + 1
                completion(true, 0.5) // retry after 0.5 second
            } else {
                removeCachedUrlRequest(url: url)
                completion(false, 0.0) // don't retry
            }
            
        default:
            print("error code does not match with cases")
            removeCachedUrlRequest(url: url)
            completion(false, 0.0)
        }
    }
    
    private func removeCachedUrlRequest(url: String?) {
        guard let url = url else {
            return
        }
        retriedRequests.removeValue(forKey: url)
    }
}
