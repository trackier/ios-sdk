# trackier-ios-sdk

[![Version](https://img.shields.io/cocoapods/v/trackier-ios-sdk.svg?style=flat)](https://cocoapods.org/pods/trackier-ios-sdk)
[![License](https://img.shields.io/cocoapods/l/trackier-ios-sdk.svg?style=flat)](https://cocoapods.org/pods/trackier-ios-sdk)
[![Platform](https://img.shields.io/cocoapods/p/trackier-ios-sdk.svg?style=flat)](https://cocoapods.org/pods/trackier-ios-sdk)

## Table of Content

### Requirements

* [Example](#qs-add-example)
* [Installation](#qs-installation)
* [Implement and initialize the SDK](#qs-implement-sdk)
* [Retrieve your dev key](#qs-retrieve-dev-key)
    * [Initialize the SDK](#qs-initialize-sdk)
    * [Associate User Info during initialization of sdk](#qs-add-user-info)
* [Track Events](#qs-trackier-event)
    * [Retrieve Event Id from dashboard](#qs-retrieve-event-id)
    * [Track Event](#qs-track-simple-event)
    * [Track with Currency & Revenue Event](#qs-track-currency-event)
    * [Add custom params with event](#qs-add-custome-param-event)

## <a id="qs-add-example"></a>Example

To run the example project, clone the repo, and run pod install from the Example directory first. If you're new to CocoaPods, see their [official documentation](https://guides.cocoapods.org/using/using-cocoapods) for info on how to create and use Pod Files.

## <a id="qs-installation"></a>Installation

trackier-ios-sdk is available through [CocoaPods](https://cocoapods.org/). To install it, simply add the following line to your Podfile:

```ruby
    pod 'trackier-ios-sdk'
```
## <a id="qs-implement-sdk"></a>Implement and initialize the SDK

### <a id="qs-retrieve-dev-key"></a>Retrieve your dev key

<img width="1210" alt="Screenshot 2021-08-03 at 3 13 00 PM" src="https://user-images.githubusercontent.com/34488320/127995061-b9cd8899-7236-441c-b594-3ce83aa54c0b.png">

## <a id="qs-initialize-sdk"></a>Initialize the SDK

<p>We recommend initializing the SDK inside the AppDelegate.swift. This allows the SDK to
initialize in all scenarios, including deep linking.
The steps listed below take place inside the AppDelegate.swift .
</p>

### Inside the AppDelegate.swift
### NOTE 
<p>It is crucial to use the correct dev key when initializing the SDK. Using the wrong dev key or an incorrect dev key impacts all traffic sent from the SDK and causes attribution and reporting issues.</p>

```swift
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let config = TrackierSDKConfig(appToken: "xxxx-xx-xxx-xxx", env: TrackierSDKConfig.ENV_DEVELOPMENT)
        TrackierSDK.initialize(config: config)
        return true
    }
```

## <a id="qs-add-user-info"></a>Associate User Info during initialization of SDK

To assosiate Customer Id , Customer Email and Customer additional params during initializing sdk

```swift
    // Override point for customization after application launch.
    let config = TrackierSDKConfig(appToken: "xxxx-xx-xxx-xxx", env: TrackierSDKConfig.ENV_DEVELOPMENT)
    TrackierSDK.setUserId(XXXXXXXX)
    TrackierSDK.setUserEmail(“abc@gmail.com”)
    TrackierSDK.initialize(config: config)
```

### Note

<p>For additional user details , make a dictonary and pass it in setUserAdditionalDetails function</p>

```swift
    val userAdditionalDetails = Dictionary <String,AnyObject>()
    userAdditionalDetails.["userMobile",99XXXXXXXX]
    TrackierSDK.setUserAdditionalDetails(userAdditionalDetails)	
```



## <a id="qs-trackier-event"></a>Track Events

### <a id="qs-retrieve-event-id"></a>Retrieve Event Id from dashboard
<br></br>
<img width="1725" alt="Screenshot 2021-08-03 at 3 25 55 PM" src="https://user-images.githubusercontent.com/34488320/127996772-5e760e26-addc-499b-a7c6-de3ef2d0288c.png">

## <a id="qs-track-simple-event"></a>Track Simple Event

```swift
    let event = TrackierEvent(id: TrackierEvent.PURCHASE)
    event.addEventValue(prop: "purchaseId", val: "PurchaseId Param")
    event.addEventValue(prop: "purchasePnr", val: "Purchase Pnr Param")
    event.param1 = "this is a param1 value"
    DispatchQueue.global().async {
     sleep(1)
     TrackierSDK.trackEvent(event: event)
    }
```

## <a id="qs-track-currency-event"></a>Track with Currency & Revenue Event

```swift
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

## <a id="qs-add-custome-param-event"></a>Add custom params with event

```swift
event.addEventValue(“customeValue1”,”XXXXX”);
event.addEventValue(“customeValue2”,”XXXXX”);
    DispatchQueue.global().async {
       sleep(1)
       TrackierSDK.trackEvent(event: event)
    }
```


    

