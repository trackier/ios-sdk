//
//  SKANModels.swift
//  
//
//  Created by Satyam Jha on 26/03/25.
//

import Foundation
import StoreKit

<<<<<<< HEAD
=======
struct SKANResponse: Codable {
    let success: Bool
    let data: SKANConfig?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case success
        case data
        case message
    }
}

>>>>>>> cca9e48 (feat : fixed log issues)
struct SKANConfig: Codable {
    let id: String
    let aid: String
    let window1: SKANWindow
    let window2: SKANWindow
    let window3: SKANWindow
    let status: String
    let currency: String?
    let createdAt: Date
    let updatedAt: Date
<<<<<<< HEAD
    
=======
    let skanVer: String?
    let oid: String?
    let createdBy: String?
    let updatedBy: String?

>>>>>>> cca9e48 (feat : fixed log issues)
    enum CodingKeys: String, CodingKey {
        case id, aid, status, currency, window1, window2, window3
        case createdAt = "created_at"
        case updatedAt = "updated_at"
<<<<<<< HEAD
    }
    
=======
        case skanVer = "skan_ver"
        case oid, createdBy = "created_by", updatedBy = "updated_by"
    }

>>>>>>> cca9e48 (feat : fixed log issues)
    enum ValidationError: Error {
        case invalidRevenueRanges
        case missingWindow1Values
        case overlappingRevenueRanges
        case invalidLockWindowValue
    }
<<<<<<< HEAD
    
    func validate() throws {
        // Validate Window 1 has at least one value
        if window1.fineValues?.isEmpty ?? true && window1.coarseValues?.isEmpty ?? true {
            throw ValidationError.missingWindow1Values
        }
        
        // Validate revenue ranges don't overlap within each window
        try validateWindow(window: window1)
        try validateWindow(window: window2)
        try validateWindow(window: window3)
        
        // Validate lock window values
        if !window1.isValidLockWindow {
            throw ValidationError.invalidLockWindowValue
        }
    }
    
=======

    func validate() throws {
        if window1.fineValues?.isEmpty ?? true && window1.coarseValues?.isEmpty ?? true {
            throw ValidationError.missingWindow1Values
        }
        try validateWindow(window: window1)
        try validateWindow(window: window2)
        try validateWindow(window: window3)
    }

>>>>>>> cca9e48 (feat : fixed log issues)
    private func validateWindow(window: SKANWindow) throws {
        if let fineValues = window.fineValues {
            try validateRanges(values: fineValues.map { ($0.revenueStart, $0.revenueEnd) })
        }
<<<<<<< HEAD
        
=======
>>>>>>> cca9e48 (feat : fixed log issues)
        if let coarseValues = window.coarseValues {
            try validateRanges(values: coarseValues.map { ($0.revenueStart, $0.revenueEnd) })
        }
    }
<<<<<<< HEAD
    
    private func validateRanges(values: [(start: Double, end: Double)]) throws {
        let sorted = values.sorted { $0.start < $1.start }
        
=======

    private func validateRanges(values: [(start: Double, end: Double)]) throws {
        let sorted = values.sorted { $0.start < $1.start }
>>>>>>> cca9e48 (feat : fixed log issues)
        for i in 0..<sorted.count-1 {
            if sorted[i].end > sorted[i+1].start {
                throw ValidationError.overlappingRevenueRanges
            }
        }
    }
}

struct SKANWindow: Codable {
    let fineValues: [SKANFineValue]?
    let coarseValues: [SKANCoarseValue]?
    let lockWindowValue: String?
<<<<<<< HEAD
    
=======

>>>>>>> cca9e48 (feat : fixed log issues)
    enum CodingKeys: String, CodingKey {
        case fineValues = "conv_fine"
        case coarseValues = "conv_coarse"
        case lockWindowValue = "lw_value"
    }
<<<<<<< HEAD
    
    var shouldLock: Bool {
        lockWindowValue?.lowercased() == "true" || lockWindowValue?.lowercased() == "high"
    }
    
