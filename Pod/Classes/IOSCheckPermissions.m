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

#import "IOSCheckPermissions.h"

@interface IOSCheckPermissions() <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManagerFromLib;
@property (assign,nonatomic) BOOL checkingLocationPermission;
@property (assign,nonatomic) enum AuthorizeRequestType type;
@property (strong,nonatomic) id localizationFailureBlock;
@property (strong,nonatomic) id localizationSuccessBlock;
@property (assign,nonatomic) CLAuthorizationStatus authorizationStatus;

@end

@implementation IOSCheckPermissions

static BOOL isEnableLogs = NO;


+ (instancetype)globalInstance {
    static IOSCheckPermissions *sharedInstance;
    
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [[self alloc] init];
        }
    }
    return sharedInstance;
}


-(void)enableCheckPermissionLogs:(BOOL)enableLogs {
    isEnableLogs = enableLogs;
    
    if (isEnableLogs) {
        NSLog(@"- the log message was enable on iOS-Check-Permission -");
    }
}


#pragma mark - Calendar

-(void)checkPermissionAccessForCalendar:(void(^)(void))successBlock
                           failureBlock:(void(^)(void))failureBlock {
    
    [self checkPermissionAccessForCalendar:successBlock
                                          failureBlock:failureBlock
                      authorizationStatusNotDetermined:^{}];
}


-(void)checkPermissionAccessForCalendar:(void(^)(void))successBlock
                           failureBlock:(void(^)(void))failureBlock
       authorizationStatusNotDetermined:(void(^)(void))statusNotDeterminedBlock {
    
    
    @try {
        EKAuthorizationStatus authorizationStatus = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
        
        switch (authorizationStatus) {
            case EKAuthorizationStatusAuthorized:
                if (successBlock) {
                    if (isEnableLogs) {
                        NSLog(@"- checkPermissionAccessForCalendar - successBlock (status: Authorized)");
                    }
                    
                    successBlock();
                }
                break;
            case EKAuthorizationStatusRestricted:
            case EKAuthorizationStatusDenied:
                if (isEnableLogs) {
                    NSLog(@"- checkPermissionAccessForCalendar - failureBlock (status: Restricted or Denied)");
                }
                failureBlock();
                break;
            case EKAuthorizationStatusNotDetermined:
            {
                EKEventStore *eventStore = [[EKEventStore alloc] init];
                
                statusNotDeterminedBlock();
                
                [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
                    if(error && isEnableLogs) {
                        NSLog(@"- checkPermissionAccessForCalendar - %@", [error description]);
                        failureBlock();
                    }
                    
                    if (granted) {
                        if (successBlock) {
                            if (isEnableLogs) {
                                NSLog(@"- checkPermissionAccessForCalendar - successBlock (permission granted)");
                            }
                            
                            successBlock();
                        }
                    } else {
                        if (isEnableLogs) {
                            NSLog(@"- checkPermissionAccessForCalendar - failureBlock (permission not granted)");
                        }
                        failureBlock();
                    }
                }];
            }
                break;
        }
    } @catch (NSException *exception) {
        [self printException:exception withText:@"- checkPermissionAccessForCalendar -"];
        failureBlock();
    }
}


#pragma mark - Gallery

- (void)checkPermissionAccessForGallery:(void (^) (void))successBlock
                           failureBlock:(void (^) (void))failureBlock {
    
    [self checkPermissionAccessForGallery:successBlock
                                         failureBlock:failureBlock
                     authorizationStatusNotDetermined:^{}];
    
}

- (void)checkPermissionAccessForGallery:(void (^) (void))successBlock
                           failureBlock:(void (^) (void))failureBlock
       authorizationStatusNotDetermined:(void(^)(void))statusNotDeterminedBlock {
    
    
    @try {
        ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
        
        if (authStatus == AVAuthorizationStatusAuthorized) {
            if (successBlock) {
                if (isEnableLogs) {
                    NSLog(@"- checkPermissionAccessForGallery - successBlock (status: Authorized)");
                }
                successBlock();
            }
            
        } else if (authStatus == AVAuthorizationStatusNotDetermined) {
            
            statusNotDeterminedBlock();
            
            ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
            [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                // call success block only when group is nil, because here will be enumerated all device´s gallery items
                if(!group) {
                    if (successBlock) {
                        if (isEnableLogs) {
                            NSLog(@"- checkPermissionAccessForGallery - successBlock (permission granted)");
                        }
                        successBlock();
                    }
                }
            }
             
                                       failureBlock:^(NSError *error) {
                                           if (isEnableLogs) {
                                               NSLog(@"- - checkPermissionAccessForGallery - failureBlock (%@)", [error description]);
                                           }
                                           failureBlock();
                                       }];
            
        } else {
            if (isEnableLogs) {
                NSLog(@"- - checkPermissionAccessForGallery - failureBlock (status: Restricted or Denied)");
            }
            failureBlock();
        }
    } @catch (NSException *exception) {
        [self printException:exception withText:@"- - checkPermissionAccessForGallery -"];
        failureBlock();
    }
    
}


