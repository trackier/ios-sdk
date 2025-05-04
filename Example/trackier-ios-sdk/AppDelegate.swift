//
//  AppDelegate.swift
//  trackier-ios-sdk
//
//  Created by Trackier on 03/18/2021.
//  Copyright (c) 2021 Trackier. All rights reserved.
//

import UIKit
import os
import trackier_ios_sdk

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, DeepLinkListener {
    

    var window: UIWindow?

    func onDeepLinking(result: DeepLink) -> Void {
        print("Deep link URL: \(result.getUrl())")
        
        // Access specific parameters using the provided getter methods
        print("Campaign: \(result.getCamp())")
        print("Campaign ID: \(result.getCampId())")
        print("Ad: \(result.getAd())")
        print("Ad ID: \(result.getAdId())")
        print("Channel: \(result.getChannel())")
        print("Click ID: \(result.getClickId())")
        
        // If you need all parameters as a dictionary, you could create one:
        let allParams: [String: String] = [
            "url": result.getUrl(),
            "message": result.getMessage(),
            "ad": result.getAd(),
            "adId": result.getAdId(),
            "camp": result.getCamp(),
            "campId": result.getCampId(),
            "adSet": result.getAdSet(),
            "adSetId": result.getAdSetId(),
            "channel": result.getChannel(),
            "p1": result.getP1(),
            "p2": result.getP2(),
            "p3": result.getP3(),
            "p4": result.getP4(),
            "p5": result.getP5(),
            "clickId": result.getClickId(),
            "dlv": result.getDlv(),
            "pid": result.getPid(),
            "sdkParams": result.getSDKParams()
        ]
        
        print("All parameters: \(allParams)")
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        /*While Initializing the Sdk, You need to pass the two arguments in the TrackierSDKConfig.
         * In First argument, you need to pass the Trackier SDK api key
        * In second argument, you need to pass the environment which can be either "development", "production" or "testing". */
        
        let config = TrackierSDKConfig(appToken: "b551b474-e91c-470e-900b-971e5b954169", env: TrackierSDKConfig.ENV_DEVELOPMENT)
        config.setDeeplinkListerner(listener: self)
        //TrackierSDK.updatePostbackConversion(conversionValue: 0)
        TrackierSDK.waitForATTUserAuthorization(timeoutInterval: 20)
        
<<<<<<< HEAD
        // Configure SKAN properly
        config.setSKANAid("eGfidWe3Ea")
            .setSKANBaseURL("https://apptrovesn.com/api/v2")
        config.setDebugMode(true)
        TrackierSDK.registerSKAdNetwork()
        TrackierSDK.initialize(config: config)
        setupSKANDebugging()

        return true
    }
    
=======
        config.setDebugMode(true)
                    .setSKANMinimumRevenueDelta(2.0)
                    .setSKANMaximumUpdateFrequency(7200)
                    .setSKANAutomaticSessionTracking(true)
                    .setSKANRegisterForAttribution(true)

        // Configure SKAN properly
 
        TrackierSDK.registerSKAdNetwork()
        TrackierSDK.initialize(config: config)
        setupSKANDebugging()
        
        // Fixed: Verify SKAN registration with delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    let (fine, coarse) = TrackierSDK.getCurrentSKANValues()
                    print("Initial SKAN Values - Fine: \(fine ?? -1), Coarse: \(coarse ?? "none")")
                }

        
        return true
    }
    
    
    
>>>>>>> cca9e48 (feat : fixed log issues)
    // MARK: - SKAN Debugging
    
    private func setupSKANDebugging() {
        #if DEBUG
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
<<<<<<< HEAD
            self.testSKANConversionValues()
=======
            self.testSKANIntegration()
>>>>>>> cca9e48 (feat : fixed log issues)
        }
        #endif
    }
    
    
<<<<<<< HEAD
    
    private func testSKANConversionValues() {
        let testScenarios = [
            (revenue: 10.0, eventId: "app_launch"),
            (revenue: 25.0, eventId: "tutorial_complete"),
            (revenue: 50.0, eventId: "first_purchase")
        ]
        
        testScenarios.forEach { scenario in
            DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 1...3)) {
                print("Testing SKAN Conversion: \(scenario.eventId) - $\(scenario.revenue)")
                TrackierSDK.updateSKANConversion(
                    revenue: scenario.revenue,
                    eventId: scenario.eventId
                ) { success, error in
                    if let error = error {
                        print("SKAN Update Error: \(error.localizedDescription)")
                    } else {
                        let (fine, coarse) = TrackierSDK.getCurrentSKANValues()
                        print("Current Values - Fine: \(fine ?? 0), Coarse: \(coarse ?? "none")")
=======
    private func testSKANIntegration() {
            print("Starting SKAN integration tests")
            
            let testScenarios = [
                (revenue: 10.0, eventId: "app_launch"),
                (revenue: 25.0, eventId: "tutorial_complete"),
                (revenue: 50.0, eventId: "first_purchase")
            ]
            
            // Fixed: Proper sequencing with enumerated delays
            testScenarios.enumerated().forEach { (index, scenario) in
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 2) {
                    print("Testing SKAN Conversion: \(scenario.eventId) - $\(scenario.revenue)")
                    TrackierSDK.updateSKANConversion(
                        revenue: scenario.revenue,
                        eventId: scenario.eventId
                    ) { success, error in
                        if success {
                            let (fine, coarse) = TrackierSDK.getCurrentSKANValues()
                            print("Updated SKAN Values - Fine: \(fine ?? -1), Coarse: \(coarse ?? "none")")
                        } else if let error = error {
                            print("SKAN Update Error: \(error.localizedDescription)")
                        }
>>>>>>> cca9e48 (feat : fixed log issues)
                    }
                }
            }
        }
<<<<<<< HEAD
    }

=======
     
>>>>>>> cca9e48 (feat : fixed log issues)
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        TrackierSDK.trackSession()
//        if #available(iOS 14, *) {
//            ATTrackingManager.requestTrackingAuthorization { status in
//                switch status {
//                case .authorized:
//                    // Tracking authorization dialog was shown
//                    // and we are authorized
//                    print("Authorized")
//                    // Now that we are authorized we can get the IDFA
//                    //print(ASIdentifierManager.shared().advertisingIdentifier)// //e2cf9ba1-0fac-44d0-afe2-8a15164126bb
//                case .denied:
//                    // Tracking authorization dialog was
//                    // shown and permission is denied
//                    print("Denied")
//                case .notDetermined:
//                    // Tracking authorization dialog has not been shown
//                    print("Not Determined")
//                case .restricted:
//                    print("Restricted")
//                @unknown default:
//                    print("Unknown")
//                }
//            }
//        } else {
//            // Fallback on earlier versions
//        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

