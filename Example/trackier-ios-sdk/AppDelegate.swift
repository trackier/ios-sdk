//
//  AppDelegate.swift
//  trackier-ios-sdk
//
//  Created by Trackier on 03/18/2021.
//  Copyright (c) 2021 Trackier. All rights reserved.
//

import UIKit
import trackier_ios_sdk
import AppTrackingTransparency

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, DeepLinkListener {

    var window: UIWindow?
    
    func onDeepLinking(result: DeepLink) -> Void {
        print("==result: \(result.getUrlParams()))")
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        /*While Initializing the Sdk, You need to pass the two arguments in the TrackierSDKConfig.
         * In First argument, you need to pass the Trackier SDK api key
        * In second argument, you need to pass the environment which can be either "development", "production" or "testing". */
        
        let config = TrackierSDKConfig(appToken: "xxxx-xx-xxx-xxx", env: TrackierSDKConfig.ENV_DEVELOPMENT) //Pass your Trackier sdk api key
        config.setDeeplinkListerner(listener: self)
        //TrackierSDK.updatePostbackConversion(conversionValue: 0)
        TrackierSDK.waitForATTUserAuthorization(timeoutInterval: 20)
        
        // Configure SKAN properly
        config.setSKANAid("eGfidWe3Ea")
            .setSKANBaseURL("https://apptrovesn.com/api/v2")
        config.setDebugMode(true)
        TrackierSDK.registerSKAdNetwork()
        TrackierSDK.initialize(config: config)
        setupSKANDebugging()

        return true
    }
    
    // MARK: - SKAN Debugging
    
    private func setupSKANDebugging() {
        #if DEBUG
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.testSKANConversionValues()
        }
        #endif
    }
    
    
    
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
                    }
                }
            }
        }
    }

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
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    // Tracking authorization dialog was shown
                    // and we are authorized
                    print("Authorized")
                    // Now that we are authorized we can get the IDFA
                    //print(ASIdentifierManager.shared().advertisingIdentifier)// //e2cf9ba1-0fac-44d0-afe2-8a15164126bb
                case .denied:
                    // Tracking authorization dialog was
                    // shown and permission is denied
                    print("Denied")
                case .notDetermined:
                    // Tracking authorization dialog has not been shown
                    print("Not Determined")
                case .restricted:
                    print("Restricted")
                @unknown default:
                    print("Unknown")
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

