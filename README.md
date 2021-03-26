# trackier-ios-sdk

[![Version](https://img.shields.io/cocoapods/v/trackier-ios-sdk.svg?style=flat)](https://cocoapods.org/pods/trackier-ios-sdk)
[![License](https://img.shields.io/cocoapods/l/trackier-ios-sdk.svg?style=flat)](https://cocoapods.org/pods/trackier-ios-sdk)
[![Platform](https://img.shields.io/cocoapods/p/trackier-ios-sdk.svg?style=flat)](https://cocoapods.org/pods/trackier-ios-sdk)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.
If you're new to CocoaPods, see their [official documentation](https://guides.cocoapods.org/using/using-cocoapods) for info on how to create and use Podfiles.

## Requirements

## Installation

trackier-ios-sdk is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'trackier-ios-sdk'
```

## Implement and initialize the SDK
 
### Retrieve your dev key
 
### Initialize the SDK
  
   We recommend initializing the SDK inside the AppDelegate.swift. This allows the SDK to  
   initialize in all scenarios, including deep linking.
 
  The steps listed below take place inside the the AppDelegate.swift .
 
#### Inside the AppDelegate.swift 
 
   Important: it is crucial to use the correct dev key when initializing the SDK. Using the wrong dev key or an     
   incorrect dev key impact all traffic sent from the SDK and cause attribution and reporting issues.
 
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
     // Override point for customization after application launch.
     let config = TrackierSDKConfig(appToken: "xxxx-xx-xxx-xxx", env: TrackierSDKConfig.ENV_DEVELOPMENT)
     TrackierSDK.initialize(config: config)
     return true
    }
 
### Track Events :-
 
#### Retrieve Event Id from dashboard:-
 
 
 
 
#### Track Event :-
   
```
    let event = TrackierEvent(id: TrackierEvent.PURCHASE)
    event.addEventValue(prop: "purchaseId", val: "PurchaseId Param")
    event.addEventValue(prop: "purchasePnr", val: "Purchase Pnr Param")
    event.param1 = "this is a param1 value"
    DispatchQueue.global().async {
     sleep(1)
     TrackierSDK.trackEvent(event: event)
    }
``` 
 
#### Track with Currency & Revenue Event :-
 
```  
    let event = TrackierEvent(id: TrackierEvent.PURCHASE)
    event.addEventValue(prop: "purchaseId", val: "PurchaseId Param")
    event.addEventValue(prop: "purchasePnr", val: "Purchase Pnr Param")
    event.setRevenue(revenue: 120.5, currency: "INR")
    event.param1 = "this is a param1 value"
    DispatchQueue.global().async {
       sleep(1)
       TrackierSDK.trackEvent(event: event)
    }

```

## Author

dev@trackier.com

## License

trackier-ios-sdk is available under the MIT license. See the LICENSE file for more info.
