# iOS-Check-Permission

[![CI Status](http://img.shields.io/travis/Douglas Frari/iOS-Check-Permission.svg?style=flat)](https://travis-ci.org/Douglas Frari/iOS-Check-Permission)
[![Version](https://img.shields.io/cocoapods/v/iOS-Check-Permission.svg?style=flat)](http://cocoapods.org/pods/iOS-Check-Permission)
[![License](https://img.shields.io/cocoapods/l/iOS-Check-Permission.svg?style=flat)](http://cocoapods.org/pods/iOS-Check-Permission)
[![Platform](https://img.shields.io/cocoapods/p/iOS-Check-Permission.svg?style=flat)](http://cocoapods.org/pods/iOS-Check-Permission)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

iOS-Check-Permission is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "iOS-Check-Permission"
```

## Author

Douglas Frari, douglas.frari@cesar.org.br

## License

iOS-Check-Permission is available under the MIT license. See the LICENSE file for more info.


See more on Youtube video:

- https://www.youtube.com/watch?v=JxdlaEp6dC0

<a href="https://www.youtube.com/embed/JxdlaEp6dC0"><img src="screenshot3.png" width="800"></a>

There are 7 methods to use in the library:

<pre>
- (void)checkPermissionAccessForCalendar:(void(^)(void))successBlock 
                             failureBlock:(void(^)(void))failureBlock;
                           
- (void)checkPermissionAccessForCalendar:(void(^)(void))successBlock
                           failureBlock:(void(^)(void))failureBlock
       authorizationStatusNotDetermined:(void(^)(void))statusNotDeterminedBlock;

- (void)checkPermissionAccessForReminder:(void(^)(void))successBlock
                             failureBlock:(void(^)(void))failureBlock;

- (void)checkPermissionAccessForReminder:(void(^)(void))successBlock
                             failureBlock:(void(^)(void))failureBlock
         authorizationStatusNotDetermined:(void(^)(void))statusNotDeterminedBlock;

- (void)checkPermissionAccessForGallery:(void (^) (void))successBlock
                             failureBlock:(void (^) (void))failureBlock;

- (void)checkPermissionAccessForGallery:(void (^) (void))successBlock
                            failureBlock:(void (^) (void))failureBlock
        authorizationStatusNotDetermined:(void(^)(void))statusNotDeterminedBlock;
        
- (void)checkPermissionAccessForLocation:(CLLocationManager *)locationManager
                                          authorizeRequestType: (enum AuthorizeRequestType) type
                                                  successBlock:(void (^) (void))successBlock
                                                  failureBlock:(void (^) (void))failureBlock;
        
</pre>

<img src="screenshot01.png" width="400">

Requests permission to access the operating system's (Calendar | Reminder | Gallery), with
 option of receive the notification of the status not determined until receive the user's permission.

Example of use:

<img src="screenshot02.png" width="800"> 
