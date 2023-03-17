//
//  Utils.swift
//  trackier-ios-sdk
//
//  Created by Hemant Mann on 19/03/21.
//

import Foundation
import CryptoSwift

class Utils {
    
    static func getDateTimeFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        return formatter
    }
    
    static func formatTime(date: Date) -> String {
        let formatter = getDateTimeFormatter()
        return formatter.string(from: date)
    }
    
    static func getCurrentTime() -> String {
        let date = Date()
        let formatter = getDateTimeFormatter()
        return formatter.string(from: date)
    }
    
    static func convertUnixTsToISO(ts: Int64) -> String {
        let lst = Date(timeIntervalSince1970: TimeInterval(ts))
        return formatTime(date: lst)
    }
    
    static func convertDictToJSON(data: Dictionary<String, Any>) -> String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
            let decoded = String(data: jsonData, encoding: .utf8)!
            return decoded
        } catch {
            return ""
        }
    }
    
    // Reference: https://stackoverflow.com/questions/34778950/how-to-compare-any-value-types
    static func isEqual<T: Equatable>(type: T.Type, a: Any, b: Any) -> Bool {
        guard let a = a as? T, let b = b as? T else { return false }

        return a == b
    }

    static func getUnixTime(time: String?) -> String {
        if (time != nil) {
            let dateFormatter = getDateTimeFormatter()
            let date = dateFormatter.date(from: time!)
            return String(date!.timeIntervalSince1970)
        } else {
            return ""
        }
    }
    
    static func createSignature(message: String, key: String) -> String {
        do {
            let bytes = try CryptoSwift.HMAC(key: key, variant: .sha2(.sha256)).authenticate(message.bytes)
            let data = Data(bytes)

            return data.hexEncodedString()
        } catch {
            return ""
        }
    }
    
    static func makeQueryString(_ queryItems: [URLQueryItem]) -> String? {
        let url = URL(string: "https://domain.com")
        var urlComponents = URLComponents(url: url!, resolvingAgainstBaseURL: true)!
        urlComponents.queryItems = queryItems
        
        if #available(iOS 16.0, *) {
            return urlComponents.url?.query(percentEncoded: false)
        }
        
        return urlComponents.url?.query
    }
}

extension Data {
    func hexEncodedString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}

