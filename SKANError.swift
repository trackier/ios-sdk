//
//  SKANError.swift
//  Pods
//
//  Created by Satyam Jha on 01/04/25.
//

// SKANError.swift
import Foundation

public enum SKANError: Error {
    case configurationMissing
    case noValuesSet
    case updateTooFrequent
    case unsupportediOSVersion
    case invalidConfig(Error)
    case invalidURL
    case invalidResponse
    case noData
    case serverError(statusCode: Int)
    
    public var localizedDescription: String {
        switch self {
        case .configurationMissing:
            return "SKAN configuration not loaded"
        case .noValuesSet:
            return "No conversion values set"
        case .updateTooFrequent:
            return "SKAN update skipped - too frequent"
        case .unsupportediOSVersion:
            return "SKAN not supported on this iOS version"
        case .invalidConfig(let error):
            return "Invalid SKAN configuration: \(error.localizedDescription)"
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .noData:
            return "No data received from server"
        case .serverError(let statusCode):
            return "Server error with status code: \(statusCode)"
        }
    }
}
