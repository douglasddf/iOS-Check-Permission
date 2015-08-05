//
//  Created by Douglas Frari on 7/13/15.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2015 Douglas Frari
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h> // localization API


/**
 * Type for request the location authorization (AlwaysAuthorization or WhenInUseAuthorization)
 */
enum AuthorizeRequestType {
    
    AuthorizeRequestTypeAlwaysAuthorization = 1,
    AuthorizeRequestTypeWhenInUseAuthorization = 2    
};


@interface IOSCheckPermissions : NSObject

/**
 *  Get the global instance of ios-check-permission library.
 *
 *  @return instance of IOSCheckPermissions
 */
+(instancetype)globalInstance;


/**
 *  Enable logs for using the library with monitoring of your functionality. 
 *  The default is NO.
 *
 *  @param enableLogs YES for enable or NO to disable logs.
 */
-(void)enableCheckPermissionLogs:(BOOL)enableLogs;

/**
 *  Requests permission to access the operating system's Calendar.
 *
 *  @param successBlock Notifies success if permission was previously granted.
 *  @param failureBlock Notifies fault if permission was not granted.
 */
-(void)checkPermissionAccessForCalendar:(void(^)(void))successBlock
                           failureBlock:(void(^)(void))failureBlock;

/**
 *  Requests permission to access the operating system's calendar with notification of the status not
 *  determined until receive the user's permission.
 *
 *  @param successBlock             Notifies success if permission was previously granted.
 *  @param failureBlock             Notifies fault if permission was not granted.
 *  @param statusNotDeterminedBlock The status not determined before receive the user's permission.
 */
-(void)checkPermissionAccessForCalendar:(void(^)(void))successBlock
                           failureBlock:(void(^)(void))failureBlock
       authorizationStatusNotDetermined:(void(^)(void))statusNotDeterminedBlock;

/**
 *  Requests permission to access the operating system's Reminder.
 *
 *  @param successBlock Notifies success if permission was previously granted.
 *  @param failureBlock Notifies fault if permission was not granted.
 */
-(void)checkPermissionAccessForReminder:(void(^)(void))successBlock
                           failureBlock:(void(^)(void))failureBlock;


/**
 *  Requests permission to access the operating system's Reminder with notification of the status not
 *  determined until receive the user's permission.
 *
 *  @param successBlock             Notifies success if permission was previously granted.
 *  @param failureBlock             Notifies fault if permission was not granted.
 *  @param statusNotDeterminedBlock The status not determined before receive the user's permission.
 */
-(void)checkPermissionAccessForReminder:(void(^)(void))successBlock
                           failureBlock:(void(^)(void))failureBlock
       authorizationStatusNotDetermined:(void(^)(void))statusNotDeterminedBlock;


/**
 *  Requests permission to access the operating system's Gallery.
 *
 *  @param successBlock Notifies success if permission was previously granted.
 *  @param failureBlock Notifies fault if permission was not granted.
 */
-(void)checkPermissionAccessForGallery:(void (^) (void))successBlock
                           failureBlock:(void (^) (void))failureBlock;


/**
 *  Requests permission to access the operating system's Gallery with notification of the status not
 *  determined until receive the user's permission.
 *
 *  @param successBlock             Notifies success if permission was previously granted.
 *  @param failureBlock             Notifies fault if permission was not granted.
 *  @param statusNotDeterminedBlock The status not determined before receive the user's permission.
 */
-(void)checkPermissionAccessForGallery:(void (^) (void))successBlock
                           failureBlock:(void (^) (void))failureBlock
       authorizationStatusNotDetermined:(void(^)(void))statusNotDeterminedBlock;


/**
 *  Requests permission to access the operating system's Location.
 *
 *  @param type            enum type for request the location authorization (AlwaysAuthorization or WhenInUseAuthorization)
 *  @param successBlock    Notifies success if permission was previously granted.
 *  @param failureBlock    Notifies fault if permission was not granted.
 */
-(void)checkPermissionAccessForLocation:(enum AuthorizeRequestType) type
                                                  successBlock:(void (^) (void))successBlock
                                                  failureBlock:(void (^) (void))failureBlock;

@end