    var isValidLockWindow: Bool {
        guard let value = lockWindowValue?.lowercased() else { return true }
        return ["true", "false", "high", "low", "medium"].contains(value)
=======

    var shouldLock: Bool {
        guard let value = lockWindowValue?.lowercased() else { return false }
        return value == "true" || value == "high" || value == "medium" || (Double(value) != nil && Double(value)! > 0)
    }

    var isValidLockWindow: Bool {
        guard let value = lockWindowValue?.lowercased() else { return true }
        return ["true", "false", "high", "low", "medium"].contains(value) || Double(value) != nil
>>>>>>> cca9e48 (feat : fixed log issues)
    }
}

struct SKANFineValue: Codable {
    let eventId: String?
    let eventName: String?
    let value: Int
    let revenueStart: Double
    let revenueEnd: Double
<<<<<<< HEAD
    
=======

>>>>>>> cca9e48 (feat : fixed log issues)
    enum CodingKeys: String, CodingKey {
        case eventId = "eid"
        case eventName = "ename"
        case value = "conv_val"
        case revenueStart = "rev_start"
        case revenueEnd = "rev_end"
    }
<<<<<<< HEAD
    
    func matches(eventId: String?, revenue: Double) -> Bool {
        let eventMatches = self.eventId == eventId || eventId == nil
=======

    func matches(eventId: String?, revenue: Double) -> Bool {
        let eventMatches = self.eventId == eventId || eventId == nil || self.eventId?.isEmpty == true
>>>>>>> cca9e48 (feat : fixed log issues)
        let revenueMatches = revenue >= revenueStart && revenue <= revenueEnd
        return eventMatches && revenueMatches
    }
}

struct SKANCoarseValue: Codable {
    let eventId: String?
    let eventName: String?
    let type: SKANCoarseType
    let revenueStart: Double
    let revenueEnd: Double
<<<<<<< HEAD
    
=======

>>>>>>> cca9e48 (feat : fixed log issues)
    enum CodingKeys: String, CodingKey {
        case eventId = "eid"
        case eventName = "ename"
        case type
        case revenueStart = "rev_start"
        case revenueEnd = "rev_end"
    }
<<<<<<< HEAD
    
    func matches(eventId: String?, revenue: Double) -> Bool {
        let eventMatches = self.eventId == eventId || eventId == nil
=======

    func matches(eventId: String?, revenue: Double) -> Bool {
        let eventMatches = self.eventId == eventId || eventId == nil || self.eventId?.isEmpty == true
>>>>>>> cca9e48 (feat : fixed log issues)
        let revenueMatches = revenue >= revenueStart && revenue <= revenueEnd
        return eventMatches && revenueMatches
    }
}

enum SKANCoarseType: String, Codable {
    case low = "low"
    case medium = "medium"
    case high = "high"
<<<<<<< HEAD
    
=======

>>>>>>> cca9e48 (feat : fixed log issues)
    @available(iOS 16.1, *)
    var skAdNetworkValue: SKAdNetwork.CoarseConversionValue {
        switch self {
        case .medium: return .medium
        case .high: return .high
        default: return .low
        }
    }
<<<<<<< HEAD
    
    func toString() -> String {
        return rawValue
    }
=======
>>>>>>> cca9e48 (feat : fixed log issues)
}

struct SKANCurrentValues {
    var fine: Int?
    var coarse: SKANCoarseType?
    var lock: Bool
    var lastUpdated: Date?
<<<<<<< HEAD
    
=======

>>>>>>> cca9e48 (feat : fixed log issues)
    init(fine: Int? = nil, coarse: SKANCoarseType? = nil, lock: Bool = false) {
        self.fine = fine
        self.coarse = coarse
        self.lock = lock
    }
}
<<<<<<< HEAD
=======

// Add this extension for better date decoding
extension JSONDecoder {
    static var skanDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }
}
>>>>>>> cca9e48 (feat : fixed log issues)
