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
//

#import "DFViewController.h"
#import "IOSCheckPermissions.h" // <-- import the iOS-Check-Permission library

@interface DFViewController ()

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation DFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // enable log message from library
    [[IOSCheckPermissions globalInstance] enableCheckPermissionLogs:YES];
    
    self.title = @"iOS-Check-Permission Demo";
    
    // alloc Location manager for Location permission
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
}


-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (self.locationManager) {
        [self.locationManager stopUpdatingLocation];
    }
}

#pragma mark <Actions>

- (IBAction)requestPermissionForCalendar:(id)sender {
    
    __weak id owner = self;
    
    [[IOSCheckPermissions globalInstance] checkPermissionAccessForCalendar:^{
        
        // SUCCESS
        [owner showAlertWithText:@"Success permission for 'Calendar' :)" hasDelegate:nil];
        
    } failureBlock:^{
        
        // PERMISSION DENIED
        [owner showAlertWithText:@"Your privacy settings are preventing us from accessing yours 'Calendar'. "
                     hasDelegate:owner];
        
    }];
    
}


- (IBAction)requestReminderPermission:(id)sender {
    
    __weak id owner = self;
    
    [[IOSCheckPermissions globalInstance] checkPermissionAccessForReminder:^{
        
        // SUCCESS
        [owner showAlertWithText:@"Success permission for 'Reminder' :)" hasDelegate:nil];
        
    } failureBlock:^{
        
        // PERMISSION DENIED
        [owner showAlertWithText:@"Your privacy settings are preventing us from accessing yours 'Reminder'."
                     hasDelegate:owner];
    }];
}


- (IBAction)requestGalleryPermission:(id)sender {
    
    __weak id owner = self;
    
    [[IOSCheckPermissions globalInstance] checkPermissionAccessForGallery:^{
        
        // SUCCESS
        [owner showAlertWithText:@"Success permission for 'Gallery' :)" hasDelegate:nil];
        
    } failureBlock:^{
        
        // PERMISSION DENIED
        [owner showAlertWithText:@"Your privacy settings are preventing us from accessing yours 'Gallery'."
                     hasDelegate:owner];
        
    }];
}

- (IBAction)requestLocationPermission:(id)sender {
    
    __weak DFViewController * owner = self;
    
    /* User can be choose two enum type for request the location authorization:
     - AuthorizeRequestTypeAlwaysAuthorization
     - AuthorizeRequestTypeWhenInUseAuthorization
     */
    [[IOSCheckPermissions globalInstance] checkPermissionAccessForLocation: AuthorizeRequestTypeWhenInUseAuthorization
                                                              successBlock:^{
                                                                  
                                                                  // SUCCESS
                                                                  [owner showAlertWithText:@"Success permission for 'Location' :)" hasDelegate:nil];
                                                                  
                                                                  [owner.locationManager startUpdatingLocation];
                                                                  
                                                              } failureBlock:^{
                                                                  // PERMISSION DENIED
                                                                  [owner showAlertWithText:@"Your privacy settings are preventing us from accessing yours 'Location'." hasDelegate:owner];
                                                              }];
}

#pragma mark <Private Methods>

-(void) showAlertWithText:(NSString*)text hasDelegate:(DFViewController*)owner{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:owner ? @"Permission denied" : @"Permission granted"
                                                        message:text
                                                       delegate:owner
                                              cancelButtonTitle:owner ? @"Cancel" : @"Ok"
                                              otherButtonTitles:owner ? @"Settings" : nil,
                              nil];
        [alert show];
        
    });
    
}


#pragma mark <UIAlertViewDelegate>

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex > 0) {
        // open settings
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

#pragma mark <CLLocationManagerDelegate>

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    if ([locations count] > 0) {
        NSLog(@"-->> User CLLocationManagerDelegate -->  %@",[locations[0] description]);
    }
}

@end