#pragma mark - Reminder

-(void)checkPermissionAccessForReminder:(void(^)(void))successBlock failureBlock:(void(^)(void))failureBlock {
    
    [self checkPermissionAccessForReminder:successBlock
                                          failureBlock:failureBlock
                      authorizationStatusNotDetermined:^{}];
}

-(void)checkPermissionAccessForReminder:(void(^)(void))successBlock
                           failureBlock:(void(^)(void))failureBlock
       authorizationStatusNotDetermined:(void(^)(void))statusNotDeterminedBlock {
    
    @try {
        EKAuthorizationStatus authorizationStatus = [EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder];
        switch (authorizationStatus) {
            case EKAuthorizationStatusAuthorized:
                
                if (successBlock) {
                    if (isEnableLogs) {
                        NSLog(@"- checkPermissionAccessForReminder - successBlock (status: Authorized)");
                    }
                    successBlock();
                }
                break;
            case EKAuthorizationStatusRestricted:
            case EKAuthorizationStatusDenied:
                if (isEnableLogs) {
                    NSLog(@"- checkPermissionAccessForReminder - failureBlock (status: Restricted or Denied)");
                }
                failureBlock();
                break;
            case EKAuthorizationStatusNotDetermined: {
                
                statusNotDeterminedBlock();
                
                EKEventStore *eventStore = [[EKEventStore alloc] init];
                [eventStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError *error) {
                    if(error && isEnableLogs) {
                        NSLog(@"- - checkPermissionAccessForReminder - %@", [error description]);
                        failureBlock();
                    }
                    
                    if (granted) {
                        if (isEnableLogs) {
                            NSLog(@"- checkPermissionAccessForReminder - successBlock (permission granted)");
                        }
                        if (successBlock) {
                            successBlock();
                        }
                        
                    } else {
                        if (isEnableLogs) {
                            NSLog(@"- checkPermissionAccessForReminder - failureBlock (permission not granted)");
                        }
                        failureBlock();
                    }
                }];
            }
                break;
        }
    } @catch (NSException *exception) {
        
        [self printException:exception withText:@"- - checkPermissionAccessForReminder -"];
        failureBlock();
    }
    
}




#pragma mark - Location

-(void)checkPermissionAccessForLocation:(enum AuthorizeRequestType) type
                           successBlock:(void (^) (void))successBlock
                           failureBlock:(void (^) (void))failureBlock {

    @try {
        
        if(![CLLocationManager locationServicesEnabled]) {
            if (isEnableLogs) {
                NSLog(@"- failureBlock - (location services aren't enabled on the device.)");
            }
            failureBlock();
            return;
        }

        if (!self.locationManagerFromLib) {
            self.locationManagerFromLib = [[CLLocationManager alloc] init];//locationManager;
            self.locationManagerFromLib.delegate = self;
        }
        
        self.type = type;
        self.localizationFailureBlock = failureBlock;
        self.localizationSuccessBlock = successBlock;
        [self verifyAuthorizationLocation:self.locationManagerFromLib type:type failureBlock:failureBlock successBlock:successBlock];
        
    }
    @catch (NSException *exception) {
        
        [self printException:exception withText:@"- checkPermissionAccessForLocation -"];
        failureBlock();
    }
    
}



#pragma mark - Private methods

/**
 *  Catching any unexpected problem due to accessing unnauthorized resources to avoid crash. 
 *  e.g. Settings/restrictions denied access
 *
 *  @param exception <#exception description#>
 *  @param text      <#text description#>
 */
-(void)printException:(NSException *)exception withText:(NSString*)text {
    if (isEnableLogs) {
        NSLog(@"%@ %@",text,[exception description]);
    }
}

/**
 *  <#Description#>
 *
 *  @param locationManager <#locationManager description#>
 *
 *  @return <#return value description#>
 */
