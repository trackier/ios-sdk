# trackier-ios-sdk

[![Version](https://img.shields.io/cocoapods/v/trackier-ios-sdk.svg?style=flat)](https://cocoapods.org/pods/trackier-ios-sdk)
[![License](https://img.shields.io/cocoapods/l/trackier-ios-sdk.svg?style=flat)](https://cocoapods.org/pods/trackier-ios-sdk)
[![Platform](https://img.shields.io/cocoapods/p/trackier-ios-sdk.svg?style=flat)](https://cocoapods.org/pods/trackier-ios-sdk)

## Table of Content

### Requirements

* [Quick start guide ](#qs-add-start-guide)
* [Installation](#qs-installation)
* [Integrate and Initialize the Trackier SDK](#qs-implement-sdk)
* [Retrieve your dev key](#qs-retrieve-dev-key)
    * [Initialize the SDK](#qs-initialize-sdk)
    * [Associate User Info during initialization of sdk](#qs-add-user-info)
* [SDK Signing](#qs-sdk-signing)
* [Events Tracking](#qs-trackier-event)
    * [Retrieve Event Id from dashboard](#qs-retrieve-event-id)
    * [Built-in events Tracking](#qs-built-in-events-tracking)
    * [Customs events Tracking](#qs-customs-events-tracking)
    * [Revenue Event Tracking](#qs-revenue-event)
    * [Pass the custom params in events](#qs-add-custome-param-event)


## <a id="qs-add-start-guide"></a>Quick start guide

We have created a example app for the Ios sdk integration. 

Please check the [Example](https://github.com/trackier/ios-sdk/tree/master/Example) directory for know to how the `Trackier IOS SDK` can be integrated.

To run the example project, clone the repo, and run pod install from the Example directory first. If you're new to CocoaPods, see their [official documentation](https://guides.cocoapods.org/using/using-cocoapods) for info on how to create and use Pod Files.

## <a id="qs-installation"></a>Installation

trackier-ios-sdk is available through [CocoaPods](https://cocoapods.org/). To install it, simply add the following line to your Podfile:

```ruby
    pod 'trackier-ios-sdk'
```

## <a id="qs-implement-sdk"></a>Integrate and Initialize the Trackier SDK

### <a id="qs-retrieve-dev-key"></a>Retrieve your dev key

For initialising the Trackier SDk. First, We need to generate the Sdk key from the Trackier MMP panel.

Following below are the steps to retrieve the development key:-

- Login your Trackier Panel
- Select your application and click on Action button and login as
- In the Dashboard, Click on the` SDK Integration` option on the left side of panel. 
- under on the SDK Integration, You will be get the SDK Key.

After follow all steps, Your SDK key look like the below screenshot

Screenshot[1]

<img width="1000" alt="Screenshot 2022-06-10 at 3 46 48 PM" src="https://user-images.githubusercontent.com/16884982/173044860-a540706c-ad10-4174-aaf0-7cf9290fc949.png">


## <a id="qs-initialize-sdk"></a>Initialize the SDK

<p>We recommend initializing the SDK inside the AppDelegate.swift. This allows the SDK to
initialize in all scenarios, including deep linking.
The steps listed below take place inside the AppDelegate.swift .
</p>

#### AppDelegate.swift

**Note** - It is crucial to use the correct dev key when initializing the SDK. Using the wrong dev key or an incorrect dev key impacts all traffic sent from the SDK and causes attribution and reporting issues.

```swift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        /*While Initializing the Sdk, You need to pass the two arguments in the TrackierSDKConfig.
         * In First argument, you need to pass the Trackier SDK api key
        * In second argument, you need to pass the environment which can be either "development", "production" or "testing". */
        
        let config = TrackierSDKConfig(appToken: "xxxx-xx-xxx-xxx", env: TrackierSDKConfig.ENV_DEVELOPMENT) //Pass your Trackier sdk api key
        TrackierSDK.initialize(config: config)
        return true
    }   
}


```

Below are the screenshot of the code:-

Screenshot[2]

<img width="1000" alt="Screenshot 2022-07-04 at 12 20 38 AM" src="https://user-images.githubusercontent.com/16884982/177053392-62aae4d6-2e7f-4eaf-a530-29d538a3cefc.png">



## <a id="qs-trackier-event"></a>Events Tracking

<a id="qs-retrieve-event-id"></a>Trackier events trackings enable to provides the insights into how to user interacts with your app. 
Trackier sdk easily get that insights data from the app. Just follow with the simple events integration process

Trackier provides the `Built-in events` and `Customs events` on the Trackier panel.

#### <a id="qs-built-in-events-tracking"></a>**Built-in Events** - 

Predefined events are the list of constants events which already been created on the dashboard. 

You can use directly to track those events. Just need to implements events in the app projects.

Screenshot[3]

<img width="1000" alt="Screenshot 2022-06-10 at 1 23 01 PM" src="https://user-images.githubusercontent.com/16884982/173018185-3356c117-8b9f-46d1-bfd5-c41653f9ac9e.png">

#### Example code for calling Built-in events


```swift

/*
 * Event Tracking
  <------------->
 * The below code is the example to pass a event to the Trackier SDK.
 * This event requires only 1 Parameter which is the Event ID.
 * Below are the example of built-in events function calling
 * The arguments - "TrackierEvent.LOGIN" passed in the Trackier event class is Events id
 *
 */


func eventsTracking(){

    let event = TrackierEvent(id: TrackierEvent.LOGIN)

 
    /*Below are the function for the adding the extra data,
      You can add the extra data like login details of user or anything you need.
      We have 10 params to add data, Below 5 are mentioned*/

    event.param1 = "this is a param1 value"
    event.param2 = "this is a param2 value"
    event.param3 = "this is a param3 value"
    event.param4 = "this is a param4 value"
    event.param5 = "this is a param5 value"
    DispatchQueue.global().async {
        sleep(1)
        TrackierSDK.trackEvent(event: event)
}
    
}

```

Note:- Argument in Trackier event class is event Id.

You can integrate inbuilt params with the event. In-built param list are mentioned below:-

orderId, revenue, currency, param1, param2, param3 ,param4, param5, param6, param7, param8, param9, param10.

Below are the screenshot of following example:-

Screenshot[4]

<img width="1000" alt="Screenshot 2022-07-04 at 2 30 49 PM" src="https://user-images.githubusercontent.com/16884982/177121084-a9056773-f102-433e-b181-f2c67bcc3473.png">


#### <a id="qs-customs-events-tracking"></a> **Customs Events** - 

Customs events are created by user as per their required business logic. 

You can create the events in the Trackier dashboard and integrate those events in the app project.

Screenshot[5]

<img width="1000" alt="Screenshot 2022-06-29 at 4 09 37 PM" src="https://user-images.githubusercontent.com/16884982/176417552-a8c80137-aa1d-480a-81a3-ea1e03172868.png">


#### Example code for calling Customs Events.

```swift

  /*
 * Event Tracking
  <------------->
 * The below code is the example to pass a event to the Trackier SDK.
 * This event requires only 1 Parameter which is the Event ID.
 * Below are the example of customs events function calling for `AppOpen` event name.
 * The arguments - "sEMWSCTXeu" passed in the Trackier event class is Events id 
 *
 */

  func eventsTracking(){
    let event = TrackierEvent(id: "sEMWSCTXeu")
    
    /*Below are the function for the adding the extra data,
      You can add the extra data like login details of user or anything you need.
      We have 10 params to add data, Below 5 are mentioned*/
    
    event.param1 = "this is a param1 value"
    event.param2 = "this is a param2 value"
    event.param3 = "this is a param3 value"
    event.param4 = "this is a param4 value"
    event.param5 = "this is a param5 value"
    DispatchQueue.global().async {
        sleep(1)
        TrackierSDK.trackEvent(event: event)
   }
    
}

```

Also check the screenshots of the above code.

Screenshot[6]

<img width="1000" alt="Screenshot 2022-07-04 at 3 29 36 PM" src="https://user-images.githubusercontent.com/16884982/177131719-4b02d09e-efce-49db-9464-f8346aa24408.png">


### <a id="qs-revenue-event"></a>Revenue Event Tracking

Trackier allow user to pass the revenue data which is generated from the app through Revenue events. It is mainly used to keeping record of generating revenue from the app and also you can pass currency as well.

```swift
    
  func eventsRevenueTracking(){
    
    let event = TrackierEvent(id: TrackierEvent.LOGIN)
    
    //Passing the revenue events be like below example
    event.revenue = 10.0; //Pass your generated revenue here.
    event.currency = "INR";  //Pass your currency here.
    event.orderId = "orderID";
    event.param1 = "param1";
    event.param2 = "param2";
    event.setEventValue("ev1", "eventValue1");
    event.setEventValue("ev2", 1);
    DispatchQueue.global().async {
        sleep(1)
        TrackierSDK.trackEvent(event: event)
}
    
}

```
Below are the screenshot of the above code 

Screenshot[7]

<img width="1000" alt="Screenshot 2022-07-04 at 4 00 22 PM" src="https://user-images.githubusercontent.com/16884982/177137505-b141a9e3-aabe-4439-aaf7-c9fe596b2610.png">



### <a id="qs-add-custome-param-event"></a>Pass the custom params in events



```swift
   func userDetails(){
    
    let event = TrackierEvent(id: TrackierEvent.LOGIN)
    
    /*Passing the UserId and User EmailId Data */
    event.setUserId("XXXXXXXX"); //Pass the UserId values here
    event.setUserEmail("abc@gmail.com"); //Pass the user email id in the argument.
    
    /*Passing the custom value in the events */
    event.addEventValue("customeValue1","XXXXX");
    event.addEventValue("customeValue2","XXXXX");
    
    
    DispatchQueue.global().async {
        sleep(1)
        TrackierSDK.trackEvent(event: event)
}
  }
```

### Passing User Data to SDK

Trackier allows to pass additional data like Userid, Email to SDK so that same can be correlated to the Trackier Data and logs.

Just need to pass the data of User Id, Email Id and other additional data to Trackier sdk function which is mentioned below:-


```swift

func userDetails(){
    
    let event = TrackierEvent(id: TrackierEvent.LOGIN)
    
    /*Passing the UserId and User EmailId Data */
    event.setUserId("XXXXXXXX"); //Pass the UserId values here
    event.setUserEmail("abc@gmail.com"); //Pass the user email id in the argument.
    DispatchQueue.global().async {
        sleep(1)
        TrackierSDK.trackEvent(event: event)
}
  }


```

Below are the screenshots of the above example of Passing custom data and User data to sdk.

Screenshot[8]

<img width="1000" alt="Screenshot 2022-07-04 at 5 49 15 PM" src="https://user-images.githubusercontent.com/16884982/177153481-c5708192-8605-4595-a528-5753a91b90f5.png">


## <a id="qs-add-user-info"></a>Associate User Info during initialization of SDK

To assosiate Customer Id , Customer Email and Customer additional params during initializing sdk

```swift
    // Override point for customization after application launch.
    let config = TrackierSDKConfig(appToken: "xxxx-xx-xxx-xxx", env: TrackierSDKConfig.ENV_DEVELOPMENT)
    TrackierSDK.setUserId(XXXXXXXX)
    TrackierSDK.setUserEmail("abc@gmail.com")
    TrackierSDK.initialize(config: config)
```

#### Note

<p>For additional user details , make a dictonary and pass it in setUserAdditionalDetails function</p>

```swift
    val userAdditionalDetails = Dictionary <String,AnyObject>()
    userAdditionalDetails.["userMobile",99XXXXXXXX]
    TrackierSDK.setUserAdditionalDetails(userAdditionalDetails)	
```

## <a id="qs-sdk-signing"></a>SDK Signing
```swift
let config = TrackierSDKConfig(appToken: "xx-182a-4584-aca3-xx", env: TrackierSDKConfig.ENVIRONMENT_PRODUCTION)
config.setAppSecret(secretId: "xxxx", secretKey: "xxx-xx")
```




 
