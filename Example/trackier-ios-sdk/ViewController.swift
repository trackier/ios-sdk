import UIKit
import trackier_ios_sdk
import os.log

class ViewController: UIViewController {
    
    // MARK: - Properties
    private enum LogLevel {
        case debug, info, warning, error
    }
    
    private static let logger = OSLog(
        subsystem: "com.trackier.ios-sdk",
        category: "SKANTesting"
    )
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserTracking()
        setupRevenueTrackingExamples()
        setupSKANTests()
    }
    
    // MARK: - User Tracking
    private func setupUserTracking() {
        // User identification
        TrackierSDK.setUserID(userId: "2998329")
        TrackierSDK.setUserEmail(userEmail: "abc@gmail.com")
        TrackierSDK.setUserName(userName: "abc")
        TrackierSDK.setUserPhone(userPhone: "xxxxxxxxxx")
        
        // Track login event
        trackLoginEvent()
    }
    
    private func trackLoginEvent() {
        let event = TrackierEvent(id: TrackierEvent.LOGIN)
        event.setDiscount(discount: 3.0)
        event.setCouponCode(couponCode: "test2")
        event.addEventValue(prop: "customValue1", val: "test1")
        event.addEventValue(prop: "customValue2", val: "XXXXX")
        
        TrackierSDK.trackEvent(event: event)
        TrackierSDK.updateSKANConversion(revenue: 445.3, eventId: "purchase")
    }
    
    // MARK: - Revenue Tracking Examples
    private func setupRevenueTrackingExamples() {
        // Example 1: Simple purchase
        let purchaseEvent = TrackierEvent(id: "sEMWSCTXeu")
        purchaseEvent.setRevenue(revenue: 9.99, currency: "USD")
        purchaseEvent.orderId = "ORD12345"
        TrackierSDK.trackEvent(event: purchaseEvent)
        
        // Example 2: Subscription
        trackSubscriptionEvent()
    }
    
    private func trackSubscriptionEvent() {
        let subscriptionEvent = TrackierEvent(id: TrackierEvent.PURCHASE)
        subscriptionEvent.setRevenue(revenue: 4.99, currency: "USD")
        subscriptionEvent.param1 = "monthly"
        subscriptionEvent.addEventValue(prop: "trial_period", val: "7 days")
        TrackierSDK.trackEvent(event: subscriptionEvent)
    }
    
    // MARK: - SKAN Testing
    private func setupSKANTests() {
        logMessage("Starting SKAN integration tests", level: .info)
        
        // Test sequence with delays to simulate real user flow
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.testInitialSKANUpdates()
        }
    }
    
    private func testInitialSKANUpdates() {
        logMessage("Testing initial SKAN updates", level: .debug)
        
        // First update - app launch/tutorial completion
        TrackierSDK.updateSKANConversion(revenue: 0, eventId: "first_open") { [weak self] _, _ in
            self?.logCurrentSKANValues()
            
            // Second update - after some engagement
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                TrackierSDK.updateSKANConversion(revenue: 25.0, eventId: "content_view") { [weak self] _, _ in
                    self?.logCurrentSKANValues()
                    self?.testPostbackSimulation()
                }
            }
        }
    }
    
    private func testPostbackSimulation() {
        if #available(iOS 16.1, *) {
            logMessage("Testing SKAN postback simulation", level: .debug)
            
            let testURL = URL(string: "https://apptrovesn.com/api/v2/skans/conversion_studios")!
            TrackierSDK.testSKANPostback(url: testURL) { [weak self] success, error in
                if success {
                    self?.logMessage("SKAN postback test succeeded", level: .info)
                } else if let error = error {
                    self?.logMessage("SKAN postback test failed: \(error.localizedDescription)", level: .error)
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    private func logCurrentSKANValues() {
        let (fine, coarse) = TrackierSDK.getCurrentSKANValues()
        logMessage("Current SKAN Values - Fine: \(fine ?? 0), Coarse: \(coarse ?? "none")", level: .debug)
    }
    
    private func logMessage(_ message: String, level: LogLevel) {
        let osLogType: OSLogType
        switch level {
        case .debug: osLogType = .debug
        case .info: osLogType = .info
        case .warning: osLogType = .error
        case .error: osLogType = .fault
        }
        
        os_log("%{public}@", log: Self.logger, type: osLogType, message)
    }
    
    // MARK: - IBActions
    @IBAction func didCompletePurchase(_ sender: UIButton) {
        let purchaseAmount = 19.99
        logMessage("User completed purchase: $\(purchaseAmount)", level: .info)
        
        // Track both the event and update SKAN conversion
        let event = TrackierEvent(id: TrackierEvent.PURCHASE)
        event.setRevenue(revenue: purchaseAmount, currency: "USD")
        TrackierSDK.trackEvent(event: event)
        
        TrackierSDK.updateSKANConversion(
            revenue: purchaseAmount,
            eventId: "purchase"
        ) { [weak self] success, error in
            if success {
                self?.logMessage("Successfully updated SKAN conversion for purchase", level: .info)
            } else if let error = error {
                self?.logMessage("SKAN update failed: \(error.localizedDescription)", level: .error)
            }
        }
    }
    
    @available(iOS 16.1, *)
    @IBAction func didTapTestPostback(_ sender: UIButton) {
        testPostbackSimulation()
    }
}

// MARK: - Device Info Extension
extension UIDevice {
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        return machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
    }
}