- (BOOL)requestAlwaysAuthorization:(CLLocationManager *)locationManager
{
    BOOL result = NO;
    
    if(![[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"]) {
        NSLog(@"-> Info.plist does not contain 'NSLocationAlwaysUsageDescription' key <-");
    } else {
        result = YES;
    }
    
    if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        //iOS 8+
        [locationManager requestAlwaysAuthorization];
        self.checkingLocationPermission = result;
    }
    
    return result;
}

/**
 *  <#Description#>
 *
 *  @param locationManager <#locationManager description#>
 *
 *  @return <#return value description#>
 */
- (BOOL)requestWhenInUseAuthorization:(CLLocationManager *)locationManager
{
    BOOL result = NO;
    
    if(![[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]) {
        NSLog(@"-> Info.plist does not contain 'NSLocationWhenInUseUsageDescription' key <-");
    } else {
        result = YES;
    }
    
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        //iOS 8+
        [locationManager requestWhenInUseAuthorization];
        self.checkingLocationPermission = result;
    }
    
    return result;
}

/**
 *  <#Description#>
 *
 *  @param locationManager <#locationManager description#>
 *  @param type            <#type description#>
 *  @param failureBlock    <#failureBlock description#>
 *  @param successBlock    <#successBlock description#>
 */
- (void)verifyAuthorizationLocation:(CLLocationManager *)locationManager
                               type:(enum AuthorizeRequestType)type
                       failureBlock:(void (^)())failureBlock
                       successBlock:(void (^)())successBlock {
    @try {
        
        self.authorizationStatus = [CLLocationManager authorizationStatus];
        
        switch (self.authorizationStatus) {
                
            case kCLAuthorizationStatusRestricted:
                if (isEnableLogs) {
                    NSLog(@"- User has location services turned off in Settings (Parental Restrictions) -");
                }
                failureBlock();
                break;
            case kCLAuthorizationStatusAuthorizedAlways:
                if (isEnableLogs) {
                    NSLog(@"- User authorized background use or User has been asked for authorization and tapped “Yes” on iOS 7 and lower -");
                }
                successBlock();
                break;
                
            case kCLAuthorizationStatusAuthorizedWhenInUse:
                if (isEnableLogs) {
                    NSLog(@"- User has authorized use only when the app is in the foreground. -");
                }
                successBlock();
                break;
                
            case kCLAuthorizationStatusDenied:
                if (isEnableLogs) {
                    NSLog(@" - User has been asked for authorization and tapped “No” (or turned off location in Settings) -");
                }
                failureBlock();
                break;
                
            case kCLAuthorizationStatusNotDetermined:
                
                if (isEnableLogs) {
                    NSLog(@"- User hasn't yet been asked to authorize location updates -");
                }
                
                if(NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1 && !self.checkingLocationPermission) {
                    
                    if (type == AuthorizeRequestTypeAlwaysAuthorization) {
                        
                        if(![self requestAlwaysAuthorization:locationManager]) {
                            failureBlock();
                        }
                        
                    } else if (type == AuthorizeRequestTypeWhenInUseAuthorization) {
                        
                        if (![self requestWhenInUseAuthorization:locationManager]) {
                            failureBlock();
                        }
                    }
                }
                
                break;
                
                
            default:
                break;
        }

        
    }
    @catch (NSException *exception) {
        [self printException:exception withText:@"- checkPermissionAccessForLocation -"];
        failureBlock();
    }
    @finally {
        
        if (self.authorizationStatus != kCLAuthorizationStatusNotDetermined) {
            
            if (self.checkingLocationPermission) {
                self.checkingLocationPermission = NO;
            }
            
            // free
            if (self.locationManagerFromLib) {
                self.locationManagerFromLib.delegate = nil;
                self.locationManagerFromLib = nil;
                self.localizationFailureBlock = nil;
                self.localizationSuccessBlock = nil;
                self.type = 0;
                self.locationManagerFromLib = nil;
            }
        }
        
    }
    
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    NSLog(@"-> CLLocationManagerDelegate # didChangeAuthorizationStatus <- (status: %d)",status);
    
    if(self.checkingLocationPermission) {
       [self verifyAuthorizationLocation:self.locationManagerFromLib type:self.type failureBlock:self.localizationFailureBlock successBlock:self.localizationSuccessBlock];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    // Delegate of the location manager, when you have an error
    NSLog(@"-> CLLocationManagerDelegate <- # didFailWithError: %@", error);
}

@end
