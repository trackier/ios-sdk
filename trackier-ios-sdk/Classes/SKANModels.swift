//
//  SKANConversionValue.swift
//  
//
//  Created by Satyam Jha on 26/03/25.
//

import Foundation

/// Represents the complete SKAdNetwork conversion value configuration
struct SKANConfig: Codable {
    let id: String
    let aid: String
    let windows: [SKANWindow]
    let status: String
    let currency: String?
    let createdAt: Date
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id, aid, status, currency
        case windows = "windowData"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

/// Represents a single conversion window (0-2 days, 3-7 days, or 8-35 days)
struct SKANWindow: Codable {
    let index: Int  // 1, 2, or 3
    let fineValues: [SKANFineValue]?
    let coarseValues: [SKANCoarseValue]?
    let lockWindowValue: String?
    
    enum CodingKeys: String, CodingKey {
        case index = "windowNumber"
        case fineValues = "conv_fine"
        case coarseValues = "conv_coarse"
        case lockWindowValue = "lw_value"
    }
}

/// Fine-grained conversion value (0-63)
struct SKANFineValue: Codable {
    let eventId: String
    let eventName: String?
    let value: Int
    let revenueStart: Double
    let revenueEnd: Double
    
    enum CodingKeys: String, CodingKey {
        case eventId = "eid"
        case eventName = "ename"
        case value = "conv_val"
        case revenueStart = "rev_start"
        case revenueEnd = "rev_end"
    }
}

/// Coarse-grained conversion value (low, medium, high)
struct SKANCoarseValue: Codable {
    let eventId: String
    let eventName: String?
    let type: SKANCoarseType
    let revenueStart: Double
    let revenueEnd: Double
    
    enum CodingKeys: String, CodingKey {
        case eventId = "eid"
        case eventName = "ename"
        case type
        case revenueStart = "rev_start"
        case revenueEnd = "rev_end"
    }
}

enum SKANCoarseType: String, Codable {
    case low = "low"
    case medium = "medium"
    case high = "high"
    
    var skAdNetworkValue: SKAdNetwork.CoarseConversionValue {
        switch self {
        case .medium: return .medium
        case .high: return .high
        default: return .low
        }
    }
}
